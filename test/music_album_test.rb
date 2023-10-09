require_relative "test_helper"
require_relative "../item"
require_relative "../music"
require 'json'

describe "Music" do
  it "can serialize itself to json" do
    album = MusicAlbum.new(true, "2011-01-01", archived: true)
    json = album.to_json({})
    parsed_album = JSON.parse(json)
    assert_equal ({ "publish_date"=>"2011-01-01", "archived"=>true, "genre_id"=>nil, "on_spotify"=>true}), parsed_album.slice("publish_date", "archived", "genre_id", "on_spotify")
  end

  it "can be supplied with a name" do
    album = MusicAlbum.new(true, "2011-01-01", archived: true, name: "Pop")
    json = album.to_json({})
    parsed_album = JSON.parse(json)
    assert_equal "Pop", parsed_album.fetch("name")
  end

  it "can be parsed from JSON when we supply a name" do
    attributes = { "name" => "Pop", "publish_date"=>"2011-01-01", "archived"=>true, "genre_id"=>nil, "on_spotify"=>true}
    album = MusicAlbum.from_json(attributes.to_json)
    assert_equal "Pop", album.name
  end
end
