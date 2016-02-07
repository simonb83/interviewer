class OrganizationsController < ApplicationController

  def new
    @organization = Organization.new
    @accounts = Account.all
  end

  def create
    @organization = Organization.new(params[:organization])

     respond_to do |format|
     if @organization.save
      format.html { redirect_to organization_path(@organization), notice: "Organization successfully created" }
      format.json {}
      else
        format.html { render action: "new" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
     end
    end
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy
    redirect_to current_admin, notice: "#{@organization.name} Deleted"
  end

end