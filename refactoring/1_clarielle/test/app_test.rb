require "minitest/autorun"
require "minitest/pride"
require_relative "../app"

# 1. What is the goal?
# Change the add an album so that it uses the Spotify API
#
# 2. Get the code working!
describe "App" do
  it "when I launch the app it will show me options" do
    input = StringIO.new("8\ny\n2020-01-01\ny\nrock")
    output = StringIO.new
    app = App.new(input: input, output: output)
    app.start
    menu_and_output = %(Please choose an option according to the numbers on the dashboard:
    1# List all books
    2# List all music albums
    3# List of games
    4# List all genres (e.g 'Comedy', 'Thriller')
    5# List all labels (e.g. 'Gift', 'New')
    6# List all authors (e.g. 'Stephen King')
    7# Add a book
    8# Add a music album
    9# Add a game
    10# Exit
_____ADD A MUSIC ALBUM_____

Is it on Spotify? (y/n) What is the date of publication? (YYYY-MM-DD-) Is it archived? (y/n) What is the genre of the music album? A music album is created successfully)
    assert_equal output.string.strip, menu_and_output.strip
  end
end