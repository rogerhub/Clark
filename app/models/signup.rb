class Signup < ActiveRecord::Base
  belongs_to :account
  belongs_to :event
  def pointdifficulty
    "#{pointvalue} #{event.difficulty.capitalize()}"
  end
end
