require 'uri'

class Params
  def initialize(req, route_params)
    @req = req
    @route_params = route_params
    @params = {}
    parse_www_encoded_form(@req.query_string)
    parse_www_encoded_form(@req.body)
  end

  def [](key)
  end

  def to_s
  end

  private

  def parse_www_encoded_form(www_encoded_form)
    return nil if www_encoded_form.nil?

    URI::decode_www_form(www_encoded_form).each do |pair|
      # first_pair = ["cat[name]", "Breakfast"]
      parse_key(pair.first).last = pair.last
  end


  # arr = ["cat[name]", "Breakfast"]
  def nested_parse(arr)
    if parse_key(arr.first).count == 1
      return parse_key(arr.first)
    else
      nested_parse(arr.first) = arr.last
  end

  def parse_key(key)
    if key.split(/\]\[|\[|\]/)
  end
end

# URI::decode_www_form(www_encoded_form)
#  => [["cat[name]", "Breakfast"], ["cat[owner]", "Devon"]]
# [["cat[name]", "Breakfast"], ["cat[owner]", "Devon"]]
# "cat[name]".split(/\]\[|\[|\]/) => ["cat", "name"]