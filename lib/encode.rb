#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

# Require configuration
require_relative 'configuration'

pattern = /\d/

def send_message(data, queue)
  send_conn = Bunny.new(Configuration.rabbitmq_url, :automatically_recover => false)
  send_conn.start
  send_ch = send_conn.create_channel
  send_q = send_ch.queue(queue)
  send_ch.default_exchange.publish(data, :routing_key => send_q.name, :persistent => true)
  puts " [x] Sent '#{data}'"
  send_conn.close
end

conn = Bunny.new(:automatically_recover => false)
conn.start

ch   = conn.create_channel
q    = ch.queue("encode")

begin
  puts " [*] Waiting for messages. To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    if body.match(pattern)
      send_message(body.reverse, "receiver")
    else
      send_message(body, "logger")
    end
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
