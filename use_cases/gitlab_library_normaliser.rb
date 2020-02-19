class GitlabLibraryNormaliser < LibraryNormaliser
  SOURCE_NAME = 'gitlab'

  def library_url
    record.dig('http_url_to_repo')
  end

  def name
    record.dig('name')
  end

  def username
    record.dig('namespace', 'name')
  end

  def description
    record.dig('description')
  end

  def source
    SOURCE_NAME
  end
end
