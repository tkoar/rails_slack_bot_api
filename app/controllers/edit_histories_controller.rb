class EditHistoriesController < ApplicationController
  def show
    render json: EditHistory.all()
  end
end
