require 'models/sprinkle'

class SprinkleList < Hyperloop::Component

  # suggest not to be saving away stuff in instance variables
  # during mount.  Its not necessary.  Hyperloop is tracking all that
  # if you do repeated calls to Sprinkle.all, it has cached the value
  # from the first time.

  # after_mount do
  #   ReactiveRecord.load do
  #     # go get whatever data you want
  #     Sprinkle.each do |row|
  #       row.data
  #     end
  #   end.then do
  #     try_sort
  #   end
  # end

  render(DIV) do
    H4 { "Sprinkles"}

    TABLE(class: 'table') do
      THEAD do
        TR do
          TH { " Next Start Time " }
          TH { " Time input " }
          TH { " Duration" }
          TH { " Valve " }
        end
      end
      #try_sort  (see notes below)
      TBODY do
        Sprinkle.all.each do |sprinkle|
          SprinkleRow(sprinkle: sprinkle)
        end
        #mark_next  (see notes below)
      end
    end
  end


    # sorry but this is just going to be a bad idea... never use rendering
    # to cause state to change.
    # All this logic belongs either in the models (as lifecycle callbacks) or
    # in operations.  In otherwords its the model + operations job to keep things
    # consistent, not the UI.

    # And remember, as the data changes in the database hyperloop will keep things
    # updated, so there is no reason for the component to worry about this :-)

  # Sprinkle states
  IDLE = 0
  NEXT = 1
  ACTIVE = 2


  def mark_next
    # Set the status of the first sprinkle in the list to 'Next'
    s = Sprinkle.first #@sprinkles[0]
    if s.state != ACTIVE
      s.state = NEXT
      s.save
    end
  end

  # like mark_next, you want this to be managed by active record...
  # for now I just made a default sort order in the Sprinkle model, but
  # you may have something more complicated.

  # Keep in mind hyperloop is going to keep the data synced, so if for some reason
  # a new sprinkle is inserted, or the next_start_time changes this will automatically
  # cause the data to get re-sorted and redisplayed.

  def try_sort
    # Sort the table if the first element next_start_time has changed
    if false && @next_start_time != @sprinkles[0].next_start_time
      @sprinkles.sort_by! {|s| s.next_start_time}
      @next_start_time = @sprinkles[0].next_start_time
    end
  end

end
