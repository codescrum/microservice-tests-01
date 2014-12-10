#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

require 'rubygems'
require 'eventmachine'

# Require configuration
require_relative 'configuration'

module MyKeyboardHandler
  include EM::Protocols::LineText2
  def receive_line data
    conn = Bunny.new(Configuration.rabbitmq_url, :automatically_recover => false)
    conn.start

    ch   = conn.create_channel
    q    = ch.queue("queue_a")

    ch.default_exchange.publish(data, :routing_key => q.name, :persistent => true)
    puts " [x] Sent '#{data}'"

    conn.close
  end
end

EM.run {
  EM.open_keyboard(MyKeyboardHandler)
}
