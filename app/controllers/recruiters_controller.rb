class RecruitersController < ApplicationController

  load_and_authorize_resource

def new
  @recruiter = Recruiter.new(organization_id: params[:organization_id])
end

def create
  @recruiter = Recruiter.new(params[:recruiter])
  @recruiter.password_confirmation = @recruiter.password
  respond_to do |format|
     if @recruiter.save
      format.html { redirect_to organization_path(@recruiter.organization) }
      format.json {}
      else
        format.html { render action: "new" }
        format.json { render json: @recruiter.errors, status: :unprocessable_entity }
     end
  end
end

def manage
  @recruiter = Recruiter.find(params[:recruiter_id])
end

def show
  @recruiter = Recruiter.find(params[:id])
  @first_time = true if params[:first_time]
end

def edit
  @recruiter = Recruiter.find(params[:id])
end

def update
  @recruiter = Recruiter.find(params[:id])
  if params[:commit] == "Cancelar"
    redirect_to @recruiter
  else
    if @recruiter.update_attributes(params[:recruiter])
      @recruiter.save
      redirect_to @recruiter, notice: t(:account_updated)
    else
      render action: "edit"
    end
  end
end

def remove_account
  @recruiter = Recruiter.find(params[:recruiter_id])
end

def destroy
  @recruiter = Recruiter.find(params[:id])
  @recruiter.destroy
  if admin_signed_in?
    redirect_to organization_path(@recruiter.organization), notice: "#{@recruiter.name} Deleted"
  else
    redirect_to root_path
  end
end

def change_password
  @recruiter = current_recruiter
end

def update_password
  @recruiter = Recruiter.find(params[:recruiter_id])
    if @recruiter.update_with_password(params[:recruiter])
      # Sign in the user by passing validation in case his password changed
      if @recruiter.new_user
        @recruiter.update_attribute(:new_user, false)
        sign_in @recruiter, :bypass => true
        redirect_to recruiter_path(@recruiter, first_time: true)
      else
        sign_in @recruiter, :bypass => true
        redirect_to @recruiter
      end
    else
      respond_to do |format|
        format.html {render "change_password"}
        format.json {render json: @recruiter.errors, status: :unprocessable_entity}
      end
    end
end

end
