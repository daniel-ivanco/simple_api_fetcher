class LibrariesController < Controller
  get '/' do
    param :language, String, required: false

    libraries_fetcher = ::LibrariesFetcher.new(params[:language])
    if libraries_fetcher.call
      { libraries: libraries_fetcher.libraries }.to_json
    else
      halt 500, { message: "can't fetch libraries", data: libraries_fetcher.errors }.to_json
    end
  end
end
