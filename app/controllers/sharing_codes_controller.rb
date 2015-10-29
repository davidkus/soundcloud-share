class SharingCodesController < ApplicationController
  after_action :verify_authorized

  expose(:room)
  expose(:sharing_code, attributes: :sharing_code_params)
  expose(:sharing_codes, ancestor: :room)
  expose(:accessible_codes) { sharing_codes.select { |c| !c.expired? } }

  def index
    authorize room, :update?

    respond_to do |format|
      format.js
    end
  end

  def show
    authorize sharing_code

    respond_to do |format|
      format.js
    end
  end

  def new
    authorize sharing_code

    respond_to do |format|
      format.js
    end
  end

  def create
    authorize sharing_code

    respond_to do |format|
      if sharing_code.save
        format.js { render :show }
      else
        format.json { render json: sharing_code.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize sharing_code

    sharing_code.destroy

    respond_to do |format|
      format.js { render :index }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def sharing_code_params
      params.permit :expires, :expiry_date
    end

end
