module Music
  extend Discordrb::Commands::CommandContainer

  command(:music, permission_level: 1, help_availble: false) do |event, track|
    next unless connect_to_voice_channel(event) # skip everything unless we're successfully connected to a voice channel

    event.voice.length_override = 17
    case track
    when 'intro'
      event.voice.play_file('//Users/admin/Documents/TOM/Discord bot/Discord Music/Intro - Piano Wire.mp3')
    when 'questions'
      event.voice.play_file('//Users/admin/Documents/TOM/Discord bot/Discord Music/Qs Cs and CBs - Fifteen Fifty.mp3')
    when 'outro'
      event.voice.play_file('//Users/admin/Documents/TOM/Discord bot/Discord Music/Outro - Piano Wire.mp3')
    when 'stop'
      event.voice.stop_playing
    else
      "Huh?"
    end
  end

  command(:volume, permission_level: 1, help_availble: false) do |event, volume|
    event.voice.volume = volume
  end

  # command(:crescendo) do |event|
  #   for level in 1..10
  #     event.voice.volume = level/10
  #     puts level
  #     sleep(0.3 )
  #   end
  # end

  command(:stop, permission_level: 1, help_availble: false) do |event|
    event.voice.stop_playing
  end


private

  def self.connect_to_voice_channel(event) # Check if connected, then attempt to connect to a voice channel
    if event.voice
      return true
    else
      if channel = event.user.voice_channel
        event.bot.voice_connect(channel)
        puts "------ Joined #{channel.name}!"
        return true
      else
        event << "You're not in any voice channel!"
        return false
      end
    end
  end



end
puts "------ Loaded Music module"






