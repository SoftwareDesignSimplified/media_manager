module MusicAlbumHelper
  # Check whether the genre already exists in the file
  # @param {Genre[]} genres
  # @param {String} name
  # @return {Boolean}
  def exist_genre?(genres, name)
    genres.any? { |genre| genre.name == name }
  end

  # Update number of items in a particular Genre
  # @param {Genre[]} genres
  # @param {String} name
  # @param {MusicAlbum} new_music_album
  # @return nil
  def update_items(genres, name, new_music_album)
    genres.each do |genre_item|
      if genre_item.name == name
        genre_item.add_item(new_music_album)
        break
      end
    end
  end

  # Handle user input
  def ask_on_spotify
    @output.print 'Is it on Spotify? (y/n) '
    on_spotify_input = @input.gets.chomp.downcase
    %w[y yes].include?(on_spotify_input)
  end

  def ask_publish_date
    @output.print 'What is the date of publication? (YYYY-MM-DD-) '
    @input.gets.chomp
  end

  def ask_archived
    @output.print 'Is it archived? (y/n) '
    archived_input = @input.gets.chomp.downcase
    %w[y yes].include?(archived_input)
  end

  def ask_genre
    @output.print 'What is the genre of the music album? '
    @input.gets.chomp.capitalize
  end

  # Handle the genre of the music album
  # if genre exists, update the number of items of that genre
  # if genre does not exist, create a new genre
  # @param {Genre[]} genres
  # @param {MusicAlbum} music_album
  # @param {String} genre_name
  # @return nil
  def add_genre_to_music_album(genres, music_album, genre_name)
    if exist_genre?(genres, genre_name)
      update_items(genres, genre_name, music_album)
    else
      new_genre = Genre.new(genre_name)
      music_album.add_genre(new_genre)
      genres << new_genre
    end
    write_file(genres, @genres_store)
  end
end