require 'spec_helper'

describe ReferencesController do

  describe "POST add references" do

    it "creates references with associated name" do
      candidate = create(:candidate)
      post :add_references, candidate_id: candidate.id, "reference_1_name" => "String1", "reference_2_name" => "String2", "reference_1_email" => "Email1", "reference_2_email" => "Email2", "reference_1_relationship" => "Relationship1", "reference_2_relationship" => "Relationship2"
      candidate.references.count.should == 2
      candidate.references.first.name.should == "String1"
      candidate.references.last.name.should == "String2"
    end

    it "creates references with associated email" do
      candidate = create(:candidate)
      post :add_references, candidate_id: candidate.id, "reference_1_name" => "String1", "reference_2_name" => "String2", "reference_1_email" => "Email1", "reference_2_email" => "Email2", "reference_1_relationship" => "Relationship1", "reference_2_relationship" => "Relationship2"
      candidate.references.count.should == 2
      candidate.references.first.email.should == "Email1"
      candidate.references.last.email.should == "Email2"
    end

    it "creates references with associated relationship" do
      candidate = create(:candidate)
      post :add_references, candidate_id: candidate.id, "reference_1_name" => "String1", "reference_2_name" => "String2", "reference_1_email" => "Email1", "reference_2_email" => "Email2", "reference_1_relationship" => "Relationship1", "reference_2_relationship" => "Relationship2"
      candidate.references.count.should == 2
      candidate.references.first.relationship.should == "Relationship1"
      candidate.references.last.relationship.should == "Relationship2"
    end

    it "redirects to next stage path if references are successfully created" do
      candidate = create(:candidate)
      post :add_references, candidate_id: candidate.id, "reference_1_name" => "String1", "reference_2_name" => "String2", "reference_1_email" => "Email1", "reference_2_email" => "Email2", "reference_1_relationship" => "Relationship1", "reference_2_relationship" => "Relationship2"
      response.should redirect_to(candidate_next_stage_path(candidate))
    end

    it "redirects back to enter references page if there is an error" do
      candidate = create(:candidate)
      post :add_references, candidate_id: candidate.id, "reference_1_name" => "String1", "reference_1_email" => "Email1", "reference_1_relationship" => ""
      response.should render_template(:provide_references)
    end

    it "provides appropriate flash error message if a field is blank" do
      candidate = create(:candidate)
      post :add_references, candidate_id: candidate.id, "reference_1_name" => "String1", "reference_1_email" => "Email1", "reference_1_relationship" => ""
      flash[:notice].should == "Por favor llena todos los campos antes de proceder."
    end
  end

end
