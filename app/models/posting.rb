class Posting < ActiveRecord::Base
  belongs_to :event
  belongs_to :account
  
  before_destroy{|pos| Posting.destroy_all(:reply_to => pos.id)}
end
