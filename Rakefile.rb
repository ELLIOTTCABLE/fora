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

Merb.start :environment => (ENV['MERB_ENV'] || 'development'),
           :adapter     => 'runner',
           :merb_root  => File.dirname(__FILE__)
           
include FileUtils
# # # Get Merb plugins and dependencies
Merb::Plugins.rakefiles.each {|r| require r } 

# 
#desc "Packages up Merb."
#task :default => [:package]

desc "load merb_init.rb"
task :merb_init do
  require 'merb-core'
  require File.dirname(__FILE__)+'/config/init.rb'
end  

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end

desc 'Run all tests, specs and finish with rcov'
task :aok do
  sh %{rake rcov}
  sh %{rake spec}
end

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
  end
end

##############################################################################
# Git
##############################################################################
namespace :git do
  desc "Add all new modifications to repository, indiscriminately"
  task :add do
    system "git add *"
  end

  desc "Fetch new modifications from origin, and rebase"
  task :rebase do
    system "git stash; git svn rebase; git stash apply"
  end
  
  desc "commit modifications to the repository"
  task :commit do
    system "git commit"
  end
  
  desc "push changes to the origin"
  task :push do
    system "git commit; git push origin"
  end
end