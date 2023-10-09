require_relative './item'
class Game < Item
  # Makes our class properties accessible
  attr_reader :publish_date
  attr_accessor :multiplayer, :last_played_at

  # Class initialization
  # Parameters:
  # multiplayer: boolean
  # last_played_at: date
  # publish_date: boolean
  def initialize(multiplayer, publish_date, last_played_at = Time.new.strftime('%Y-%m-%d'))
    # Calls the parent class constructor
    super publish_date
    @multiplayer = multiplayer
    @last_played_at = last_played_at
    @publish_date = publish_date
  end

  # We check if the game can be archive or not
  # should return true if parent's method returns true AND if last_played_at is older than 2 years
  # otherwise, it should return false
  def can_be_archived?
    super && (@last_played_at.to_i < Date.today.year - 2)
  end
end