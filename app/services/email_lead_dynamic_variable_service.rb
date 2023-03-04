# frozen_string_literal: true

class EmailLeadDynamicVariableService

  def next_two_working_days
    current_day = Date.current + 1
    
    if current_day.saturday?
      next_day = current_day + 2
      second_day = current_day + 3
    elsif current_day.sunday?
      next_day = current_day + 1
      second_day = current_day + 2
    elsif current_day.friday?
      next_day = current_day + 3
      second_day = current_day + 4
    else
      next_day = current_day + 1
      second_day = current_day + 2
    end
    [next_day.strftime("%A"), second_day.strftime("%A")].join(' or ')
  end
end  