# spec/spec_helper.rb
require 'rack/test'
require 'rspec'
require 'webmock/rspec'

require File.expand_path '../../app.rb', __FILE__
require 'support/stub_gitlab.rb'
require 'support/stub_github.rb'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
end


WebMock.disable_net_connect!

#stub all GraphQL requests
::GithubGraphqlWrapper.send(:remove_const, 'HTTP')
::GithubGraphqlWrapper.const_set('HTTP', ::StubGithub)
::GithubGraphqlWrapper.send(:remove_const, 'Client')
::GithubGraphqlWrapper.const_set('Client', GraphQL::Client.new(schema: ::GithubGraphqlWrapper::Schema, execute: ::StubGithub))

RSpec.configure do |config|
  config.include RSpecMixin
  config.before(:each) do
    stub_request(:get, /#{::GitlabProjectsFetcher::GITLAB_DOMAIN}/).to_rack(::StubGitlab)
  end
end
