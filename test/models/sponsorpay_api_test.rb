require 'test_helper'

describe "SponsorPayApiTest" do

  let(:sponsorpay_api) { SponsorPayAPIOffers.new }
  describe "url prepare" do
    it "should calculate hash" do
      sponsorpay_api.get_hash('appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b831186&ip=212.45.111.17&locale=de&page=2&ps_time=1312211903&pub0=campaign2&timestamp=1312553361&uid=player1&e95a21621a1865bcbae3bee89c4d4f84').
          must_equal '7a2b1604c03d46eec1ecd4a686787b75dd693c4d'
    end

    it "should concatenate and sort all request parameters" do
      params = {'c' => 0, 'z' => 1, 'a' => 3}
      sponsorpay_api.sort_concat(params).must_equal 'a=3&c=0&z=1'
    end

    it 'should build request' do
      params = {}
      params[:pub0] = 'campaign2'
      params[:page] = '2'
      params[:uid] = 'player1'
      Time.stubs(:now).returns(Time.mktime(2014, 1, 1))

      sponsorpay_api.build_request(params).must_equal('appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b831186&format=json&ip=109.235.143.113&locale=de&offer_types=112&page=2&pub0=campaign2&timestamp=1388520000'+
                                                          '&uid=player1&hashkey=97cc99b02839be57be47e9031509da1514bb8956')
    end
  end

  it "should declare valid response signed with correct signature" do
    response = given_valid_response
    headers = {SponsorPayAPI::SIGNATURE_HEADER.downcase.to_sym => '73c764f5b52030a9b3577017f59b5dcf84d42d84'}
    response.stubs(:headers).returns(headers)
    sponsorpay_api.valid_response?(response).must_equal true
  end

  it "should not verify response signed with incorrect signature" do
    response = given_valid_response
    headers = {SponsorPayAPI::SIGNATURE_HEADER.downcase.to_sym => '12c764f5b52030a9b3577017f59b5dcf84d42d84'}
    response.stubs(:headers).returns(headers)
    sponsorpay_api.valid_response?(response).must_equal false
  end
end