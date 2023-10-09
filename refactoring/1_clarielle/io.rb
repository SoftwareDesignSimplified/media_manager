module IOHelper
  # write objects to json file
  def write_file(obj, filename)
    # serialization: object to json
    json = obj.map(&:to_json)
    # write to file
    File.write(filename, json, mode: 'w')
  end

  # read objects from json file
  def read_file(filename, class_name)
    if File.exist?(filename) and File.size(filename).positive?
      # read from file
      json = File.read(filename, mode: 'r')
      # deserialization: json to object
      JSON.parse(json).map { |obj| Object.const_get(class_name).from_json(obj) }
    else
      # Return an empty array if filename does not exist
      []
    end
  end
end