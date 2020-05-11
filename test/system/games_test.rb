require "application_system_test_case"
require "pry-byebug"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector "li", count: 10
  end

  test "says it's not english word" do
    visit new_url
    fill_in 'word', with: "ZGTSYDHEUB"
    # fill_in 'letters', with: "Z G T S Y D H E U B"
    click_on "play"
    assert_selector "p", text: "does not seem to be a valid English word"
  end

  test "says it's not in the grid" do
    visit new_url
    fill_in 'word', with: "starlight"
    click_on "play"
    assert_selector "p", text: "can't be built out"
  end
end
