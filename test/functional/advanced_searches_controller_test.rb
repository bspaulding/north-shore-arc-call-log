require 'test_helper'

class AdvancedSearchesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:advanced_searches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create advanced_search" do
    assert_difference('AdvancedSearch.count') do
      post :create, :advanced_search => { }
    end

    assert_redirected_to advanced_search_path(assigns(:advanced_search))
  end

  test "should show advanced_search" do
    get :show, :id => advanced_searches(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => advanced_searches(:one).id
    assert_response :success
  end

  test "should update advanced_search" do
    put :update, :id => advanced_searches(:one).id, :advanced_search => { }
    assert_redirected_to advanced_search_path(assigns(:advanced_search))
  end

  test "should destroy advanced_search" do
    assert_difference('AdvancedSearch.count', -1) do
      delete :destroy, :id => advanced_searches(:one).id
    end

    assert_redirected_to advanced_searches_path
  end
end
