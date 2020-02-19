require_relative '../spec-helper'

describe GitlabNormaliser do

    let(:language) { 'language' }
    let(:app) { described_class.new(::Controller::TIMEOUT, ::LibrariesFetcher::ITEM_COUNT, language) }

    it "should call Gitlab API fetcher and library normaliser usecase and return results" do
      gitlab_sample = [{a: '1', b: '2', c: '3', d: '4'}]
      expect_any_instance_of(::GitlabProjectsFetcher).to receive(:call).and_return(true)
      expect_any_instance_of(::GitlabProjectsFetcher).to receive(:projects).and_return(gitlab_sample)
      expect_any_instance_of(::GitlabLibraryNormaliser).to receive(:call).and_return({a: '1'})

      expect(app.call).to be_truthy
      app.normalised_results
    end

    it "should call Gitlab API fetcher and library normaliser usecase and return error" do
      sample_error = {error: 'error'}
      expect_any_instance_of(::GitlabProjectsFetcher).to receive(:call).and_return(false)
      expect_any_instance_of(::GitlabProjectsFetcher).to receive(:errors).and_return(sample_error)
      expect_any_instance_of(::GitlabLibraryNormaliser).not_to receive(:call)

      expect(app.call).to be_falsey
      expect(app.errors).to eq(sample_error)
    end
end
