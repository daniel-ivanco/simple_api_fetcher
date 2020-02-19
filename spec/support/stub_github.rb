class StubGithub
  LANGUAGE_VALUE = 'Ruby'

  def self.execute(document: _, operation_name: _, variables: _, context: _)
    if with_language?(variables)
      success_response('github_repositories_with_language')
    else
      success_response('github_repositories')
    end
  end

  private

  def self.success_response(file_name)
    JSON.parse(File.open(File.dirname(__FILE__) + "/../fixtures/#{file_name}.json", 'rb').read)
  end

  def self.with_language?(variables)
    variables['query_string'].include?(::GithubRepositoriesFetcher::LANGUAGE_KEY)
  end
end
