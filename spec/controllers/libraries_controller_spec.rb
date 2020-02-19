require_relative '../spec-helper'

describe LibrariesController do

  let(:app) { described_class.new }

  def json_body
    @json_body = JSON.parse(last_response.body)
  end

  context "GET libraries" do
    it "should return non zero libraries" do
      get '/'
      expect(last_response).to be_ok
      expect(json_body['libraries'].count > 0).to be_truthy
    end

    it "should return non zero libraries with param language" do
      get '/?language=ruby'
      expect(last_response).to be_ok
      expect(json_body['libraries'].count > 0).to be_truthy
    end

    it "should call Gitlab API fetcher with param language" do
      language = 'ruby'
      expect(::GitlabProjectsFetcher).to receive(:new).with(::Controller::TIMEOUT, ::LibrariesFetcher::ITEM_COUNT, language)
      get "/?language=#{language}"
    end

    it "should call Github API fetcher with param language" do
      language = 'ruby'
      expect(::GithubRepositoriesFetcher).to receive(:new).with(::LibrariesFetcher::ITEM_COUNT, language)
      get "/?language=#{language}"
    end

    it "should call relevant usecase without params when invalid param is used" do
      language = 'ruby'
      expect(::LibrariesFetcher).to receive(:new).with(nil)
      get "/?invalid_param=#{language}"
    end

    it "should return error message passed from relevant usecase" do
      error_msg = 'error msg'
      expect_any_instance_of(::LibrariesFetcher).to receive(:call).and_return(false)
      expect_any_instance_of(::LibrariesFetcher).to receive(:errors).and_return(error_msg)
      get '/'
      expect(last_response.status).to eq(500)
      expect(json_body['data']).to eq(error_msg)
    end
  end
end
