class ReferencesController < ApplicationController

  def add_references
    @candidate = Candidate.find(params[:candidate_id])
    refs = Hash.new

    (1..2).each do |i|
      refs["reference_#{i}_name"] = params["reference_#{i}_name"]
      refs["reference_#{i}_email"] = params["reference_#{i}_email"]
      refs["reference_#{i}_relationship"] = params["reference_#{i}_relationship"]
    end

    if refs.has_value?("")
      flash[:notice] = "Por favor llena todos los campos antes de proceder."
      render "candidates/provide_references"
    else
      (1..2).each do |i|
      @candidate.references.create(name: refs["reference_#{i}_name"], email: refs["reference_#{i}_email"], relationship: refs["reference_#{i}_relationship"])
      end
      redirect_to candidate_next_stage_path(@candidate)
    end
  end

end
