class SponsorPayAPI

  require 'digest'

  SIGNATURE_HEADER = 'X-Sponsorpay-Response-Signature'


  def build_request params
    params = add_predefined_params params
    params['timestamp'] = Time.now.to_i
    url = sort_concat(params)
    #Sort and concat all request parameters and append api key
    # append hashkey
    url.concat("&hashkey=#{get_hash(url + '&' + api_key)}")
  end

  def http_response url
    RestClient.get(url){|response, request, result| response }
  end


  def valid_response? response
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
    predefined_params.each do |k|
      params[k] = SPONSORPAY_CONFIGS[k]
    end
    params
  end

  def predefined_params
    raise NotImplementedError 'Implement predefined_params'
  end


  def get_hash str
    Digest::SHA1.hexdigest str
  end

  private

  def api_key
    SPONSORPAY_CONFIGS['API Key']
  end

end