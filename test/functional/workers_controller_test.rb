require 'test_helper'

class WorkersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:workers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_worker
    assert_difference('Worker.count') do
      post :create, :worker => { }
    end

    assert_redirected_to worker_path(assigns(:worker))
  end

  def test_should_show_worker
    get :show, :id => workers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => workers(:one).id
    assert_response :success
  end

  def test_should_update_worker
    put :update, :id => workers(:one).id, :worker => { }
    assert_redirected_to worker_path(assigns(:worker))
  end

  def test_should_destroy_worker
    assert_difference('Worker.count', -1) do
      delete :destroy, :id => workers(:one).id
    end

    assert_redirected_to workers_path
  end
end
