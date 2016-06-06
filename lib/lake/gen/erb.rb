require "erb"

module Lake
  module ERB
    def render(template,vars)
      b = binding
      out = nil
      ::ERB.new(template,0,nil,"out").result b
      return out
    end
    module_function :render
  end
end
