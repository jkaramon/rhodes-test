require 'application_controller'
require 'erb'
class TicketController < ApplicationController
 

  # GET /Ticket
  def index
    form_data = Form.find(:first)
    t =  eval(form_data.validate, binding, __FILE__, __LINE__).call
    app_info t.inspect
    benchmark 'Retrieving all tickets from db' do
      
      @tickets = Ticket.paginate(
        :page => 0,
        :per_page => 10,
        :conditions => {
          {
            :name => 'description', 
            :op => 'LIKE'
          } => '%1%'
        },
        :order => 'human_id',
        :orderdir => 'DESC'
        )
    end
    app_info form_data.form
    code = ::ERB.new(form_data.form).src
    output = eval(code, binding)
    app_info output

    render :string => output
  end

  # GET /Ticket/{1}
  def show
    @ticket = Ticket.find(@params['id'])
    if @ticket
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Ticket/new
  def new
    @ticket = Ticket.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Ticket/{1}/edit
  def edit
    @ticket = Ticket.find(@params['id'])
    if @ticket
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Ticket/create
  def create
    @ticket = Ticket.create(@params['ticket'])
    redirect :action => :index
  end

  # POST /Ticket/{1}/update
  def update
    @ticket = Ticket.find(@params['id'])
    @ticket.update_attributes(@params['ticket']) if @ticket
    redirect :action => :index
  end

  # POST /Ticket/{1}/delete
  def delete
    @ticket = Ticket.find(@params['id'])
    @ticket.destroy if @ticket
    redirect :action => :index  
  end
end
