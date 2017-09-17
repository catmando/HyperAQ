require 'models/valve'

class ValveButton < Hyperloop::Component
  param :valve

  def render
    LI do
      BUTTON(class: "btn #{state(params.valve)} navbar-btn") do
        params.valve.name
      end.on(:click) { command(params.valve.id) }
    end
  end

  def command(valve_id)
    # signal the ServerOp to toggle the valve, and create a History (List)
    ManualValveServer.run(valve_id: valve_id)
    # HistoryList.render()
  end

  def state(valve)
    valve.cmd == 0 ? "btn-primary" : 'btn-success'
  end

  # FYI this is a stylistic preference, but you could skip passing the valve around
  # as its part of the ValveButton's instance data.  In otherwords:

  def valve_state
    params.valve.cmd == 0 ? 'btn-primary' : 'btn-success'
  end

  # same with command too

end
