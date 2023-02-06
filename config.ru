require 'bundler'
Bundler.require

$:.unshift File.expand_path('lib', __dir__)
require 'controller'

run ApplicationController
