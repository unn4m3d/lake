require 'lake/gen/erb'
require 'optparse'
module Lake::Gen
  def render_template(template,vars,file)
    File.open(file,"w") do |f|
      f.write(::Lake::ERB.render(template,vars))
    end
  end
  module_function :render_template
end
