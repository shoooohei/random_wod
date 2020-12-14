class WodsController < ApplicationController
  def index
    @q = Wod.ransack(params[:q])
    @wod = @q.result(distinct: true).shuffle.first
  end
end
