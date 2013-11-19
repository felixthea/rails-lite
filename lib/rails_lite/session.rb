require 'json'
require 'webrick'

class Session
  def initialize(req)
    req.cookies.each do |cookie|
      if cookie.name == '_rails_lite_app'
        @session = JSON.parse(cookie.value)
      else
        @session = {}
      end
    end
  end

  def [](key)
    if @session.empty?
      nil
    else
      @session[key]
    end
  end

  def []=(key, val)
    @session[key] = val
  end

  def store_session(res)
    res.cookies << WEBrick::Cookie.new('_rails_lite_app', @session.to_json)
  end
end
