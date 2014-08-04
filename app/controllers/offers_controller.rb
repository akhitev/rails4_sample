class OffersController < ApplicationController

  def search_form
  end

  def search
    response = SponsorPayAPI.new().offers offer_params
    @offers = response['offers'] if !response.nil?
  end

  #backdoor for UI testing
  def test
    response = JSON.parse(File.read("test/fixtures/sample_offers_response.json"))
    @offers = response['offers']
    render "search"
  end

private

  def offer_params
    params.permit(:uid,:page,:pub0)
  end
end