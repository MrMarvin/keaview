require_relative './keaview'

require 'sinatra/base'

class Lease4Controller < Sinatra::Base

  set :views, File.expand_path('../views', __FILE__)

  not_found{ erb :not_found }

  get '/' do
    @subnet_id = params[:subnet_id]
    if @subnet_id
      @lease4s = Lease4.natural_join(:lease_state).where(Sequel.like(:subnet_id, @subnet_id)).order(:expire).all
    else
      @lease4s = Lease4.natural_join(:lease_state).order(:expire).all
    end
    erb :lease4s
  end

end