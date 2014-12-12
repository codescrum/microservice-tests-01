#!/usr/bin/env ruby
# encoding: utf-8

#########################
## Logger microservice ##
#########################

require "bunny"

# Require configuration
require_relative 'configuration'

conn = Bunny.new(Configuration.rabbitmq_url, :automatically_recover => false)
conn.start

ch = conn.create_channel
x = ch.fanout("gateway_exchange")
q = ch.queue("logger_queue")
q.bind(x)

begin
  puts " [*] Logger ------"
  puts " [*] Waiting for messages. To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] #{body}"
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
