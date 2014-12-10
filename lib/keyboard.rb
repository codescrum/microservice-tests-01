require 'rubygems'
require 'eventmachine'

module MyKeyboardHandler
  include EM::Protocols::LineText2
  def receive_line data
    puts "I received the following line from the keyboard: #{data}"
  end
end

EM.run {
  EM.open_keyboard(MyKeyboardHandler)
}
