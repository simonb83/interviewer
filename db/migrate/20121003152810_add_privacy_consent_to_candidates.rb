class AddPrivacyConsentToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :privacy_consent, :boolean

  end
end
