require 'sinatra'
require 'sinatra/param'
require 'json'
require 'rest-client'
require "graphql/client"
require "graphql/client/http"

class Controller < Sinatra::Base
  helpers Sinatra::Param

  TIMEOUT = 30

  set :show_exceptions, :after_handler

  before do
    content_type :json
  end

  error do
    status(500)
    { error: request.env['sinatra.error'] }.to_json
  end
end

require "./lib/github_graphql_wrapper.rb"
Dir[File.dirname(__FILE__) + '/use_cases/*.rb'].each {|file| require file}
Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file}
