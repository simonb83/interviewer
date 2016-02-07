class IssuesController < ApplicationController

  load_and_authorize_resource only: [:recruiter_technical_support, :update_status, :destroy]

  def candidate_technical_support
    @candidate = Candidate.find(params[:candidate_id])
    @issue = Issue.new(interview_id: @candidate.uid, email: @candidate.email, category: "candidate")
  end

  def recruiter_technical_support
    @recruiter = Recruiter.find(params[:recruiter_id])
    @issue = Issue.new(email: @recruiter.email, category: "recruiter", recruiter_id: @recruiter.id)
  end

  def technical_support
    @issue = Issue.new(category: "other")
  end

  def create
    @issue = Issue.new(params[:issue])
    respond_to do |format|
      if @issue.save!
        # AdminMailer.issue_confirm(@issue).deliver
        # AdminMailer.new_issue(@issue).deliver
        format.html { redirect_to @issue, notice: t(:create_issue_confirm) }
      else
        format.html { render action: "candidate_technical_support" }
        format.json { render json: @issue.errors, status: :unprocessable_entity}
      end
    end
  end

  def show
    @issue = Issue.find(params[:id])
    render @issue.get_template
  end

  def update_status
    @issue = Issue.find(params[:issue_id])
    @issue.switch_status
    redirect_to @admin
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    redirect_to @admin
  end

end
