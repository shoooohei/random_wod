class WodsController < ApplicationController
  def index
    @q = Wod.ransack(params[:q])
    @wod = @q.result(distinct: true).shuffle.first
  end

  def show
    @wod = Wod.find(params[:id])
    @logs = @wod.logs
  end
end
