ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
Dir["cql-to-elm-0.1-SNAPSHOT/lib/*.jar"].each { |jar| require jar }
require 'bundler/setup' # Set up gems listed in the Gemfile.
