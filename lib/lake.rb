$targets = {}

module Lake
  VERSION='0.1.8'
  Target = Struct.new(:name,:proc,:deps,:flags) do
    def build(rec=true)
      if need_build? then
        puts "[INFO] Building #{name}"
        deps.each{
          |e|
          $targets[e.to_s].build if rec or $targets[e.to_s].flags[:unchecked]
        }
        proc.call if proc
      else
        puts "[INFO] #{name} is already built"
      end
    end

    def need_build?
      for dep in deps do
        #return true if not $targets[dep.to_s] and not File.exists? dep.to_s
        #return true if $targets[dep.to_s] and $targets[dep.to_s].need_build?
        if $targets[dep.to_s] then
          return true if $targets[dep.to_s].need_build?
        else
          return true unless File.exists? dep.to_s
        end
      end
      return true if flags[:unchecked]
      if flags[:virtual] then
        return false
      else
        return ! File.exists?(name.to_s)
      end
    end
  end

  def calc_deps(t)
    arr = []
    puts "[INFO] Calculating dependencies for #{t}"
    $targets[t.to_s].deps.each do
      |d|
      arr << d if $targets[d.to_s].need_build?
      arr += calc_deps(d)
    end
    arr.uniq
  end

  def build_t(t,rec=false)
    $targets.each do
      |k,tr|
      tr.build(rec) if tr.need_build? and tr.flags[:mandatory]
    end

    if rec then
      if $targets[t] and not $targets[t].flags[:hidden]
        $targets[t].build if $targets[t].need_build?
      else
        puts "[FATAL] No actions for target #{t}"
      end
    else
      deps = calc_deps(t)
      deps.each{
        |d|
        if $targets[d.to_s] then
          $targets[d.to_s].build rec
        elsif File.exists? d.to_s then
          puts "[INFO] File dependency #{d} satisfied"
        else
          puts "[FATAL] Cannot satisfy dependency #{d}"
        end
      }
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

  def virtual(name)
    $targets[name].flags[:virtual] = true
  end

  def use(*plugin)
    plugin.each{|p|require "lake/plugins/#{p.to_s}"}
  end
end
