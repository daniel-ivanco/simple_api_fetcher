class GitlabProjectsFetcher
  GITLAB_DOMAIN = "gitlab.com".freeze
  BASE_URL = "https://#{GITLAB_DOMAIN}/api/v4".freeze
  WITH_PROGRAMMING_LANGUAGE_KEY = 'with_programming_language'.to_sym

  def initialize(timeout, item_count, language = nil)
    @timeout = timeout
    @language = language
    @item_count = item_count
  end

  def call
    success?
  end

  def projects
    @projects ||= success? && parsed_response
  end

  def errors
    @errors ||= !success? && parsed_response['error']
  end

  private

  attr_reader :timeout, :language, :item_count

  def parsed_response
    @parsed_response ||= JSON.parse(response)
  end

  def default_params
    @default_params ||= { per_page: item_count, order_by: 'updated_at', sort: 'desc' }
  end

  def params
    @params ||= begin
      return default_params unless language
      default_params.merge({ WITH_PROGRAMMING_LANGUAGE_KEY => language })
    end
  end

  def response
    @response ||=
      RestClient::Request.execute(method: :get, url: "#{BASE_URL}/projects", headers: {params: params}, timeout: timeout) {|response, _request, _result| response }
  end

  def success?
    @success ||= response&.code == 200
  end
end
