#!/usr/bin/env ruby
# encoding: utf-8

###############################
## Intermediate microservice ##
###############################

require "bunny"

# Require configuration
require_relative 'configuration'

def send_message(data, queue)
  send_conn = Bunny.new(Configuration.rabbitmq_url, :automatically_recover => false)
  send_conn.start
  send_ch = send_conn.create_channel
  send_q = send_ch.queue(queue)
  send_ch.default_exchange.publish(data, :routing_key => send_q.name, :persistent => true)
  puts " [x] Mediating '#{data}'"
  send_conn.close
end

conn = Bunny.new(Configuration.rabbitmq_url, :automatically_recover => false)
conn.start

ch   = conn.create_channel
q    = ch.queue("queue_a")

begin
  puts " [*] Intermediate step ------"
  puts " [*] Waiting for messages..."
  puts " [*] To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    send_message("Mediated: #{body}", "logger")
    send_message(body, "work_queue")
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
