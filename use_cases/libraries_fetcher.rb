class LibrariesFetcher
  ITEM_COUNT = 50
  NORMALISED_FIELDS = %w(library_url username name description source)

  def initialize(language = nil)
    @language = language
  end

  def call
    success?
  end

  def libraries
    @libraries = success? && finished_normalisers.map{ |normaliser| normaliser.normalised_results }.flatten
  end

  def errors
    @errors = !success? && finished_normalisers.map{ |normaliser| normaliser.errors }.flatten
  end

  private

  attr_reader :language

  def success?
    @success ||= finished_normalisers.none?{ |normaliser| normaliser.errors }
  end

  def finished_normalisers
    @finished_normalisers ||= begin
      normalisers = []
      normalisers << gitlab_normaliser
      normalisers << github_normaliser
      normalisers
    end
  end

  def gitlab_normaliser
    @gitlab_normaliser ||=
      begin
        gitlab_normaliser = ::GitlabNormaliser.new(::Controller::TIMEOUT, ITEM_COUNT, language)
        gitlab_normaliser.call
        gitlab_normaliser
      end
  end

  def github_normaliser
    @github_normaliser ||=
      begin
        github_normaliser = ::GithubNormaliser.new(ITEM_COUNT, language)
        github_normaliser.call
        github_normaliser
      end
  end
end
