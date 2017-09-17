require 'models/valve'

class ValveButtons < Hyperloop::Component

  # see comments in SprinkleList about doing this... its not necessary
  # and will probably confuse things.  Hyperloop is keeping a cache of
  # things like Valve.all, so don't bother trying to save the value yourself.

  # before_mount do
  #   # @valves = Valve.all
  # end

  def render
    #@valves ||= Valve.all
    UL(class: 'nav navbar-nav navbar-right') do
      Valve.all.each do |valve|
        # rather than pass the id, and then lookup the valve from the id,
        # just pass the valve itself.  Hyperloop can optimize better this way
        ValveButton(valve: valve)
      end
    end
  end
end
