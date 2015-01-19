require 'marsys'
require 'sinatra/base'
require 'json'
require 'slim'

load "agent.rb"
load "environment.rb"
load "core.rb"

class App < Sinatra::Base
  use Rack::Session::Pool
  set :public_folder, File.dirname(__FILE__) + '/static'

  get '/' do
    slim :index
  end

  get '/init/:size/:blue_population/:green_population/:satifaction_rate' do
    options = {
      dimensions:                 params[:size].to_i,
      blue_population:            params[:blue_population].to_i,
      green_population:           params[:green_population].to_i,
      satifaction_rate:           params[:satifaction_rate].to_i
    }
    session[:instance] = Core.new options
    content_type :json
    session[:instance].to_json
  end

  get '/turn' do
    begin
      session[:instance].environment.turn
    rescue => error
      puts error.inspect
    end

    content_type :json
    session[:instance].to_json
  end

  run! if app_file == $0 # run Sinatra
end
