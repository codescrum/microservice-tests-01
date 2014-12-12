#!/usr/bin/env ruby
# encoding: utf-8

###############################
## Intermediate microservice ##
###############################

require "bunny"

# Require configuration
require_relative 'configuration'

def send_message(data)
  send_conn = Bunny.new(Configuration.rabbitmq_url, :automatically_recover => false)
  send_conn.start
  send_ch = send_conn.create_channel
  send_ex = send_ch.fanout("queue_a_exchange")
  send_ex.publish(data)
  puts " [x] Mediating '#{data}'"
  send_conn.close
end

conn = Bunny.new(Configuration.rabbitmq_url, :automatically_recover => false)
conn.start

ch = conn.create_channel
q = ch.queue("queue_a")

begin
  puts " [*] Intermediate step ------"
  puts " [*] Waiting for messages..."
  puts " [*] To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    send_message("Mediated: #{body}")
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
