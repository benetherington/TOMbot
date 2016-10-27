module AudienceToys
  extend Discordrb::EventContainer
  extend Discordrb::Commands::CommandContainer
  
  if @store = YAML::Store.new('/Users/admin/Documents/TOM/Discord bot/store.yml')
    puts "------ Loaded YAML store"
  else
    puts "-=-=-= YAML store load failed!!!"
  end
  levels = [ 1000, 3000, 10000, 20000, 50000, 100000 ]



  command(:spx, bucket: :mentions, description: 'Increments the SpaceX mention counter for this episode, with a 30 second cooldown. Admins can include a number to force-set the counter.') do |event, reset|

    if reset.nil? # was a reset value specified? If not, increment.
      increment_transaction 'spacex_counter', 1
    else          # If so, reset.
      break unless event.user.id == 137947564317081600
      set_transaction 'spacex_counter', reset.to_i
    end
    
    case get_transaction 'spacex_counter'
    when 0
      event.respond 'Resetting to zero.'
    when 1
      event.respond 'That\'s the first mention of SpaceX!'
    else
      event.respond get_transaction('spacex_counter').humanize.capitalize + ' mentions of SpaceX so far.'
    end
  end



  # TODO: set up initializing condition
  command(:quote, description: 'Serves a random quote. Call with text to save a new quote.') do |event, *args|
    unless args.empty?
      quote = args.join(' ')
      @store.transaction {@store['quotes'] << quote; @store.commit}
      event.respond "There are now " + @store.transaction {@store['quotes'].count}.humanize + " quotes stored."
    else
      event.respond get_transaction('quotes').sample
    end
  end

  message(description: 'It\'s a gameification of the normal chatting you do!') do |event|
    if get_nested_transaction( 'altitude', event.user.id )
      increment_nested_transaction 'altitude', event.user.id, 15
    else
      set_transaction ['altitude'][event.user.id], 15+rand(10) # because remember you can't increment 0.
    end
  end

  command(:altitude, description: 'Check a user\'s score in the chat level-up game. Leave blank to check your own score.' ) do |event|
    if get_nested_transaction('altitude', event.user.id)
      current_level = levels.count { |level| get_nested_transaction('altitude', event.user.id) > level }
      if current_level > 0
        event.respond 'You\'re at **' + current_level.to_s + ',000 km**.'
      else
        event.respond 'You\'re still on the ground, young aviator.'
      end
    end
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
puts "------ Loaded AudienceToys module"






