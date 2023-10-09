require_relative "./app"

def main
  start = App.new(input: $stdin, output: $stdout)
  loop do
    start.start
  end
end

main