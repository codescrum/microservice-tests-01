####################
## Configuration  ##
####################

# Configuration, to be more DRY
# add connection urls here
class Configuration
  def self.rabbitmq_url
    boxen_url || docker_url || default_url
  end

  def self.default_url
    "amqp://guest:guest@localhost:5672"
  end

  def self.docker_url
    amqp_port_address = ENV['AMQ_PORT_5672_TCP_ADDR']
    amqp_port_address ? "amqp://guest:guest@#{amqp_port_address}:5672" : nil
  end

  def self.boxen_url
    ENV['BOXEN_RABBITMQ_URL']
  end
end
