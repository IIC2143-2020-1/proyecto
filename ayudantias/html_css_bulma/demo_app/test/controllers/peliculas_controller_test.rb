require 'test_helper'

class PeliculasControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get peliculas_new_url
    assert_response :success
  end

  test "should get index" do
    get peliculas_index_url
    assert_response :success
  end

  test "should get show" do
    get peliculas_show_url
    assert_response :success
  end

  test "should get edit" do
    get peliculas_edit_url
    assert_response :success
  end

end
