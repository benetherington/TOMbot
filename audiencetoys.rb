module AudienceToys
  extend Discordrb::EventContainer
  extend Discordrb::Commands::CommandContainer
  
  if @store = YAML::Store.new('/Users/admin/Documents/TOM/Discord bot/store.yml')
    puts "------ Loaded YAML store to AudienceToys"
  else
    puts "-=-=-= YAML store load to AudienceToys failed!!!"
  end
  

  @levels = [155, 220, 295, 380, 475, 580, 695, 820, 955, 1100, 1255, 1420, 1595, 1780, 1975, 2180, 2395, 2620, 2855, 3100, 3355, 3620, 3895, 4180, 4475, 4780, 5095, 5420, 5755, 6100, 6455, 6820, 7195, 7580, 7975, 8380, 8795, 9220, 9655, 10100, 10555, 11020, 11495, 11980, 12475, 12980, 13495, 14020, 14555, 15100, 15655, 16220, 16795, 17380, 17975, 18580, 19195, 19820, 20455, 21100, 21755, 22420, 23095, 23780, 24475, 25180, 25895, 26620, 27355, 28100, 28855, 29620, 30395, 31180, 31975, 32780, 33595, 34420, 35255, 36100, 36955, 37820, 38695, 39580, 40475, 41380, 42295, 43220, 44155, 45100, 46055, 47020, 47995, 48980, 49975, 50980, 51995, 53020, 54055]
  # 5*(n**2)+50*n+100

rate_limiter = Discordrb::Commands::SimpleRateLimiter.new
rate_limiter.bucket :mentions, delay: 30 


  command(:spx, description: 'Increments the SpaceX mention counter for this episode, with a 30 second cooldown. Admins can include a number to force-set the counter.') do |event, reset|

    if reset.nil? # was a reset value specified? If not, increment.
      break if rate_limiter.rate_limited?(:mentions, event.channel)
      increment_transaction 'spacex_counter', 1
      announce_mentions(event)
    else          # If so, reset.
      break unless event.user.id == 137947564317081600
      set_transaction 'spacex_counter', reset.to_i
      announce_mentions(event)
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

  command(:title, description: 'Naming episodes is hard. Suggest them as we go along, and I\'ll summarize at the end of the show!') do |event, *args|
    
    if get_transaction('titles') == nil
      set_transaction 'titles', []
    end

    unless args.empty?
      suggestion = args.join(' ')
      suggestion.prepend('**' + event.user.name + "** suggested: ")
      append_array_transaction 'titles', suggestion
    else
      if get_transaction('titles').length = 1
        event.respond '**One** title suggestion so far.'
      else
        event.respond '**' + get_transaction('titles').length.humanize.capitalize + '** title suggestions so far.'
    end
  end


  message(bucket: :altitude_game) do |event| #user leveling game
    new_xp = 15+rand(10)

    if check_for_level_up(event.user.id, new_xp) && not_tom_crew?(event)
      event.respond 'You just hit an altitude of **' + (current_level(event.user.id) + 1).to_s + ',000 km!**'
    end

    award_xp(event.user.id, new_xp)
  end

  command(:altitude, description: 'You gain random XP for every minute you\'re active in the chat. Use this command to check your current level.' ) do |event|
    if get_nested_transaction('altitude', event.user.id)
      if current_level(event.user.id) > 0
        event.respond 'You\'re at **' + current_level(event.user.id).to_s + ',000 km**.'
      else
        event.respond 'You\'re still on the ground, young aviator.'
      end
    end
  end




private

  def self.current_level(user)
    @levels.count { |level| get_nested_transaction('altitude', user) > level }
  end

  def self.award_xp(user, xp)
    if get_nested_transaction( 'altitude', user )
      increment_nested_transaction( 'altitude', user, xp )
    else
      set_nested_transaction('altitude', user, xp) # because remember you can't increment 0.
    end
  end

  def self.check_for_level_up(user, xp)
    if @levels.count { |level| get_nested_transaction('altitude', user) > level } != @levels.count { |level| get_nested_transaction('altitude', user)+xp > level }
      return true
    else
      return false
    end
  end

  def self.announce_mentions(event)
    case get_transaction 'spacex_counter'
    when 0
      event.respond 'Resetting to zero.'
    when 1
      event.respond 'That\'s the first mention of SpaceX!'
    else
      event.respond get_transaction('spacex_counter').humanize.capitalize + ' mentions of SpaceX so far.'
    end
  end

  def self.not_tom_crew?(event)
    !event.user.roles.include? event.server.role(137953295498084363)
  end



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

  def self.append_array_transaction(key, value)
    @store.transaction { @store[key] << value; @store.commit }
  end

  def self.increment_transaction(key, value)
    @store.transaction { @store[key] += value; @store.commit }
  end

    def self.increment_nested_transaction(key, sub, value)
    @store.transaction { @store[key][sub] += value; @store.commit }
  end


end
puts "------ Loaded AudienceToys module"




