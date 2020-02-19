class GitlabNormaliser
  def initialize(timeout, item_count, language = nil)
    @timeout = timeout
    @language = language
    @item_count = item_count
  end

  def call
    success?
  end

  def normalised_results
    @normalised_results ||=
      success? && results.map{ |result_row| ::GitlabLibraryNormaliser.new(result_row, ::LibrariesFetcher::NORMALISED_FIELDS).call }
  end

  def errors
    @errors ||= gitlab_projects_fetcher.errors
  end

  private

  attr_reader :timeout, :item_count, :language

  def gitlab_projects_fetcher
    @gitlab_projects_fetcher ||= ::GitlabProjectsFetcher.new(timeout, item_count, language)
  end

  def success?
    @success ||= gitlab_projects_fetcher.call
  end

  def results
    @results ||= gitlab_projects_fetcher.projects
  end
end
