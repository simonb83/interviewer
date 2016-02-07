class Category < ActiveRecord::Base

  #Categories have many questions
  has_many :questions

  attr_accessible :name

end
