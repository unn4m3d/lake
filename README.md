Lake
==

A lightweight Ruby task system

Examples
--

```ruby
target "lake-0.1.4.gem", "dependency1","dependency2" do
  # Ruby code that executes if targeted or in case of unsatisfied dependencies
  # Existance of file "lake-1.0.0.gem" is also a dependency
end

mandatory target(:check){
  # Ruby code that executes BEFORE all
}

unchecked target(:always_build){
  # Ruby code that executes even if built target exists and dependencies are built
}

virtual target(:virtual){
  # Ruby code that executes if there is a dependency needs build, but makes no sense for target file existance
}

hidden target(:something,:always_build){
  #This target won't be listed in list (lake -T)
  #Also, it cannot be targeted
  #Depends on "always_build"
}
```

`hidden`,`mandatory`,`unchecked` and `virtual` can be combined:
```ruby
hidden unchecked target(:something){...}
hidden mandatory target(:something2){...}
  #And so on...
```

Note you **MUST** use **brackets** and **curly braces** when using `hidden`,`mandatory` or `unchecked` due to Ruby syntactic rules

Another way is using this words as follows :
```ruby
  target :something do ... end

  hidden unchecked :something
  # OR
  hidden :something
  unchecked :something
```

Installing
--

Manual : `gem build lake.gemspec && gem install ./lake-0.1.2.gemspec`
Automatic (works if previous version of lake is installed) : `lake install`
From RubyGems : `gem install lake`
