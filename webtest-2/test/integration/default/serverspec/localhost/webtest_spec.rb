require 'spec_helper'

describe "Web server" do
  let(:host) { URI.parse('http://localhost') }

  it "is showing a page with the text 'Hello world'" do
    connection = Faraday.new host
    page = connection.get('/').body
    expect(page).to match /Hello world/
  end

end
