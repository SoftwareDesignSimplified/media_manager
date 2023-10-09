require "minitest/autorun"
require "minitest/pride"
require_relative "../app"

# 1. What is the goal?
# Change the add an album so that it uses the Spotify API
#
# 2. Get the code working!
#
# 3. Wrapped tests around it
#
describe "App" do
  it "when I launch the app it will show me options" do
    input = StringIO.new("8\ny\n2020-01-01\ny\nRock")
    output = StringIO.new
    music_album_store = StringIO.new
    genres_store = StringIO.new
    app = App.new(input: input, output: output, music_album_store: music_album_store, genres_store: genres_store)
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

  it "when I add a music album then that same album will show when I list all music albums" do
    input = StringIO.new("8\ny\n2020-01-01\ny\nRock")
    output = StringIO.new
    music_album_store = StringIO.new
    genres_store = StringIO.new
    app = App.new(input: input, output: output, music_album_store: music_album_store, genres_store: genres_store)
    app.start

    input = StringIO.new("2")
    output = StringIO.new
    app = App.new(input: input, output: output, music_album_store: music_album_store, genres_store: genres_store)
    app.start
    heading = "_____LIST OF MUSIC ALBUM_____"
    _menu, list_of_albums = output.string.split(heading)
    assert_equal 1, list_of_albums.strip.split("\n").count
  end

  it "when I add a music album in the genre of Rock and then list out all genres Rock should be in that list" do
    input = StringIO.new("8\ny\n2020-01-01\ny\nRock")
    output = StringIO.new
    music_album_store = StringIO.new
    genres_store = StringIO.new
    app = App.new(input: input, output: output, music_album_store: music_album_store, genres_store: genres_store)
    app.start

    input = StringIO.new("4")
    output = StringIO.new
    app = App.new(input: input, output: output, music_album_store: music_album_store, genres_store: genres_store)
    app.start
    heading = "_____LIST OF GENRE_____"
    _menu, list_of_genres = output.string.split(heading)
    assert_equal 1, list_of_genres.strip.split("\n").count
  end
end