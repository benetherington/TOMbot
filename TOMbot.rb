require 'discordrb'
require 'opus-ruby'
# require 'twitter'
require 'configatron'
require_relative 'config.rb'
require 'yaml/store'
require 'humanize'

# client = Twitter::REST::Client.new do |config|
#   config.consumer_key        = 'EgFJvD2TP1iBF8sRQdIDoX79D'
#   config.consumer_secret     = configatron.twitter_consumer_secret
#   config.access_token        = '2827032970-yz422D4giYmhx8VNnOwlAcivH8vFuGN2p8ZLUxa'
#   config.access_token_secret = configatron.twitter_access_secret
# end

bot = Discordrb::Commands::CommandBot.new token: configatron.discord_token, client_id: 240239741784686592, prefix: '!'
puts "------ This bot's invite URL is #{bot.invite_url}." # Make inviting the bot easy
if store = YAML::Store.new('/Users/admin/Documents/TOM/Discord bot/store.yml')
  puts "------ Loaded YAML store"
else
  puts "-=-=-= YAML store load failed!!!"
end
bot.set_user_permission(137947564317081600, 1)

bot.message(content: 'Ping!', description: 'Tests if the bot\'s awake') do |event|
  event.respond 'Pong!'
  store.transaction do
    store['tennis'] += 1
    store.commit
  end
end

bot.command(:join, permission_level: 1, description: 'Admins can invite the bot to text channels. Takes an invite URL as an argument.') do |event, invite|
  event.bot.join invite
  nil
end

bot.command(:connect, description: 'Admins can invite the bot to the voice channel they\'re in.') do |event|
  channel = event.user.voice_channel
  next "You're not in any voice channel!" unless channel
  bot.voice_connect(channel)
  puts "------ Joined #{channel.name}!"
  nil
end

bot.command(:music, permission_level: 1, description: 'Admins can play music. Takes a track name (intro, questions, outro, stop) as an argument.') do |event, track|
  voicebot = event.voice
  voicebot.length_override = 18

  case track
  when 'intro'
    voicebot.play_file('//Users/admin/Documents/TOM/Discord bot/Discord Music/Intro - Piano Wire.mp3')
  when 'questions'
    voicebot.play_file('//Users/admin/Documents/TOM/Discord bot/Discord Music/Qs Cs and CBs - Fifteen Fifty.mp3')
  when 'outro'
    voicebot.play_file('//Users/admin/Documents/TOM/Discord bot/Discord Music/Outro - Piano Wire.mp3')
  when 'stop'
    event.voice.stop_playing
  else
    "Huh?"
  end
end

bot.command(:stop, description: 'Admins can stop playing music.') do |event|
  event.voice.stop_playing
end


bot.bucket(:mentions, limit: 1, time_span: 30)
bot.command(:spx, bucket: :mentions, description: 'Increments the SpaceX mention counter for this episode. Admins can include a number to force-set the counter.') do |event, reset|
  message = String.new
  if reset.nil?
    break unless event.user.id == 137947564317081600
    store.transaction { store['spacex_counter'] += 1; message = store['spacex_counter']; store.commit }
  else
    store.transaction { store['spacex_counter'] = reset.to_i; message = store['spacex_counter']; store.commit }
  end
  event.respond message.humanize.capitalize + ' mentions of SpaceX so far.'
end


bot.run






