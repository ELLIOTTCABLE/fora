require 'rubygems'
Gem.clear_paths
Gem.path.unshift(File.join(File.dirname(__FILE__), "gems"))

require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'fileutils'
require 'merb-core'
require 'rubigen'

$RAKE_ENV = true

init_file = File.join(File.dirname(__FILE__) / "config" / "init")

Merb.load_dependencies(init_file)
           
include FileUtils
# # # Get Merb plugins and dependencies
Merb::Plugins.rakefiles.each {|r| require r } 

desc "load merb_init.rb"
task :merb_init do
  require 'merb-core'
  require File.dirname(__FILE__)+'/config/init.rb'
end  

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end

# =====================================================
# = This whole section is really gerryrigged. FIXME!: =
# =====================================================

# You'll want to set DB=p|d|t etc with this:
#   rake migrate DB=t
task :migrate do
  env = case ENV['DB']
  when 'p'
    'production'
  when 't'
    'test'
  else
    'development'
  end
  
  puts "Migrating #{env}."
  
  system "rake dm:db:automigrate MERB_ENV=\"#{env}\" &>/dev/null" # System'ing it, to silence it.
end
task :migrate_test do
  system 'rake dm:db:automigrate MERB_ENV="test" &>/dev/null'
end
task :run_specs do
  dirs = []
  Dir['app/*'].each do |dir|
    dirs << Dir['spec/' + dir.gsub(%r|^app/|,'') + '/**/*']
  end
  files = dirs.flatten.map{|d|"\"#{d}\""}.join(' ')
  system 'spec --format specdoc --colour ' + files
end

desc 'Migrate, then run specs'
task :aok => [:migrate_test, :run_specs]

# =======================================================
# = This is pretty bad too, but not AS bad. FIXME ALSO: =
# =======================================================

unless Gem.cache.search("haml").empty?
  namespace :haml do
    desc "Compiles all sass files into CSS"
    task :compile_sass do
      gem 'haml'
      require 'sass'
      puts "*** Updating stylesheets"
      Sass::Plugin.update_stylesheets
      puts "*** Done"      
    end
    
    desc "Move gen'd .erb files to .haml"
    task :erb2haml do
      require 'fileutils'
      
      print 'gitillate? '
      gitillate = STDIN.gets.match /^y(es)?$/
      
      affirm = Proc.new { |what|
        puts what
        print 'move? '
        affirmation = STDIN.gets
      }
      
      Dir['**/*'].each do |filename|
        if filename.match /\.erb$/
          affirmation = affirm.call(filename).match /^y(es)?$/
          if affirmation
            new_filename = filename.gsub(/\.erb$/, '.haml')
            FileUtils.cp(filename, new_filename)
            if gitillate
              if system "git rm './#{filename}'"
                system "git add './#{new_filename}'"
              end # if system git rm
            end # if gitillate
          end # if affirmation
        end # filename .erb
        
        if filename.match /\.erb_spec\./
          affirmation = affirm.call(filename).match /^y(es)?$/
          if affirmation
            new_filename = filename.gsub(/\.erb_spec\./, '.haml_spec.')
            FileUtils.cp(filename, new_filename)
            if gitillate
              if system "git rm './#{filename}'"
                system "git add './#{new_filename}'"
              end # if system git rm
            end # if gitillate
          end # if affirmation
        end # filename .erb_spec.
      end # Dir each
    end # task :erb2haml
  end # namespace :haml
end # unless gem cache