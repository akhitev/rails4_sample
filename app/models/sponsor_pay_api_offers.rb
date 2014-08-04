class SponsorPayAPIOffers < SponsorPayAPI

  PREDEFINED_PARAMS = ['appid','format','device_id','locale','ip','offer_types']


  def initialize
    @endpoint = SPONSORPAY_CONFIGS['offer_endpoint']
  end

  def offers params
    request = build_request(params)
    offers_response(request)
  end

  def offers_response request
    url = @endpoint + '?'+ request
    Rails.logger.debug{'call offers api' + url}
    response = http_response url
    if !response.code.eql? 200
      Rails.logger.warn{'Offers api returned error ' + response.code.to_s + ' ' + response.body}
      return
    end
    #check response signature
    if !valid_response? response
      return
    end
    JSON.parse(response.body)
  end

  def predefined_params
    PREDEFINED_PARAMS
  end

end