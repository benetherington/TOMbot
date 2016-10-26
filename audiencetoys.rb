module AudienceToys
  extend Discordrb::EventContainer
  extend Discordrb::Commands::CommandContainer
  
  if store = YAML::Store.new('/Users/admin/Documents/TOM/Discord bot/store.yml')
    puts "------ Loaded YAML store"
  else
    puts "-=-=-= YAML store load failed!!!"
  end
  levels = [ 1000, 3000, 10000, 20000, 50000, 100000 ]

  command(:spx, bucket: :mentions, description: 'Increments the SpaceX mention counter for this episode, with a 30 second cooldown. Admins can include a number to force-set the counter.') do |event, reset|

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

  # TODO: set up initializing condition
  command(:quote, description: 'Serves a random quote. Call with text to save a new quote.') do |event, *args|
    unless args.empty?
      quote = args.join(' ')
      store.transaction {store['quotes'] << quote; store.commit}
      event.respond "There are now " + store.transaction {store['quotes'].count}.humanize + " quotes stored."
    else
      event.respond store.transaction {store['quotes'].sample}
    end
  end

  message(description: 'It\'s a gameification of the normal chatting you do!') do |event|
    if store.transaction { store['altitude'][event.user.id] }
      store.transaction { store['altitude'][event.user.id] += 15+rand(10); store.commit }
    else
      store.transaction { store['altitude'][event.user.id] = 15+rand(10); store.commit } # because remember you can't increment 0.
    end
  end

  command(:altitude, description: 'Check a user\'s score in the chat level-up game. Leave blank to check your own score.' ) do |event|

    if store.transaction { store['altitude'][event.user.id] }
      current_level = levels.count { |level| store.transaction {store['altitude'][event.user.id]} > level }
      if current_level > 0
        event.respond 'You\'re at **' + current_level.to_s + ',000 km**.'
      else
        event.respond 'You\'re still on the ground, young aviator.'
      end
    end
  end

end