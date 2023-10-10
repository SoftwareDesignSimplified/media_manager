class MusicAlbum < Item
  attr_accessor :on_spotify, :publish_date
  attr_reader :id, :archived, :name

  # @param {Boolean} on_spotify
  # @param {String} publish_date
  # @param {Boolean} archived
  def initialize(on_spotify:, publish_date:, archived: false, name: "")
    super(publish_date, archived)
    @on_spotify = on_spotify
    @name = name
  end

  def on_spotify?
    @on_spotify
  end

  def archived?
    @archived
  end

  # @override
  # @return true if parent's method returns true AND if on_spotify equals true
  def can_be_archived?
    super && @on_spotify
  end

  # @override
  # serialization : object to json
  # call the original to_json method
  # parse the json representation into Ruby hash
  # merge the hash with the new attributes
  # convert the hash back to json
  def to_json(*args)
    super_attrs = JSON.parse(super(*args))
    merged_attrs = super_attrs.merge({ on_spotify: @on_spotify, name: @name })
    JSON.generate(merged_attrs)
  end

  # @override
  # deserialization : json to object
  # @param {String}
  # @return {MusicAlbum}
  def self.from_json(string)
    data = JSON.parse(string)
    new(on_spotify: data['on_spotify'], publish_date: data['publish_date'], archived: data['archived'], name: data['name'])
  end
end