class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
    @params = {}
  end

  def matches?(req)
    return true if http_method == req.request_method.downcase.to_sym &&
      Regexp.new(@pattern).match(req.path)
    false
  end

  def run(req, res, params)
    controller_inst = controller_class.new(req,res,params)
    controller_inst.invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete, :index].each do |http_method|
    define_method(http_method) { |pattern, controller_class, action_name| add_route(pattern, http_method, controller_class, action_name) }
  end

  def match(req)
    @routes.each do |route|
      return route if route.matches?(req)
    end

    nil
  end

  def run(req, res)
    matching_route = match(req)
    if matching_route.nil?
      res.status = 404
    else
      matching_route.run(req,res)
    end
  end
end
