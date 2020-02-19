require 'sinatra/base'

class StubGitlab
  LANGUAGE_VALUE = 'Ruby'

  def self.call(env)
    if project_route?(env)
      success_response('gitlab_projects')
    else
      error_response
    end
  end

  private

  def self.project_route?(env)
    env['PATH_INFO'].split('/').last == 'projects'
  end

  def self.success_response(file_name)
    [200, {}, [File.open(File.dirname(__FILE__) + "/../fixtures/#{file_name}.json", 'rb').read]]
  end

  def error_response
    [500, {}, []]
  end
end