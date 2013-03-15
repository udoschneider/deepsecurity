#!/usr/bin/env rake
require "bundler/gem_tasks"

desc "create a new version, create tag and push to github"
task :github_and_tag do
  Rake::Task['github:release'].invoke
  Rake::Task['git:release'].invoke
end

desc "Build Windows Installer"
task :windows_installer do
  require "dsc"
  RUBY_INSTALLER_VERSION = "1.9.3-p392"
  GEM_VERSION = Dsc::VERSION.to_s
  system("./windows-installer/iscc windows-installer/dsc.iss /dgemVersion=\"#{GEM_VERSION}\" /drubyVersion=\"#{RUBY_INSTALLER_VERSION}\"")
end


