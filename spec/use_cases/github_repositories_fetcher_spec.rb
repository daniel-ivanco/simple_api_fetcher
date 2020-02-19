require_relative '../spec-helper'

describe GithubRepositoriesFetcher do

  let(:language) { ::StubGithub::LANGUAGE_VALUE }
  let(:app) { described_class.new(::LibrariesFetcher::ITEM_COUNT) }
  let(:app_with_language) { described_class.new(::LibrariesFetcher::ITEM_COUNT, language) }


  it "should call Gitlab GraphQL API and fetch results" do
    expect(app.call).to be_truthy
    expect(app.repositories.count).to eq(::LibrariesFetcher::ITEM_COUNT)
  end

  it "API result should have expected structure" do
    app.call
    expect(app.repositories.first.key?('description')).to be_truthy
    expect(app.repositories.first['owner']&.key?('name')).to be_truthy
    expect(app.repositories.first['languages']['nodes']).to be_truthy
    expect(app.repositories.first.key?('name')).to be_truthy
    expect(app.repositories.first.key?('url')).to be_truthy
  end

  it "should return random languages if language param is not defined" do
    app.call
    expect(
      app.repositories.any? do |repository|
        language = repository['languages']['nodes'].dig(0)
        language && (language.dig('name') != ::StubGithub::LANGUAGE_VALUE)
      end
    ).to be true
  end

  it "should return records with specific language if language param is defined" do
    app_with_language.call
    expect(
      app_with_language.repositories.all? do |repository|
        language = repository['languages']['nodes'].dig(0)
        language && (language.dig('name') == ::StubGithub::LANGUAGE_VALUE)
      end
    ).to be true
  end
end
