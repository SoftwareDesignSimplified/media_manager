class GameActions
  # Make class properties accessible
  attr_accessor :games, :authors

  # Class initialization
  # games: assigned to the method load_games(from the json file)
  # authors: assigned to the method load_authors(from the json file)
  def initialize
    @games = load_games
    @authors = load_authors
  end

  # Save_games and Save_authors methods:
  # creates a new array where data will be pushed as object/hash
  # then write the data to the generated json file
  def save_games
    data = []
    @games.each do |game|
      data.push({ id: game.id,
                  multiplayer: game.multiplayer,
                  last_played_at: game.last_played_at,
                  publish_date: game.publish_date })
    end
    File.write('./data/games.json', JSON.generate(data)).to_s
  end

  def save_authors
    data = []
    @authors.each do |author|
      data.push({ id: author.id,
                  first_name: author.first_name,
                  last_name: author.last_name })
    end
    File.write('./data/authors.json', JSON.generate(data)).to_s
  end

  # Load_games and Load_authors methods:
  # should load the games and authors from the json file
  # and save them into array
  # then return that array containing the games/authors
  def load_games
    data = []
    file = './data/games.json'

    # if the file exists, then read the file and parse the json data
    # otherwise create it
    if File.exist?(file)
      JSON.parse(File.read(file)).each do |game|
        data.push(Game.new(game['multiplayer'], game['last_played_at'], game['publish_date']))
      end
    else
      File.write(file, JSON.generate(data))
    end
    data
  end

  def load_authors
    data = []
    file = './data/authors.json'

    # if the file exists, then read the file and parse the json data
    # otherwise create it
    if File.exist?(file)
      JSON.parse(File.read(file)).each do |author|
        data.push(Author.new(author['first_name'], author['last_name']))
      end
    else
      File.write(file, JSON.generate(data))
    end
    data
  end

  # add_game method:
  # Takes as inputs: the publish_date, if it's multiplayer, and last_played options
  # creates a new game and push it to @games
  # creates a new author and add it to the item

  def add_game
    puts 'What\'s the publish date of the game? (yyyy-mm-dd): '
    publish_date = gets.chomp

    puts 'Is the game multiplayer or not? [Y/N]: '
    multiplayer = gets.chomp.downcase

    puts 'Please provide the last date you played it? (yyyy-mm-dd):'
    last_played_at = gets.chomp

    game = Game.new(multiplayer, last_played_at, publish_date)
    @games.push(game)

    puts 'Author first name: '
    first_name = gets.chomp
    puts 'Author last name: '
    last_name = gets.chomp
    author = Author.new(first_name, last_name)

    author.add_item(game)
    @authors.push(game.author)
    puts "🥳 \n You have a new game added to your catalog🤗."
  end

  # List_games method:
  # checks if @games is empty
  # if not, the print out the game list

  def list_games
    if @games.empty?
      puts 'No games available yet!'
    else
      @games.each do |game|
        puts "
          Game id: #{game.id}
          Publish date : #{game.publish_date}
          Multiplayer: #{game.multiplayer == 'y' ? 'Yes' : 'No'}
          Last played date : #{game.last_played_at}
          "
      end
    end
  end

  # List_authors method:
  # checks if @authors is empty
  # if not, then print out the author list

  def list_authors
    if @authors.empty?
      puts 'no authors available!'
    else
      @authors.each do |author|
        puts "
          Author's id: #{author.id}
          Author's name: #{author.first_name}
          Author's lastname: #{author.last_name}
        "
      end
    end
  end
end