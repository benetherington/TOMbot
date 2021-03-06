require 'discordrb'
require 'opus-ruby'
require 'twitter'
require 'configatron'
require 'yaml/store'
require 'humanize'

require_relative 'config.rb'
require_relative 'utilities.rb'
require_relative 'crewtools.rb'
require_relative 'audiencetoys.rb'
require_relative 'music.rb'
# require_relative 'trial.rb'

# Save the correct values for when I'm done testing the Twitter API.
# client = Twitter::REST::Client.new do |config|
#   config.consumer_key        = '1Uj4GwPHJNtrTtOoEaXpNRNDm'
#   config.consumer_secret     = configatron.twitter_consumer_secret
#   config.access_token        = '2827032970-yz422D4giYmhx8VNnOwlAcivH8vFuGN2p8ZLUxa'
#   config.access_token_secret = configatron.twitter_access_secret
# end

bot = Discordrb::Commands::CommandBot.new token: configatron.discord_token, client_id: 240239741784686592, prefix: '!'
puts "------ This bot's invite URL is #{bot.invite_url}." # Make inviting the bot easy
# if        client = Twitter::REST::Client.new do |config|
#           config.consumer_key        = 'FDM3jP4rWgAwUF1B4rjXMPXMr'
#           config.consumer_secret     = configatron.twitter_consumer_secret
#           config.access_token        = '791036085048528896-9s3L7qOaCuNP5oso7vNIJJRW4cPouQW'
#           config.access_token_secret = configatron.twitter_access_secret
#           end
#   puts "------ Authenticated Twitter" + client.current_user.name
# else
#   puts "-=-=-= Twitter authentication failed!!!"
# end


bot.set_role_permission(137953295498084363, 1) # set TOMcrew to permission 1.
$rate_limiter = Discordrb::Commands::SimpleRateLimiter.new # TODO: break scope and make this not global!
$rate_limiter.bucket :altitude_game, delay: 60


bot.include! Utilities
bot.include! CrewTools
bot.include! AudienceToys
bot.include! Music
# bot.include! Trial

bot.run



