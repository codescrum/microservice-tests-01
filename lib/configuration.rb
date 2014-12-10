# Configuration, to be more DRY
class Configuration
  def self.rabbitmq_url
    boxen_rabbitmq_url || default_url
  end

  def self.default_url
    ""
  end

  def self.boxen_rabbitmq_url
    ENV['BOXEN_RABBITMQ_URL']
  end
end
