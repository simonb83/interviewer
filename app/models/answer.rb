class Answer < ActiveRecord::Base

  belongs_to :candidate
  has_many :question_answers, dependent: :destroy
  has_many :questions, through: :question_answers
  validates :question_id, :uniqueness => { scope: :candidate_id }

  attr_accessible :content, :candidate_id, :question_id

  include AdminTools

  #Twilio credentials
  # ACCOUNT_SID = 'AC7a723d6b4059e985789f56fed1d23f6c'
  # AUTH_TOKEN = 'a28608f737e1ecd87d6551e86715ac81'

  def mp3_url
    url = self.content
    url.gsub!("http","https") unless url.match(/https:\/\//)
    url+".mp3"
  end

end
