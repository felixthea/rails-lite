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
    params = {}
    key_values = URI::decode_www_form(www_encoded_form)
    # key_values => [["cat[name]", "Breakfast"], ["cat[owner]", "Devon"]]
    key_values.each do |full_key, value|
      scope = @params

      key_seq = parse_key(full_key)
      key_seq.each_with_index do |key, idx|
        if (idx + 1) == key_seq.count
          scope[key] = value
        else
          scope[key] ||= {}
          scope = scope[key]
        end
      end
    end

    params
  end

  def parse_key(key)
    match_data = /(?<head>.*)\[(?<rest>.*)\]/.match(key)
    if match_data
      parse_key(match_data["rest"]).unshift(match_data["head"])
    else
      [key]
    end
  end
end