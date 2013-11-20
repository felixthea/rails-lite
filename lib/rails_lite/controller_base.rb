require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @route_params = route_params
    @already_built_response = false
    @params = Params.new(@req, @route_params)
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
  end

  def redirect_to(url)
    if @already_built_response == false
      @res.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect,url)
      @already_built_response = true
      session.store_session(@res)
    end
  end

  def render_content(content, type)
    if @already_built_response == false
      @res.content_type = type
      @res.body = content
      @already_built_response = true
      session.store_session(@res)
    end
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    template = File.read("views/#{controller_name}/#{template_name}.html.erb")
    content = ERB.new("#{template}").result(binding)
    render_content(content,"text/html")
  end

  def invoke_action(action_name)
    self.send(action_name)
  end
end
