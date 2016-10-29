module Utilities
  extend Discordrb::EventContainer
  extend Discordrb::Commands::CommandContainer


  message(content: 'Ping!', description: 'Tests if the bot\'s awake') do |event|
    event << 'Pong!'
  end

  command(:join, permission_level: 1, help_available: false) do |event, invite|
    event.bot.join invite
    nil
  end

  command(:connect, permission_level: 1, help_availble: false) do |event|
    channel = event.user.voice_channel
    next "You're not in any voice channel!" unless channel
    event.bot.voice_connect(channel)
    puts "------ Joined #{channel.name}!"
    nil
  end

  command([:about, :info], description: 'Get more info about TOMbot.') do |event|
    event << 'Author: <@137947564317081600>'
    event << 'ben@theorbitalmechanics.com'
    event << 'http://github.com/benetherington'
    event << 'Big thanks to Meew0 for writing https://github.com/meew0/discordrb.'
    event << 'Thanks to PoVa for code examples. https://github.com/PoVa/sapphire_bot'
    event << 'Type `!help` for more commands.'
  end

end

puts "------ Loaded Utilities module"