require 'discordrb'
require 'opus-ruby'
# require 'twitter'
require 'configatron'
require_relative 'config.rb'

# client = Twitter::REST::Client.new do |config|
#   config.consumer_key        = 'EgFJvD2TP1iBF8sRQdIDoX79D'
#   config.consumer_secret     = configatron.twitter_consumer_secret
#   config.access_token        = '2827032970-yz422D4giYmhx8VNnOwlAcivH8vFuGN2p8ZLUxa'
#   config.access_token_secret = configatron.twitter_access_secret
# end

bot = Discordrb::Commands::CommandBot.new token: configatron.discord_token, client_id: 240239741784686592, prefix: '!'
puts "This bot's invite URL is #{bot.invite_url}." # make invites easy
bot.set_user_permission(137947564317081600, 1)

bot.message(content: 'Ping!') do |event|           # make online testing easy
  event.respond 'Pong!'
end

bot.command(:join, permission_level: 1, chain_usable: false) do |event, invite|
  event.bot.join invite
  nil
end

bot.command(:connect) do |event|
  channel = event.user.voice_channel
  next "You're not in any voice channel!" unless channel
  puts "joining #{channel.name}"
  bot.voice_connect(channel)
  nil
end

bot.command :intro do |event|
  voicebot = event.voice
  # voicebot.adjust_average = true
  # voicebot.adjust_offset = 10
  # voicebot.adjust_interval = 10
  voicebot.length_override = 18

  voicebot.play_file('//Users/admin/Documents/TOM/Discord bot/Discord Music/Intro - Piano Wire.mp3')
  # voicebot.play_io(open('https://static1.squarespace.com/static/5439a3d0e4b0dedc218f23b9/57f13835cd0f681fb4a20065/5803a4e4f5e23180413196a5/1476633849199/Intro+-+Piano+Wire.mp3'))
end

bot.command :questions do |event|
  voicebot = event.voice
  voicebot.length_override = 18
  voicebot.play_file('//Users/admin/Documents/TOM/Discord bot/Discord Music/Qs Cs and CBs - Fifteen Fifty.mp3')
end

bot.command :outro do |event|
  voicebot = event.voice
  voicebot.length_override = 18
  voicebot.play_file('//Users/admin/Documents/TOM/Discord bot/Discord Music/Outro - Piano Wire.mp3')
end

bot.command :stop do |event|
  event.voice.stop_playing
end

bot.run