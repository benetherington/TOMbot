require 'discordrb'
require 'twitter'
require 'configatron'
require_relative 'config.rb'


bot = Discordrb::Bot.new token: configatron.discord_token, client_id: 240239741784686592

# client = Twitter::REST::Client.new do |config|
#   config.consumer_key        = 'EgFJvD2TP1iBF8sRQdIDoX79D'
#   config.consumer_secret     = configatron.twitter_consumer_secret
#   config.access_token        = '2827032970-yz422D4giYmhx8VNnOwlAcivH8vFuGN2p8ZLUxa'
#   config.access_token_secret = configatron.twitter_access_secret
# end


puts "This bot's invite URL is #{bot.invite_url}." # make invites easy

bot.message(content: 'Ping!') do |event|           # make online testing easy
  event.respond 'Pong!'
end




bot.run