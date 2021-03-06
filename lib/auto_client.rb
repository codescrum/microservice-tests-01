#!/usr/bin/env ruby
# encoding: utf-8

######################
## Automatic Client ##
######################

require "bunny"

require 'rubygems'

# Require configuration
require_relative 'configuration'

conn = Bunny.new(Configuration.rabbitmq_url, :automatically_recover => false)
conn.start

ch   = conn.create_channel
q    = ch.queue("gateway_queue")

stamp = 0

loop do
  stamp = stamp + 1
  random_string = ('a'..'z').to_a.shuffle[0,3].join
  data = "[auto] - %03d - #{random_string}" % stamp
  ch.default_exchange.publish(data, :routing_key => q.name)
  puts " [Auto] Sent '#{data}'"
  sleep 1
end

conn.close
