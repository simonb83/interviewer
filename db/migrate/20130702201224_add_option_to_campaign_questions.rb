class AddOptionToCampaignQuestions < ActiveRecord::Migration
  def change
    add_column :campaign_questions, :option, :boolean
  end
end
