module CrewTools
  extend Discordrb::Commands::CommandContainer


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


end
puts "------ Loaded CrewTools module"


