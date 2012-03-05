require 'sinatra'
require 'json'

def ticket(i)
  {
    id: '98379278374928379823749283',
    human_id: i,
    human_id_formatted: "CL-#{i}",
    subject: "Ticket Subject #{i}", 
    description: "Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description Ticket Description lkjasdliweoprqwefpc efedTicket Description #{i}"

  }
end

get '/sync' do
  content_type :json
  {
    data: tickets, 
    form: form,
    validate: 'lambda { Ticket.find(:first)  }'
  }.to_json
end

def tickets
  count = params[:count].nil? ? 10 : params[:count].to_i
  tickets = (1.. count).to_a.reduce([]) do |memo, i|
    memo << ticket(i)
  end

end

def form
  f = <<-eos
    <div data-role="page">

      <div data-role="header" data-position="inline">
        <h1>Tickets</h1>
        <a href="<%= Rho::RhoConfig.start_path %>" class="ui-btn-left" data-icon="home" data-direction="reverse" <%= "data-ajax='false'" if is_bb6 %>>
          Home
        </a>
        <a href="<%= url_for :action => :new %>" class="ui-btn-right" data-icon="plus">
          New
        </a>
      </div>

      <div data-role="content">
        <ul data-role="listview">
          <% @tickets.each do |ticket| %>
          
              <li>
                <a href="<%= url_for :action => :show, :id => ticket.object %>">
                  <%= ticket.human_id_formatted %>asdasdasd
                </a>
              </li>
          
          <% end %>
        </ul>
      </div>

    </div>
  eos
end
