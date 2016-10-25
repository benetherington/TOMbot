require 'discordrb'
require 'opus-ruby'
require 'twitter'
require 'configatron'
require_relative 'config.rb'
require 'yaml/store'
require 'humanize'

# Save the correct values for when I'm done testing the Twitter API.
# client = Twitter::REST::Client.new do |config|
#   config.consumer_key        = 'EgFJvD2TP1iBF8sRQdIDoX79D'
#   config.consumer_secret     = configatron.twitter_consumer_secret
#   config.access_token        = '2827032970-yz422D4giYmhx8VNnOwlAcivH8vFuGN2p8ZLUxa'
#   config.access_token_secret = configatron.twitter_access_secret
# end

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = 'FDM3jP4rWgAwUF1B4rjXMPXMr'
  config.consumer_secret     = configatron.twitter_consumer_secret
  config.access_token        = '791036085048528896-9s3L7qOaCuNP5oso7vNIJJRW4cPouQW'
  config.access_token_secret = configatron.twitter_access_secret
end

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
  store.transaction { store['tennis'] += 1; store.commit }
end

bot.command(:join, permission_level: 1, help_available: false) do |event, invite|
  event.bot.join invite
  nil
end

bot.command(:connect, help_available: false) do |event|
  channel = event.user.voice_channel
  next "You're not in any voice channel!" unless channel
  bot.voice_connect(channel)
  puts "------ Joined #{channel.name}!"
  nil
end

bot.command(:send_start_tweet, help_available:false, permission_level:1) do |event, episode, minutes|
  if time.nil?
    client.update('We\'re about to start recording episode ' + episode + '! Come join us on Discord. https://www.patreon.com/posts/4374670')
    event.respond 'Okay, I just tweeted. Feel free to start whenever!'
  else
    client.update('We\'re going to start recording episode ' + episode + ' in ' + minutes + ' minutes! Come join us on Discord. https://www.patreon.com/posts/4374670')
    event.respond 'Okay, I just tweeted that you\'re going to start in ' + minutes + ' minutes.'
  end
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
bot.command(:spx, bucket: :mentions, description: 'Increments the SpaceX mention counter for this episode, with a 30 second cooldown. Admins can include a number to force-set the counter.') do |event, reset|

  if reset.nil? # was a reset value specified? If not, increment.
    store.transaction { store['spacex_counter'] += 1; store.commit }
  else
    break unless event.user.id == 137947564317081600
    store.transaction { store['spacex_counter'] = reset.to_i; store.commit }
  end
  
  case store.transaction {store['spacex_counter']}
  when 0
    event.respond 'Resetting to zero.'
  when 1
    event.respond 'That\'s the first mention of SpaceX!'
  else
    event.respond store.transaction {store['spacex_counter']}.humanize.capitalize + ' mentions of SpaceX so far.'
  end
end

bot.command(:goodbye_everyone, permission_level: 1, help_available: false) do |event|
  event.respond 'That\'s the show for this week! Thanks for listening!'

  if store.transaction {store['spacex_counter']} < 1
    event.respond '🎉There were no mentions of SpaceX!🎉'
    store.transaction { store['spacex_meta_counter'] += 1; store.commit }
  elsif store.transaction {store['spacex_counter']} == 1
    event.respond 'There was **one** mention of SpaceX this week.'
    store.transaction { store['spacex_meta_counter'] = 0; store.commit }
  else
    event.respond 'There were **' + store.transaction {store['spacex_counter']}.humanize + '** mentions of SpaceX this week.'
    store.transaction { store['spacex_meta_counter'] = 0; store.commit }
  end

  if store.transaction {store['spacex_meta_counter']} == 1
    event.respond 'It\'s been **one** show since the last SpaceX mention incident.'
  else
    event.respond 'It\'s been **' + store.transaction {store['spacex_meta_counter']}.humanize + '** shows since the last SpaceX mention incident.'
  end

  store.transaction { store['spacex_counter'] = 0; store.commit }

  exit
end

bot.run






