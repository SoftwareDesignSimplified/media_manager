require_relative 'test_helper'
require_relative '../item'
require_relative '../music_album'
require 'json'

describe 'Music Album' do
  it 'can serialize itself to json' do
    album = MusicAlbum.new(on_spotify: true, publish_date: '2011-01-01', archived: true)

    album_as_json = album.to_json

    actual = album_as_json
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

    album_as_json = album.to_json

    actual = album_as_json
             .then(&parse)
             .fetch('name')
    expected = 'Pop'
    assert_equal expected, actual
  end

  it 'can be parsed from JSON when we supply a name' do
    music_album_json = {
      'name' => 'Pop',
      'publish_date' => '2011-01-01',
      'archived' => true,
      'genre_id' => nil,
      'on_spotify' => true
    }.to_json

    actual_album = MusicAlbum.from_json(music_album_json)

    assert_equal 'Pop', actual_album.name
    assert_equal '2011-01-01', actual_album.publish_date
    assert actual_album.archived?
    assert actual_album.on_spotify?
  end

  private

  def parse
    ->(json) { JSON.parse(json) }
  end
end
