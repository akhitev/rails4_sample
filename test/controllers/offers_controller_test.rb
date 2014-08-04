require 'test_helper'

class OffersControllerTest < ActionController::TestCase

  test "GET search_form" do
    get "search_form"
    assert_response :success
    assert_select "form input#pub0"
    assert_select "form input#uid"
    assert_select "form input#page"

  end


  test "search with empty result" do
    post "search", {}
    assert_nil assigns(:offers)
  end

  test "search with nont-empty result" do
    RestClient.expects(:get).returns(given_valid_response)

    #mocking valid header checking
    SponsorPayAPI.any_instance.expects(:valid_response?).returns(true)
    post "search", {}
    assert_not_nil assigns(:offers)
  end
end
