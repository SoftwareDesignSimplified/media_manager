require_relative 'test_helper'
require_relative '../app'

describe 'App' do
  it 'when I launch the app it will show me options' do
    input = StringIO.new("8\nPop\ny\n2020-01-01\ny\nRock")
    output = StringIO.new
    music_album_store = StringIO.new
    genres_store = StringIO.new
    app = App.new(input:, output:, music_album_store:, genres_store:)
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

What is the album name? Is it on Spotify? (y/n) What is the date of publication? (YYYY-MM-DD-) Is it archived? (y/n) What is the genre of the music album? A music album is created successfully)
    assert_equal output.string.strip, menu_and_output.strip
  end

  it 'when I add a music album then that same album will show when I list all music albums' do
    music_album_store = StringIO.new
    genres_store = StringIO.new
    add_music_album(name: 'Pop', publish_date: '2020-01-01', music_album_store:, genres_store:)

    albums = list_music_albums(music_album_store:, genres_store:)

    assert_equal 1, albums.count
    assert_match(/0- name: Pop - id: \d+ - is published on 2020-01-01/, albums.first)
  end

  it 'when I add a music album in the genre of Rock and then list out all genres Rock should be in that list' do
    input = StringIO.new("8\nPop\ny\n2020-01-01\ny\nRock")
    output = StringIO.new
    music_album_store = StringIO.new
    genres_store = StringIO.new
    app = App.new(input:, output:, music_album_store:, genres_store:)
    app.start

    input = StringIO.new('4')
    output = StringIO.new
    app = App.new(input:, output:, music_album_store:, genres_store:)
    app.start
    heading = '_____LIST OF GENRE_____'
    _menu, list_of_genres = output.string.split(heading)
    assert_equal 1, list_of_genres.strip.split("\n").count
    assert_equal "0 - Rock", list_of_genres.strip.split("\n").first
  end
  
  private

  def add_music_album(name:, publish_date:, music_album_store:, genres_store:)
    input = StringIO.new("8\nPop\ny\n2020-01-01\ny\nRock")
    output = StringIO.new
    app = App.new(input:, output:, music_album_store:, genres_store:)
    app.start
    app
  end

  def list_music_albums(music_album_store:, genres_store:)
    input = StringIO.new('2')
    output = StringIO.new
    app = App.new(input:, output:, music_album_store:, genres_store:)
    app.start
    heading = '_____LIST OF MUSIC ALBUM_____'
    _menu, list_of_albums = output.string.split(heading)
    list_of_albums.strip.split("\n")
  end

end
