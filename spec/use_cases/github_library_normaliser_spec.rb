require_relative '../spec-helper'

describe GithubLibraryNormaliser do

    let(:github_record_sample) {
      {
        'url' => 'test_http',
        'name' => 'name',
        'owner' => {'name' => 'test user name'},
        'description' => 'test description',
      }
    }

    let(:normalised_result) {
      {
        ::LibrariesFetcher::NORMALISED_FIELDS[0].to_sym => github_record_sample['url'],
        ::LibrariesFetcher::NORMALISED_FIELDS[1].to_sym => github_record_sample['owner']['name'],
        ::LibrariesFetcher::NORMALISED_FIELDS[2].to_sym => github_record_sample['name'],
        ::LibrariesFetcher::NORMALISED_FIELDS[3].to_sym => github_record_sample['description'],
        ::LibrariesFetcher::NORMALISED_FIELDS[4].to_sym => ::GithubLibraryNormaliser::SOURCE_NAME,
      }
    }

    let(:app) { described_class.new(github_record_sample, ::LibrariesFetcher::NORMALISED_FIELDS) }

    it "should return normalised hash" do
      expect(app.call).to eq(normalised_result)
    end

    it "should call LibraryNormaliser usecase" do
      expect_any_instance_of(::LibraryNormaliser).to receive(:call)
      app.call
    end

    it "should implement all methods defined in ::LibrariesFetcher::NORMALISED_FIELDS" do
      expect(::LibrariesFetcher::NORMALISED_FIELDS.all?{ |method| described_class.method_defined?(method) } ).to be_truthy
    end
end
