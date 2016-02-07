class AccountsController < ApplicationController

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(params[:account])
    respond_to do |format|
      if @account.save
        format.html { redirect_to @admin }
        format.json {}
      else
        format.html { render action: "new" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @account = Account.find(params[:id])
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy
    redirect_to @admin
  end

end