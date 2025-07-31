# frozen_string_literal: true

require "sinatra"
require "rubygems"
require "bundler/setup"

Bundler.require(:default, Sinatra::Application.environment)

# Bundler.require(:default) will automatically require all global gems and
# Bundler.require(Sinatra::Application.environment) will automatically require
# all environment-specific gems.
#
# See: http://bundler.io/v1.6/groups.html
#
# NOTE: Sinatra::Application.environment is set to the value of ENV['RACK_ENV']
# if ENV['RACK_ENV'] is set.  Otherwise, it defaults to :development.

# Load the .env file if it exists
Dotenv.load(".env") if File.exist?(".env")
