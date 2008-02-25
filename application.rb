class Fora < Merb::Controller

  def _template_location(action, type = nil, controller = controller_name)
    "#{action}.#{type}"
  end

  def index
    "Welcome to fora, version one! Just kidding."
  end

  def foo
    render
  end
  
end