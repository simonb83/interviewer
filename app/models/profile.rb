class Profile < ActiveRecord::Base

  attr_accessible :desired_salary, :dob, :estado_civil, :gender, :name, :surname_maternal, :surname_paternal

  validates_presence_of :desired_salary, :dob, :estado_civil, :gender, :name, :surname_paternal

  def to_s
  	"#{name} #{surname_paternal} #{surname_maternal}"
  end
end
