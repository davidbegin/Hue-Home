require "hue"
require "colorize"

class BeginsHouse
  def initialize(client)
    @client = client
  end

  LATENCY = 0.04
  TRANSITION_IN_SECONDS = 20

  def random_lights
    loop do
      client.lights.each do |light|
        result = light.set_state(
          :hue => random_hue,
          :color_temperature => random_temp,
        )

        sleep LATENCY

        if result.map(&:keys).uniq.first.first == "success"
          puts "#{light.name} successfully changed!".green
        else
          puts result
          puts "#{light.name} unsuccessfully changed :(".red
        end
      end
    end
  end


  def color_loop
    client.lights.each do |light|
      p result = light.set_state(
        {:effect => "colorloop"},
        TRANSITION_IN_SECONDS * 10
      )
    end
  end

  def toggle_lights
    loop do
      client.lights.each do |light|
        puts "turnings lights off!".red
        light.off!
      end

      client.lights.each do |light|
        puts "turnings lights on!".green
        light.on!
      end
    end
  end

  private

  attr_reader :client

  def random_hue
    Random.rand(Hue::Light::HUE_RANGE)
  end

  def random_temp
    Random.rand(Hue::Light::COLOR_TEMPERATURE_RANGE)
  end
end

client = Hue::Client.new
begins_house = BeginsHouse.new(client)
# begins_house.toggle_lights
# begins_house.random_lights
begins_house.color_loop
