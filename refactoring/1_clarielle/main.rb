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

def main
  start = App.new
  loop do
    start.start
  end
end

main