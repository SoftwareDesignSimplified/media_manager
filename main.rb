require_relative "./app"

def main
  start = App.new(input: $stdin, output: $stdout, music_album_store: File.open('./data/music_album.json', 'r+'), genres_store: File.open('./data/genres.json', 'r+'))
  loop do
    start.start
  end
end

main