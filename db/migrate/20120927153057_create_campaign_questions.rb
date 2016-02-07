class CreateCampaignQuestions < ActiveRecord::Migration
  def change
    create_table :campaign_questions do |t|
      t.integer :campaign_id
      t.integer :question_id

      t.timestamps
    end
    add_index :campaign_questions, :campaign_id
    add_index :campaign_questions, :question_id
  end
end
