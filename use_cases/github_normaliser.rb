class GithubNormaliser
  def initialize(item_count, language = nil)
    @language = language
    @item_count = item_count
  end

  def call
    success?
  end

  def normalised_results
    @normalised_results ||=
      success? && repositories.map{ |repository| ::GithubLibraryNormaliser.new(repository, ::LibrariesFetcher::NORMALISED_FIELDS).call }
  end

  def errors
    @errors ||= github_repositories_fetcher.errors
  end

  private

  attr_reader :item_count, :language

  def success?
    @success ||= github_repositories_fetcher.call
  end

  def github_repositories_fetcher
    @github_repositories_fetcher ||= ::GithubRepositoriesFetcher.new(item_count, language)
  end

  def repositories
    @repositories ||= github_repositories_fetcher.repositories
  end
end
