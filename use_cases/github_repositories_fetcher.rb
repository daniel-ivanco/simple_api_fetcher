class GithubRepositoriesFetcher
  SORT_QUERY_STRING = "sort:updated-desc is:public".freeze
  LANGUAGE_KEY = 'language'.freeze

  REPOSITORIES_QUERY = ::GithubGraphqlWrapper::Client.parse <<-'GRAPHQL'
  query ($item_count: Int, $query_string: String!) {
    search(query: $query_string, type: REPOSITORY, first: $item_count) {
      edges {
        node {
          ... on Repository {
            id
            name
            description
            updatedAt
            url
            owner {
              ... on User {
                name
              }
            }
            languages(first: 1, orderBy: {field: SIZE, direction: DESC}) {
              nodes {
                name
              }
            }
          }
        }
      }
    }
  }
  GRAPHQL

  def initialize(item_count, language = nil)
    @timeout = timeout
    @language = language
    @item_count = item_count
  end

  def call
    !any_errors?
  end

  def errors
    errors ||= any_errors? && fetched_result.errors[:data].join(", ")
  end

  def repositories
    @repositories ||= !any_errors? && fetched_result.original_hash.dig('data', 'search', 'edges').map(&:values).flatten
  end

  private

  attr_reader :timeout, :language, :item_count

  def any_errors?
    @any_errors ||= fetched_result.errors.any?
  end

  def fetched_result
    @fetched_result ||= GithubGraphqlWrapper::Client.query(REPOSITORIES_QUERY, variables: {item_count: item_count, query_string: query_string})
  end

  def query_string
    @query_string ||= language ? "#{LANGUAGE_KEY}:#{language} #{SORT_QUERY_STRING}" : SORT_QUERY_STRING
  end
end
