require_relative './item'

class Genre
  attr_reader :id, :items
  attr_accessor :name

  # contains all instances of the Genre class
  @@all = [] # rubocop:disable Style/ClassVars

  # @param {String} name
  def initialize(name)
    @id = Random.rand(1..2000)
    @name = name
    @items = []
    # adds the newly created genre instance to the class variable @@all
    @@all << self
  end

  # @param {Item} item
  def add_item(item)
    if item.genre&.name
      'The genre of the Item has already been set.'
    else
      @items << item
      item.add_genre(self) unless item.genre == (self)
    end
  end

  # @return {Genre[]}
  def self.all
    @@all
  end

  # searches through the @@all for an instance of
  # the Genre class that matches the provided id
  # @param {Integer} id
  # @return {Genre}
  def self.find(id)
    all.find { |genre| genre.id == id }
  end

  # @param {Item} item
  # Convert object to json
  def to_json(*_args)
    JSON.generate({
                    id: @id,
                    name: @name,
                    items: @items
                  })
  end

  # Convert json string to object
  def self.from_json(string)
    data = JSON.parse(string)
    obj = new(data['name'])
    obj.instance_variable_set(:@id, data['id'])
    obj
  end
end