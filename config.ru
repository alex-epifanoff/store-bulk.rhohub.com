#!/usr/bin/env ruby
require 'rubygems'
require 'bundler'

Bundler.require

ENV['AMAZON_ACCESS_KEY_ID'] = 'AKIAJWPYZ57GTB3NN6AQ'
ENV['AMAZON_SECRET_ACCESS_KEY'] = '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'

ROOT_PATH = File.expand_path(File.dirname(__FILE__))

if ENV['DEBUG'] == 'yes'
  ENV['APP_TYPE'] = 'rhosync'
  ENV['ROOT_PATH'] = ROOT_PATH
  require 'debugger'
end

require 'rhoconnect/server'
require 'rhoconnect/web-console/server'
require 'resque/server'

# Rhoconnect server flags
#Rhoconnect::Server.enable  :stats
Rhoconnect::Server.disable :run
Rhoconnect::Server.disable :clean_trace
Rhoconnect::Server.enable  :raise_errors
Rhoconnect::Server.set     :secret,      'ef416c01a916dd2cc0d09355e0dee3b9dcfa5799a6bc2cc3231a32a90f73f3accd2427453f7c40c3e552fbfdc5aad09ced80371eefaf07c6da9dd0127a5a5a48'
Rhoconnect::Server.set     :root,        ROOT_PATH
Rhoconnect::Server.use     Rack::Static, :urls => ['/data'], :root => Rhoconnect::Server.root
# disable Async mode if Debugger is used
if ENV['DEBUG'] == 'yes'
  Rhoconnect::Server.set :use_async_model, false
end

# Load our rhoconnect application
require './application'

# Setup the url map
run Rack::URLMap.new \
	'/'         => Rhoconnect::Server.new,
	'/resque'   => Resque::Server.new, # If you don't want resque frontend, disable it here
	'/console'  => RhoconnectConsole::Server.new # If you don't want rhoconnect frontend, disable it here