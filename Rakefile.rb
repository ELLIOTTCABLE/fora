def __DIR__; File.dirname(__FILE__); end
NAME = "fora"

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