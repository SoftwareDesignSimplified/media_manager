require_relative 'test_helper'
require_relative '../item'
require_relative '../music_album'
require 'json'

describe 'Music Album' do
  it 'can serialize itself to json' do
    album = MusicAlbum.new(on_spotify: true, publish_date: '2011-01-01', archived: true)

    actual = parsed_from_json(album.to_json).slice('publish_date', 'archived', 'genre_id', 'on_spotify')
    expected = ({
      'publish_date' => '2011-01-01',
      'archived' => true,
      'genre_id' => nil,
      'on_spotify' => true
    })
    assert_equal expected, actual
  end

  it 'can be supplied with a name' do
    album = MusicAlbum.new(on_spotify: true, publish_date: '2011-01-01', archived: true, name: 'Pop')
    json = album.to_json
    parsed_album = JSON.parse(json)
    assert_equal 'Pop', parsed_album.fetch('name')
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

  def parsed_from_json(json)
    JSON.parse(json)
  end
end
