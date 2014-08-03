class SponsorPayAPI

  require 'digest'

  PREDEFINED_PARAMS = ['appid','format','device_id','locale','ip','offer_types']

  SIGNATURE_HEADER = 'X-Sponsorpay-Response-Signature'

  def initialize
    @endpoint = SPONSORPAY_CONFIGS['offer_endpoint']
  end

  def offers params
    request = build_request(params)
    offers_response(request)
  end


  def build_request params
    #Step 1: Gather all request parameters
    params = add_predefined_params params
    params['timestamp'] = Time.now.to_i

    #Sort and concat all request parameters and append api key
    result = sort_concat(params).concat('&').concat(api_key)
    # append hashkey
    result.concat("&hashkey=#{get_hash(result)}")
  end

  def offers_response request
    Rails.logger.debug{'call offers api' + @endpoint + request}
    #response = Net::HTTP.get_response(URI(@endpoint + request))
    response = RestClient.get(@endpoint ,request)
    if response.code != 200
      Rails.logger.warn{'offers api returned error' + response.inspect}
      return
    end
    #check response signature
    if !valid_response response
      return
    end
    JSON.parse(response.body)
  end

  def valid_response response
    expected_hash = get_hash(response.body.concat(api_key))
    result = response[SIGNATURE_HEADER].eql? expected_hash

    if !result
      Rails.logger.error{'Returned response signature header differs from expected. Expected : ' + expected_hash + 'Actual ' + response[SIGNATURE_HEADER]+
      'response : ' + response.inspect}
    end
    result
  end


  def sort_concat(params)
    arr = []
    params.keys.sort_by { |k| k.to_s }.each do |k|
      arr << ("#{k}=#{params[k]}")
    end
    request = arr.join('&')
  end

  def add_predefined_params params
    PREDEFINED_PARAMS.each do |k|
      params[k] = SPONSORPAY_CONFIGS[k]
    end
    params
  end

  def get_hash str
    Digest::SHA1.hexdigest str
  end

  private

  def api_key
    SPONSORPAY_CONFIGS['API Key']
  end

end