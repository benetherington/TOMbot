module CrewTools
  extend Discordrb::Commands::CommandContainer

  if @store = YAML::Store.new('/Users/admin/Documents/TOM/Discord bot/store.yml')
    puts "------ Loaded YAML store to CrewTools"
  else
    puts "-=-=-= YAML store load to CrewTools failed!!!"
  end


  command(:send_start_tweet, help_available:false, permission_level:1) do |event, episode, *args|
    time = args.join(' ')
    if time.nil?
      client.update('We\'re about to start recording episode ' + episode + '! Come join us on Discord. https://www.patreon.com/posts/4374670')
      event.respond 'Okay, I just tweeted. Feel free to start whenever!'
    else
      client.update('We\'re going to start recording episode ' + episode + ' in ' + time + '! Come join us on Discord. https://www.patreon.com/posts/4374670')
      event.respond 'Okay, I just tweeted that you\'re going to start in ' + time + '.'
    end
  end

  command(:goodbye_everyone, permission_level: 1, help_available: false) do |event|
    event.respond 'That\'s the show for this week! Thanks for listening!'

    if get_transaction('spacex_counter') < 1
      event.respond '🎉There were no mentions of SpaceX!🎉'
      increment_transaction('spacex_meta_counter', 1)
    elsif get_transaction('spacex_counter') == 1
      event.respond 'There was **one** mention of SpaceX this week.'
      set_transaction 'spacex_meta_counter', 0
    else
      event.respond 'There were **' + get_transaction('spacex_counter').humanize + '** mentions of SpaceX this week.'
      set_transaction 'spacex_meta_counter', 0
    end

    if get_transaction('spacex_meta_counter') == 1
      event.respond 'It\'s been **one** show since the last SpaceX mention incident.'
    else
      event.respond 'It\'s been **' + get_transaction('spacex_meta_counter').humanize + '** shows since the last SpaceX mention incident.'
    end

    set_transaction 'spacex_counter', 0 #reset for next show

    #TODO: disconnect from channel.
    exit
  end

private

  def self.get_transaction(key)
    @store.transaction { @store[key] }
  end

  def self.get_nested_transaction(key, sub)
    @store.transaction { @store[key][sub] }
  end

  def self.set_transaction(key, value)
    @store.transaction { @store[key] = value; @store.commit }
  end

  def self.set_nested_transaction(key, sub, value)
    @store.transaction { @store[key][sub] = value }
  end

  def self.increment_transaction(key, value)
    @store.transaction { @store[key] += value; @store.commit }
  end

  def self.increment_nested_transaction(key, sub, value)
    @store.transaction { @store[key][sub] += value; @store.commit }
  end

end
puts "------ Loaded CrewTools module"


