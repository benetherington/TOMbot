module Music
  extend Discordrb::Commands::CommandContainer

  command(:music, permission_level: 1, help_availble: false) do |event, track|
    event.voice.length_override = 18

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

  command(:volume) do |event, volume|
    event.voice.volume = volume
  end

  command(:crescendo) do |event|
    for level in 1..10
      event.voice.volume = level/10
      puts level
      sleep(0.3)
    end
  end

  command(:stop, help_availble: false) do |event|
    event.voice.stop_playing
  end

end
puts "------ Loaded Music module"