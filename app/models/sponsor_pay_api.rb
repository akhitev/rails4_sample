class SponsorPayAPI

  require 'digest'

  SIGNATURE_HEADER = 'X_Sponsorpay_Response_Signature'


  def build_request params
    params = add_predefined_params params
    params['timestamp'] = Time.now.to_i
    url = sort_concat(params)
    #Sort and concat all request parameters and append api key
    # append hashkey
    url.concat("&hashkey=#{get_hash(url + '&' + api_key)}")
  end

  def http_response url
    response = RestClient.get(url){|response, request, result| response }
    Rails.logger.debug{'response ' + response.code.to_s + ' ' + response.body}
    response
  end


  def valid_response? response
    expected_hash = get_hash(response.body + api_key)
    result = response.headers[SIGNATURE_HEADER.downcase.to_sym].eql? expected_hash

    if !result
      #TODO add some alert here
      Rails.logger.error{'Signature header differs from expected.' + response.inspect}
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