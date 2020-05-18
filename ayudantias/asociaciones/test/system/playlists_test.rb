require "application_system_test_case"

class PlaylistsTest < ApplicationSystemTestCase
  setup do
    @playlist = playlists(:one)
  end

  test "visiting the index" do
    visit playlists_url
    assert_selector "h1", text: "Playlists"
  end

  test "creating a Playlist" do
    visit playlists_url
    click_on "New Playlist"

    fill_in "Title", with: @playlist.title
    click_on "Create Playlist"

    assert_text "Playlist was successfully created"
    click_on "Back"
  end

  test "updating a Playlist" do
    visit playlists_url
    click_on "Edit", match: :first

    fill_in "Title", with: @playlist.title
    click_on "Update Playlist"

    assert_text "Playlist was successfully updated"
    click_on "Back"
  end

  test "destroying a Playlist" do
    visit playlists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Playlist was successfully destroyed"
  end
end
