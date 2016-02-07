class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  MODELS = %W(Campaign Candidate Answer Recruiter Organization Account OrganizationAccount)

  def self.send_test_email
    @sender = Recruiter.first
    @candidate = Candidate.last
    RecruiterNotifier.shared_external(@sender,"email",@candidate).deliver
  end

end
