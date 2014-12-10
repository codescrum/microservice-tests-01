#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"
url = ENV['BOXEN_RABBITMQ_URL']
# url = "amqp://test:test@192.168.0.7:5672/test"
conn = Bunny.new(url, automatically_recover: false)
conn.start

ch   = conn.create_channel
q    = ch.queue("hello")

begin
  puts " [*] Waiting for messages. To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
