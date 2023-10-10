require_relative 'test_helper'
require_relative '../item'
require_relative '../music_album'
require 'json'

describe 'Music Album' do
  it 'can serialize itself to json' do
    album = MusicAlbum.new(on_spotify: true, publish_date: '2011-01-01', archived: true)
    actual = album
             .to_json
             .then(&parse)
             .slice('publish_date', 'archived', 'genre_id', 'on_spotify')
    expected = {
      'publish_date' => '2011-01-01',
      'archived' => true,
      'genre_id' => nil,
      'on_spotify' => true
    }
    assert_equal expected, actual
  end

  it 'can be supplied with a name' do
    album = MusicAlbum.new(on_spotify: true, publish_date: '2011-01-01', archived: true, name: 'Pop')
    actual = album
             .to_json
             .then(&parse)
             .fetch('name')
    expected = 'Pop'
    assert_equal expected, actual
  end

  it 'can be parsed from JSON when we supply a name' do
    attributes = {
      'name' => 'Pop',
      'publish_date' => '2011-01-01',
      'archived' => true,
      'genre_id' => nil,
      'on_spotify' => true
    }
    album = MusicAlbum.from_json(attributes.to_json)
    assert_equal 'Pop', album.name
  end

  private

  def parse
    ->(json) { JSON.parse(json) }
  end
end
