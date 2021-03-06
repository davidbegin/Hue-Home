require 'rubygems'
require 'bundler/setup'

require "hue"
require "colorize"

class BeginsHouse
  def initialize(client)
    @client = client
  end

  LATENCY = 0.04
  TRANSISTION_IN_SECONDS = 60

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
        {
          :brightness => Hue::Light::BRIGHTNESS_RANGE.last,
          :effect => "colorloop"
        },
        TRANSISTION_IN_SECONDS * 10
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

  def super_crazy
    loop do
      client.lights.each do |light|
        next if Random.rand(1..4) == 4

        puts "turnings lights off!".red
        light.off!
      end

      client.lights.each do |light|
        puts "turnings lights off!".red
        light.on!
        result = light.set_state(
          :hue => [100, 46920, 45000].sample,
          :color_temperature => Hue::Light::COLOR_TEMPERATURE_RANGE.last,
          :brightness => Hue::Light::BRIGHTNESS_RANGE.last
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

  def midnight
    loop do
      light =  client.lights.sample

      p result = light.set_state(
        {
        :hue => Random.rand(Hue::Light::HUE_RANGE),
        :brightness => Hue::Light::BRIGHTNESS_RANGE.last
        }, 10 * 10
      )

      light.on!
      sleep 1

      light.off!
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
# book_shelf_orb = client.lights.find {|light| light.id == "2" }
# corner = client.lights.find {|light| light.id == "4" }
# book_shelf_orb.on!
# corner.on!

# loop do
#   p result = book_shelf_orb.set_state(
#     :hue => Random.rand(Hue::Light::HUE_RANGE),
#     :brightness => Hue::Light::BRIGHTNESS_RANGE.last
#     # :brightness => Random.rand(Hue::Light::BRIGHTNESS_RANGE)
#   )
#     # :color_temperature => Random.rand(Hue::Light::COLOR_TEMPERATURE_RANGE),
#
#   sleep 0.25
#   # sleep 0.04
#   # p result = corner.set_state(
#   #   :hue => Random.rand(Hue::Light::HUE_RANGE),
#   #   :brightness => Hue::Light::BRIGHTNESS_RANGE.last
#   #   # :brightness => Random.rand(Hue::Light::BRIGHTNESS_RANGE)
#   # )
#   #   # :color_temperature => Random.rand(Hue::Light::COLOR_TEMPERATURE_RANGE),
#   #
#   # sleep 0.5
#   # sleep 0.04
# end




begins_house = BeginsHouse.new(client)
# require 'pry'; binding.pry; 1
# begins_house.midnight
# begins_house.toggle_lights
# begins_house.random_lights
# begins_house.color_loop
begins_house.super_crazy
