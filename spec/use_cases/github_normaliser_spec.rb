require_relative '../spec-helper'

describe GithubNormaliser do

    let(:language) { 'language' }
    let(:app) { described_class.new(::LibrariesFetcher::ITEM_COUNT, language) }

    it "should call Github API fetcher and library normaliser usecase and return results" do
      github_sample = [{a: '1', b: '2', c: '3', d: '4'}]
      expect_any_instance_of(::GithubRepositoriesFetcher).to receive(:call).and_return(true)
      expect_any_instance_of(::GithubRepositoriesFetcher).to receive(:repositories).and_return(github_sample)
      expect_any_instance_of(::GithubLibraryNormaliser).to receive(:call).and_return({a: '1'})

      expect(app.call).to be_truthy
      app.normalised_results
    end

    it "should call Github API fetcher and library normaliser usecase and return error" do
      sample_error = {error: 'error'}
      expect_any_instance_of(::GithubRepositoriesFetcher).to receive(:call).and_return(false)
      expect_any_instance_of(::GithubRepositoriesFetcher).to receive(:errors).and_return(sample_error)
      expect_any_instance_of(::GithubLibraryNormaliser).not_to receive(:call)

      expect(app.call).to be_falsey
      expect(app.errors).to eq(sample_error)
    end
end
