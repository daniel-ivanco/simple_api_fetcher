require_relative '../spec-helper'

describe LibrariesFetcher do

    let(:app) { described_class.new }

    it "should call relevant usecases and return results" do
      gitlab_sample = [1, 2, 3, 4]
      github_sample = [6, 7, 8, 9]

      allow_any_instance_of(::GitlabNormaliser).to receive(:call).and_return(true)
      allow_any_instance_of(::GithubNormaliser).to receive(:call).and_return(true)

      allow_any_instance_of(::GitlabNormaliser).to receive(:normalised_results).and_return(gitlab_sample)
      allow_any_instance_of(::GithubNormaliser).to receive(:normalised_results).and_return(github_sample)

      expect(app.call).to be_truthy
      expect(app.libraries).to eq(gitlab_sample + github_sample)
    end

    it "should call Gitlab usecase usecase returning error which should return error" do
      allow_any_instance_of(::GitlabNormaliser).to receive(:errors).and_return('error')

      expect(app.call).to be_falsey
      expect(app.libraries).to eq(false)
    end

    it "should call Github usecase returning error which should return error" do
      allow_any_instance_of(::GithubNormaliser).to receive(:errors).and_return('error')

      expect(app.call).to be_falsey
      expect(app.libraries).to eq(false)
    end
end
