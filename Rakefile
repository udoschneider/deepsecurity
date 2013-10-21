#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

desc "create a new version, create tag and push to github"
task :github_and_tag do
  Rake::Task['github:release'].invoke
  Rake::Task['git:release'].invoke
end

desc "Build Windows Installer"
task :windows_installer => :build do
  require "dsc"
  RUBY_INSTALLER_VERSION = "1.9.3-p392"
  GEM_VERSION = Dsc::VERSION.to_s
  system("./windows-installer/iscc windows-installer/dsc.iss /dgemVersion=\"#{GEM_VERSION}\" /drubyVersion=\"#{RUBY_INSTALLER_VERSION}\"")
end

Rake::TestTask.new do |t|
 t.libs << 'test'
 require "bundler/setup"

 gem 'deepsecurity', :path => "~/Documents/Development/deepsecurity"
end

desc "Run tests"
task :default => :test

desc "Build index.html for S3 Bucket"
task :s3_index do
  system("./generate_s3_links.sh > index.html")
end

