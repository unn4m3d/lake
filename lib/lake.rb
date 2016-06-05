$targets = {}

module Lake
  VERSION='0.1.0 Beta'
  Target = Struct.new(:name,:proc,:deps,:flags) do
    def build
      for d in deps
        if proc or need_build?
          $targets[d.to_s].build if $targets[d.to_s] 
        else
          puts "[INFO] #{d} is already built"
        end
      end
      puts "[INFO] Building #{name}"
      proc.call if proc
    end

    def need_build?
      for dep in deps do
        return true if not $targets[dep.to_s] and File.exists? dep.to_s
        return true if $targets[dep.to_s] and $targets[dep.to_s].need_build?
      end
      (!dep)||(!File.exists? dep)||(flags[:unchecked])
    end
  end

  def build_t(t)
    $targets.each do
      |k,tr|
      tr.build if tr.need_build? and tr.flags[:mandatory]
    end

    if $targets[t] and not $targets[t].flags[:hidden]
      $targets[t].build if $targets[t].need_build?
    else
      puts "[FATAL] No actions for target #{t}"
    end
  end

  def target(name,*deps,&block)
    $targets[name.to_s] = Target.new name,block,deps,{}
    return name.to_s
  end

  def hidden(name)
    $targets[name].flags[:hidden] = true
    return name
  end

  def unchecked(name)
    $targets[name].flags[:unchecked] = true
    return name
  end

  def mandatory(name)
    $targets[name].flags[:mandatory] = true
    return name
  end

  def use(*plugin)
    plugin.each{|p|require "lake/plugins/#{p.to_s}"}
  end
end
