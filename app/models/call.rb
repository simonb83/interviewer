class Call < ActiveRecord::Base

  belongs_to :candidate

  validates_uniqueness_of :sid

  attr_accessible :sid, :status, :question_id

end
