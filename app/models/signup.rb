class Signup < ActiveRecord::Base
  belongs_to :account
  belongs_to :event
  def pointdifficulty
    "#{pointvalue} #{difficulty.capitalize()}"
  end
end
