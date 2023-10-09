module IOHelper
  # write objects to json file
  def write_file(obj, file)
    json = obj.map(&:to_json)
    file.seek(0)
    file.write(json)
    file.flush
  end

  def read_file_object(file, class_name)
    file.seek(0)
    json = file.read
    if json.length > 0
      JSON.parse(json).map { |obj| Object.const_get(class_name).from_json(obj) }
    else
      []
    end
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