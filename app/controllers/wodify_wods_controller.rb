class WodifyWodsController < ApplicationController
  def new
  end

  def create
    wodify_wod_client = WodifyWod.new
    wodify_wod_client.fetch_wods(
      wodify_wod_params[:email],
      wodify_wod_params[:password],
      wodify_wod_params[:date_1],
      wodify_wod_params[:date_2]
    ) do |each_wod_html|
      logger.info(each_wod_html)
    end
    redirect_to new_wodify_wod_path, notice: "最後まで実行できました。"
  end

  private
  def wodify_wod_params
    params.require(:wodify_wod).permit(:email, :password, :date_1, :date_2)
  end
end
