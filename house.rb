require 'rubygems'
require 'bundler/setup'
require 'minitest/reporters'

require "hue"
require "colorize"

class BeginsHouse
  LIVING_ROOM_NAMES = [
    "Living Room Book Corner",
    "Book Shelf Orb",
    "Living Room Plant Corner",
    "Plant Shelf Orb",
    "Richard Mosse",
    "Kitchen"
  ]

  # LATENCY = 0.04 # Gold Standard Latency
  LATENCY = 0.02

  def full_range
    Hue::Light::HUE_RANGE.step(100).each do |i|
      living_room.each do |light|
        p light.set_state({:hue => i})
        sleep LATENCY
      end
    end
  end

  def all_orange
    lights.each do |light|
      light.set_state({:hue => 10000})
    end
  end

  def all_red
    lights.each do |light|
      light.set_state({:hue => 100})
    end
  end

  def slow_fade
    lights.each do |light|
      light.set_state({:brightness => Hue::Light::BRIGHTNESS_RANGE.last}, 500)
    end
  end

  def max_bright
    lights.each do |light|
      light.set_state({:brightness => Hue::Light::BRIGHTNESS_RANGE.last})
    end
  end

  def max_dimness
    lights.each do |light|
      light.set_state({:brightness => Hue::Light::BRIGHTNESS_RANGE.first})
    end
  end

  def lights
    client.lights
  end

  def light_names
    lights.map(&:name)
  end

  def living_room
    lights.keep_if { |light| LIVING_ROOM_NAMES.include?(light.name) }
  end

  def client
    @client ||= Hue::Client.new
  end

  def moment_of_silence(length: 10)
    loop do
      fade_color_temperature_up
      sleep length
      fade_color_temperature_down
    end
  end

  def fade_color_temperature_up
    fade_color_temperature(value: Hue::Light::COLOR_TEMPERATURE_RANGE.last)
  end

  def fade_color_temperature_down
    fade_color_temperature(value: Hue::Light::COLOR_TEMPERATURE_RANGE.first)
  end

  # def fade_color_temperature(value:,)
  #   living_room.each do |light|
  #     light.set_state({:color_temperature => value}, 50)
  #   end
  # end
end

house = BeginsHouse.new
house.max_bright
# house.moment_of_silence(length: 10)
# house.max_dimness
# house.slow_fade
# house.all_red
# house.all_orange
# house.full_range

# require "minitest/autorun"

# reporter_options = { color: true }
#
# Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]
#
# class TestBeginsHouse < Minitest::Test
#   def setup
#     @house = BeginsHouse.new
#   end
#
#   def test_cycle_on_then_off
#     # @house.cycle_on_and_off
#   end
#
#   def test_light_names_returns_names_we_know
#     names = [
#       "Living Room Book Corner",
#       "Book Shelf Orb",
#       "Living Room Plant Corner",
#       "Plant Shelf Orb",
#       "Bathroom",
#       "Richard Mosse",
#       "Love Room 2",
#       "Love Room 1",
#       "Kitchen"
#     ]
#
#     assert_equal @house.light_names, names
#   end
#
#   def test_has_living_room_lights
#     assert_equal @house.living_room.count, 6
#   end
#
#   def test_house_has_access_to_client
#     assert_equal @house.client.class, Hue::Client
#   end
#
#   def test_begins_house_has_access_to_all_lights
#     assert_equal @house.lights.count, 9
#   end
#
#   def test_setup
#     assert true
#   end
# end
