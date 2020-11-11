class WodifyWodsController < ApplicationController
  def new
  end

  def create
    start_date = Date.parse(wodify_wod_params[:start_date])
    end_date = Date.parse(wodify_wod_params[:end_date])
    wodify_wod_client = WodifyWod.new
    data = wodify_wod_client.fetch_wods(start_date, end_date)
    logger.info(data)
    redirect_to new_wodify_wod_path, notice: "最後まで実行できました。"
  end

  private
  def wodify_wod_params
    params.require(:wodify_wod).permit(:start_date, :end_date)
  end
end
