require 'application_controller'
require 'rho/rhoerror'
require 'helpers/browser_helper'

class SettingsController < ApplicationController
  include BrowserHelper

  def index
    @msg = @params['msg']
    render
  end

  def login
    @msg = @params['msg']
    render :action => :login
  end

  def login_callback
    errCode = @params['error_code'].to_i
    if errCode == 0
      # run sync if we were successful
      WebView.navigate Rho::RhoConfig.options_path
    else
      if errCode == Rho::RhoError::ERR_CUSTOMSYNCSERVER
        @msg = @params['error_message']
      end
      if !@msg || @msg.length == 0   
        @msg = Rho::RhoError.new(errCode).message
      end

      WebView.navigate ( url_for :action => :login, :query => {:msg => @msg} )
    end  
  end

  def do_login
    if @params['login'] and @params['password']
      begin
        Rho::AsyncHttp.get(
          :url => "https://sd.vanilladesk.com/vanilladesk/login_api/api_token",
          :headers => {},
          :authentication => {
          :type => :basic, 
          :username => @params['login'], 
          :password => @params['password']
        },
          :callback => url_for(:action => :login_callback)
        )

        @response['headers']['Wait-Page'] = 'true'
        render :action => :wait
      rescue Rho::RhoError => e
        @msg = e.message
        render :action => :login
      end
    else
      @msg = Rho::RhoError.err_message(Rho::RhoError::ERR_UNATHORIZED) unless @msg && @msg.length > 0
      render :action => :login
    end
  end


  def reset
    render :action => :reset
  end

  def do_reset
    Rhom::Rhom.database_full_reset

    @msg = "Database has been reset."
    redirect :action => :index, :query => {:msg => @msg}
  end

  def do_sync
    Rhom::Rhom.database_full_reset
    Alert.vibrate(2500)
    @msg =  "Sync has been triggered."
    host = 'localhost'
    # host = '10.0.2.2'
    Rho::AsyncHttp.get(
      :url => "http://#{host}:4567/sync?count=5",
      :headers => {},
      :callback => (url_for :action => :sync_callback)
    )
    redirect :action => :index, :query => {:msg => @msg}
  end

  def sync_callback 
    json_data = @params["body"]
    app_info json_data.inspect
    benchmark 'Storing all tickets into db' do
      f = Form.new
      f.form = json_data['form']
      f.validate = json_data['validate']
      f.save
      json_data['data'].each do |ticket_hash|
        t = Ticket.new ticket_hash
        t.save
      end
    end
  end

end
