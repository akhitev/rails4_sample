class OffersController < ApplicationController

  def search_form
      @search_form = SearchForm.new
  end

  def search
    response = SponsorPayAPI.new().offers offer_params
    @offers = response['offers'] if !response.nil?
  end

private

  def offer_params
    params.permit(:uid,:page,:pub0)
  end
end