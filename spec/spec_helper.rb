# frozen_string_literal: true
require 'chefspec'
require 'chefspec/berkshelf'

# Coverage report
require 'simplecov'
SimpleCov.start

# Require all our libraries
Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }
