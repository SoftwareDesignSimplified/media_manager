require_relative './item'
require_relative './music'
require_relative './genre'
require_relative './io'
require_relative './music_album_helper'
require_relative './book'
require_relative './label'
# require_relative './book_info'
require_relative './book_data'
require_relative './game_actions'
require_relative './app'
require_relative './genre'
require_relative './source'
require_relative './author'
require_relative './label'

require 'json'
require 'date'

class App
  include MusicAlbumHelper
  include IOHelper
  # class initialization:
  # @game_actions: Object created from CameActions class
  attr_accessor :music_albums, :genres
  attr_reader :books

  def initialize(
    input:,
    output:,
    music_album_store:,
    genres_store:
  )
    @music_album_store = music_album_store
    @genres_store = genres_store

    @music_albums = read_file_object(@music_album_store, 'MusicAlbum')
    @genres = read_file_object(@genres_store, 'Genre')

    @game_actions = GameActions.new
    @books = []
    @labels = []
    @input = input
    @output = output
  end

  # Title of each option when executed
  def print_prompt(title)
    @output.puts "_____#{title.upcase}_____"
    @output.puts ''
  end

  # the user options
  def options_list
    @output.puts "\nPlease choose an option according to the numbers on the dashboard:
    1# List all books
    2# List all music albums
    3# List of games
    4# List all genres (e.g 'Comedy', 'Thriller')
    5# List all labels (e.g. 'Gift', 'New')
    6# List all authors (e.g. 'Stephen King')
    7# Add a book
    8# Add a music album
    9# Add a game
    10# Exit"

    choice = @input.gets.chomp
    selection(choice.to_i)
  end

  # We save our selection into an array
  def selection(choice)
    methods = [
      method(:booklist), method(:list_music_album), method(:gamelist), method(:list_genres), method(:labellist),
      method(:list_authors), method(:create_book), method(:add_music_album), method(:create_game), method(:quit_app)
    ]

    # according to the number entered we call the defined method
    (1..10).include?(choice) && methods[choice - 1].call
  end

  # Our dashboard methods
  # Defined with default options

  # list all the labels
  def labellist
    @labels.clear
    book_data = BookData.new
    book_data.load_label(@labels)
    @output.puts "\nLabel list(#{@labels.length}):"
    @output.puts '---------------'
    return @output.puts 'No labels added yet!' if @labels.empty?

    @labels.each.with_index(1) do |label, index|
      @output.puts "#{index}. Title: #{label.title}, Color: #{label.color}"
    end
  end

  # add book
  def create_book
    book_data = BookData.new
    @output.puts 'Create book'
    @output.puts '-----------------'
    @output.puts 'Add the publisher name'
    publisher = @input.gets.chomp
    @output.puts 'Add the state of the cover "bad or good"'
    cover_state = @input.gets.chomp.downcase
    @output.puts 'The date of publishing dd/mm/yy'
    publish_date = @input.gets.chomp
    book = Book.new(publish_date, publisher, cover_state)
    label = add_label
    book.add_label(label)
    @books << book
    book_data.store_book(book)
    @books.clear
    @labels << label
    book_data.store_label(label)
    @labels.clear
    @output.puts 'Book added successfully'
  end

  # list all books
  def booklist
    @books.clear
    book_data = BookData.new
    book_data.load_book(@books, @labels)
    @output.puts 'book list in library'
    @output.puts "\nBook list(#{@books.length}):"
    @output.puts '--------------'
    return @output.puts 'No books added yet!' if @books.empty?

    @books.each.with_index(1) do |book, index|
      publisher = "Publisher: #{book.publisher}, " unless book.publisher.nil?
      publish_date = "Publish date: #{book.publish_date}, " unless book.publish_date.nil?
      cover_state = "Cover state: #{book.cover_state}" unless book.cover_state.nil?
      @output.puts "#{index}. #{publisher}#{publish_date}#{cover_state}"
    end
  end

  def add_label
    # add label
    @output.puts 'Assign a label to the book'
    @output.puts '-------------------------'
    @output.puts 'Give a title to the book'
    title = @input.gets.chomp
    @output.puts 'Assign a color to the book'
    color = @input.gets.chomp
    Label.new(title, color)
  end

  # List all the existing music albums
  def list_music_album
    @music_albums = read_file_object(@music_album_store, 'MusicAlbum')
    print_prompt('list of music album')
    if @music_albums.empty?
      @output.puts 'No music album in the library'
      nil
    else
      @music_albums.each_with_index do |music_album, index|
        @output.puts "#{index}- name: #{music_album.name} - id: #{music_album.id} - is published on #{music_album.publish_date}"
      end
    end
  end

  # List all the existing genres
  def list_genres
    @genres = read_file_object(@genres_store, 'Genre')
    print_prompt('list of genre')
    @genres.each_with_index { |genre, index| @output.puts "#{index} - #{genre.name}" }
  end

  def add_music_album
    print_prompt('add a music album')
    name = ask_for_album_name
    on_spotify = ask_on_spotify
    publish_date = ask_publish_date
    archived = ask_archived
    genre = ask_genre
    new_music_album = MusicAlbum.new(on_spotify, publish_date, archived: archived, name: name)
    add_genre_to_music_album(@genres, new_music_album, genre) unless genre.empty?

    @music_albums << new_music_album
    write_file(@music_albums, @music_album_store)

    @output.puts 'A music album is created successfully'
  end

  # call create_game method from GameActions
  def create_game
    @game_actions.add_game
  end

  # list all games added
  def gamelist
    @game_actions.list_games
  end

  # list all authors added
  def list_authors
    @game_actions.list_authors
  end

  # Saves file befor leaving the app
  def quit_app
    @game_actions.save_games
    @game_actions.save_authors
    @output.puts 'Thanks for using our app'
    exit
  end

  # Then we start the app
  def start
    options_list
  end
end