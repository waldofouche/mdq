# frozen_string_literal: true

require 'test_helper'

class MdqControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get mdq_index_url
    assert_response :success
  end
end
