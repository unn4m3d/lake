Lake
==

A lightweight Ruby task system with a file generating system (`lake-gen`)

**WARNING** This is unstable version, use `-r` key in case of compatibility errors

Lake CLI usage
--

```sh
  # Print help
  lake (-h|--help)
  # List targets
  lake (-T|--list)
  # Build target <target> (default "all") from file <file> (default "Lakefile")
  lake [(-f|--file) <file>] [<target>]
  # Show code before building
  lake [(-f|--file) <file>] (-l|--code) [<target>]
  # Use old recursive dependencies build behaviour
  lake -r ...
```

LakeGen CLI Usage
--

```sh
  # Print help
  lake-gen (-h|--help)
  # List templates
  lake-gen (-l|--list)
  # Get template from <url> (may be local or remote)
  # Saves to <name> if specified
  lake-gen (-i|--install) <url> [(-n|--name) <name>]
  # Generate file from template <template>
  # Saves to <name> if specified
  # Args are passed to template
  lake-gen [(-n|--name) <name>] <template> <arg1> ... <argN>
```

Lakefiles
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

Note you **MUST** use **brackets** and **curly braces** when using keywords due to Ruby syntactic rules

Another way is using this words as follows :
```ruby
  target :something do ... end

  hidden unchecked :something
  # OR
  hidden :something
  unchecked :something
```

LakeGen Templates
--

LakeGen Templates are just ERB templates, where command line arguments are passed as `vars`

See [Lakefile.erb](Lakefile.erb) for more info


Installing
--

* `gem build lake.gemspec && gem install ./lake-0.1.2.gemspec`
* `git clone https://github.com/unn4m3d/lake && cd lake && lake install` (works with Lake installed)
* `gem install lake` 
