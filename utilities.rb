store = YAML::Store.new('/Users/admin/Documents/TOM/Discord bot/store.yml')

module Utilities
  extend Discordrb::EventContainer
  extend Discordrb::Commands::CommandContainer


  message(content: 'Ping!', description: 'Tests if the bot\'s awake') do |event|
    event.respond 'Pong!'
    store.transaction { store['tennis'] += 1; store.commit }
  end

  command(:join, permission_level: 1, help_available: false) do |event, invite|
    event.bot.join invite
    nil
  end

  command(:connect, help_available: false) do |event|
    channel = event.user.voice_channel
    next "You're not in any voice channel!" unless channel
    bot.voice_connect(channel)
    puts "------ Joined #{channel.name}!"
    nil
  end
end