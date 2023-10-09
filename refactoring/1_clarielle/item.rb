class Item
  attr_accessor :publish_date, :archived, :id, :genre, :source, :author, :label

  # convert publish_date to a date format

  def initialize(publish_date = Time.new.strftime('%Y-%m-%d'), archived) # rubocop:disable Style/OptionalArguments
    @id = Random.rand(1..1000)
    @publish_date = publish_date
    @archived = archived
  end

  def add_genre(genre)
    @genre = genre
    genre.items << self unless genre.items.include?(self)
  end

  def add_source(source)
    @source = source
    source.items << self unless source.items.include?(self)
  end

  ##
  # This function adds the current item to the author's list of items if it is not already included.
  # Args:
  #   author: The parameter "author" is a variable that represents an instance of the Author class. It
  # is passed as an argument to the "add_author" method.
  def add_author(author)
    @author = author
    author.items << self unless author.items.include?(self)
  end

  def add_label(label)
    @label = label
    label.items << self unless label.items.include?(self)
  end

  ##
  # This Ruby function checks if an item can be archived based on its publish date being more than 10
  # years ago.
  def can_be_archived?
    @publish_date.to_i < Date.today.year - 10
  end

  def move_to_archive
    @archived = true if can_be_archived?
  end

  # Convert object to json
  def to_json(*_args)
    genre_id = (@genre.id if defined? @genre)
    JSON.generate({
                    id: @id,
                    publish_date: @publish_date,
                    archived: @archived,
                    genre_id: genre_id
                  })
  end

  # Convert json string to object
  def self.from_json(string)
    data = JSON.parse(string)
    obj = new(data['publish_date'], archived: data['archived'])
    obj.instance_variable_set(:@id, data['id'])
    genre_id = data['genre_id']
    obj.instance_variable_set(:@genre, Genre.find(genre_id))
    obj
  end
end