module VolunteerHelper
  def listing_path (year, month)
    "/volunteer/listing/archives/#{year}/#{month}"
  end
  def listing_path_from_time(t)
    listing_path(t.strftime('%Y'),t.strftime('%m'))
  end
  def active_listing_path
    "/volunteer/listing/active"
  end
  
def explainsignup(i)
  if i.blank?
    "You haven't signed up for this event yet."
  else
    case i.status
    when nil
      "You haven't signed up for this event yet."
    when "WAITLIST"
      "You have signed up and are on the waiting list for this event. The chairpeople only need a limited number of volunteers, so they will choose a small number of volunteers from the waiting list. If you are still on the waiting list at the time of the event, do not come. You will get a call from the chairperson if you are chosen."
    when "VOLUNTEER"
      "You are registered as a volunteer for this event. You are expected to come. If you cannot make it, try cancelling your signup. If you cannot cancel it, contact a chairperson immediately."
    when "ABSENT"
      "You were registered as a volunteer, but you did not show up. A chairperson has therefore marked you absent. If this is incorrect, contact a chairperson immediately."
    when "DENIED"
      "You were on the waiting list for this event, but you were not chosen as a volunteer."
    when "COMPLETE"
      "You were registered as a volunteer, and you completed this event."
    else
      ""
    end
  end
end
end