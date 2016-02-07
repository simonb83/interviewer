class MessageRecipient < ActiveRecord::Base

  belongs_to :message
  belongs_to :recruiter

  attr_accessible :recruiter_id, :email, :message_id

end
