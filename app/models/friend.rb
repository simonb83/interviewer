class Friend < ActiveRecord::Base

  belongs_to :candidate

  attr_accessible :email, :candidate_id

end
