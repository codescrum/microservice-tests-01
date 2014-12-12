#!/usr/bin/env ruby
# encoding: utf-8

####################
## Final receiver ##
####################

require "bunny"

# Require configuration
require_relative 'configuration'

conn = Bunny.new(Configuration.rabbitmq_url, automatically_recover: false)
conn.start

ch   = conn.create_channel
q    = ch.queue("receiver_queue")

begin
  puts " [*] Final receiver ------"
  puts " [*] Receiving processed messages..."
  puts " [*] To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] Received '#{body}'"
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
