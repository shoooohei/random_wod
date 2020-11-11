class InstagramWodsController < ApplicationController
  def new
  end

  def create
    url = params.require(:wod).permit(:url)[:url]
    @client = InstagramWod.new
    @client.crawl!(url)
  end
end
