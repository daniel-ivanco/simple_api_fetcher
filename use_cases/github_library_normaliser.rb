class GithubLibraryNormaliser < LibraryNormaliser
  SOURCE_NAME = 'github'

  def library_url
    record.dig('url')
  end

  def name
    record.dig('name')
  end

  def username
    record.dig('owner', 'name')
  end

  def description
    record.dig('description')
  end

  def source
    SOURCE_NAME
  end
end
