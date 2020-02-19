module GithubGraphqlWrapper
  HTTP = ::GraphQL::Client::HTTP.new("https://api.github.com/graphql") do
    def headers(context)
      { 'Authorization': 'bearer xxxxxx' }
    end

    def connection
      Net::HTTP.new(uri.host, uri.port).tap do |client|
         client.open_timeout = ::Controller::TIMEOUT
         client.read_timeout = ::Controller::TIMEOUT
         client.use_ssl = uri.scheme == "https"
       end
     end
  end

  Schema = ::GraphQL::Client.load_schema(HTTP)
  Client = ::GraphQL::Client.new(schema: Schema, execute: HTTP)
end
