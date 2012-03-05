require 'rho'
require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'lib/profiler'

class ApplicationController < Rho::RhoController
  include BrowserHelper
  include Profiler
 

end


