class WodifyWodsController < ApplicationController
  def new
  end

  def create
    wodify_wod_client = WodifyWod.new
    are_all_wods_saved = true
    Wod.transaction do
      wodify_wod_client.fetch_wods(
        wodify_wod_params[:email],
        wodify_wod_params[:password],
        wodify_wod_params[:date_1],
        wodify_wod_params[:date_2]
      ) do |each_wod_html, date|
        wod = Wod.new(specified_date: date)
        logger.info("specified_date: #{date}")
        if wod.create_from_html(each_wod_html)
          logger.info("#{date}のWodが保存できました。")
        else
          are_all_wods_saved = false
          logger.error("#{date}のWodが保存に失敗しました。")
          logger.error(wod.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end
    end

    if are_all_wods_saved
      flash[:notice] = "全てのWodが保存できました。"
    else
      flash[:notice] = "Wodの保存に失敗しました。"
    end
    redirect_to new_wodify_wod_path
  end

  private
  def wodify_wod_params
    params.require(:wodify_wod).permit(:email, :password, :date_1, :date_2)
  end
end
