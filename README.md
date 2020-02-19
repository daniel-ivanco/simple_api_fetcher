# Simple API Fetcher
### Basic Description
This is a sample Sinatra application fetching and merging projects from multiple resources (Github Graphql and Gitlab REST API JSON endpoints) and exposing them in a JSON structure as libraries.

### Running and using the application
- in the file `github_graphql_wrapper.rb` replace Authorization token `xxxxxx` on line 4 with your own one (it can be generated here https://github.com/settings/tokens)
- in the project root directory run command `docker-compose up`
- the server listens on port 4567, ie fetched results can be seen when visiting `http://localhost:4567/`
- the application accepts 1 optional parameter `language` which filters results based on programming language, ie to fetch libraries only relevant for Ruby programming language visit `http://localhost:4567/?language=ruby`
- the result is structured as `libraries` array where each library contains the following fields
	- `library_url `
	- `username`
	- `name`
	- `description`
	- `source`

### Testing the app
- in the project root directory run command `docker-compose run --rm app bundle exec rspec spec`
- to make tests more stable and performant, REST API and GraphQL requests are mocked and JSON files from `spec/fixtures` are served instead. These files are actual dumbs of Gitlab and Github API endpoints.
