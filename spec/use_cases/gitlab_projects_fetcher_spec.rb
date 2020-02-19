require_relative '../spec-helper'

describe GitlabProjectsFetcher do

  let(:language) { ::StubGitlab::LANGUAGE_VALUE }
  let(:app) { described_class.new(::Controller::TIMEOUT, ::LibrariesFetcher::ITEM_COUNT) }
  let(:app_with_language) { described_class.new(::Controller::TIMEOUT, ::LibrariesFetcher::ITEM_COUNT, language) }


  it "should call Github API and fetch results" do
    expect(app.call).to be_truthy
    expect(app.projects.count).to eq(::LibrariesFetcher::ITEM_COUNT)
  end

  it "API result should have expected structure" do
    app.call
    expect(app.projects.first.key?('description')).to be_truthy
    expect(app.projects.first['namespace'].key?('name')).to be_truthy
    expect(app.projects.first.key?('name')).to be_truthy
    expect(app.projects.first.key?('http_url_to_repo')).to be_truthy
  end

  it "should not use language param if not defined" do
    app.call
    expect(app.send(:params)[described_class::WITH_PROGRAMMING_LANGUAGE_KEY]).to be_falsey
  end

  it "should use language param if defined" do
    app_with_language.call
    expect(app_with_language.send(:params)[described_class::WITH_PROGRAMMING_LANGUAGE_KEY]).to be_truthy
  end
end
