#!/usr/bin/env ruby
# encoding: utf-8

##############################
## Message Processor/Worker ##
##############################

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
  puts " [x] Processed '#{data}'"
  send_conn.close
end

conn = Bunny.new(Configuration.rabbitmq_url, :automatically_recover => false)
conn.start

ch   = conn.create_channel
q    = ch.queue("encode")

begin
  puts " [*] Encoder ------"
  puts " [*] Waiting for messages to process"
  puts " [*] To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|

    # Sleep a determinate amount of time, simulating a long running task
    work_time = body.count(".").to_i

    puts "    - Intensive task running #{work_time} seconds"
    sleep work_time
    puts "    [OK] done!"

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