require_relative 'test_helper'
require_relative '../app'

describe 'App' do
  it 'when I start up the app it shows me a menu' do
    actual_menu = app_home_screen

    expected_menu = [
      'Please choose an option according to the numbers on the dashboard:',
      '    1# List all books',
      '    2# List all music albums',
      '    3# List of games',
      "    4# List all genres (e.g 'Comedy', 'Thriller')",
      "    5# List all labels (e.g. 'Gift', 'New')",
      "    6# List all authors (e.g. 'Stephen King')",
      '    7# Add a book',
      '    8# Add a music album',
      '    9# Add a game',
      '    10# Exit'
    ].join("\n")
    assert_equal expected_menu, actual_menu
  end

  it 'when I add a music album it asks me questions about the album' do
    music_album_store = StringIO.new
    genres_store = StringIO.new

    actual_questions = extract_questions_from(add_music_album(music_album_store:, genres_store:))

    expected_questions = [
      'What is the album name?',
      'A music album is created successfully'
    ].join(' ')
    assert_equal expected_questions, actual_questions
  end

  it 'when I add a music album then that same album will show when I list all music albums' do
    music_album_store = StringIO.new
    genres_store = StringIO.new
    add_music_album(name: 'Appetite for destruction', music_album_store:, genres_store:)

    albums = list_music_albums(music_album_store:, genres_store:)

    assert_equal 1, albums.count
    assert_match(/0- name: Appetite For Destruction - id: \d+ - is published on 1987-07-21/, albums.first)
  end

  it 'when I add a music album in the genre of Rock and then list out all genres Rock should be in that list' do
    skip
    music_album_store = StringIO.new
    genres_store = StringIO.new
    add_music_album(name: 'Blues', music_album_store:, genres_store:)

    genres = list_genres(music_album_store:, genres_store:)

    assert_equal ['0 - Blues'], genres
  end

  private

  def add_music_album(music_album_store:, genres_store:, name: 'Pop')
    input = StringIO.new("8\n#{name}")
    output = StringIO.new
    app = App.new(input:, output:, music_album_store:, genres_store:)
    app.start
    output.string
  end

  def app_home_screen
    music_album_store = StringIO.new
    genres_store = StringIO.new
    input = StringIO.new('2')
    output = StringIO.new
    app = App.new(input:, output:, music_album_store:, genres_store:)
    app.start
    output.string.split('_____').first.strip
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

  def list_genres(music_album_store:, genres_store:)
    input = StringIO.new('4')
    output = StringIO.new
    app = App.new(input:, output:, music_album_store:, genres_store:)
    app.start
    heading = '_____LIST OF GENRE_____'
    _menu, list_of_genres = output.string.split(heading)
    list_of_genres.strip.split("\n")
  end

  def extract_questions_from(output)
    heading = '_____ADD A MUSIC ALBUM_____'
    _menu, questions = output.split(heading)
    questions.strip
  end
end
