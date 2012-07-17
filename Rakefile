ENV['AMAZON_ACCESS_KEY_ID'] = 'AKIAJWPYZ57GTB3NN6AQ'
ENV['AMAZON_SECRET_ACCESS_KEY'] = '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'

ROOT_PATH = File.expand_path(File.dirname(__FILE__))
$:.unshift ROOT_PATH
ENV['ROOT_PATH'] = ROOT_PATH

require 'rubygems'
require 'bundler/setup'
require 'rhoconnect/tasks'
require 'rhoconnect'
require 'resque/tasks'

task 'resque:setup' do
  require './application'
end
