class WodsController < ApplicationController
  def new
  end

  def create
    url = params.require(:wod).permit(:url)[:url]
    @client = InstagramClient.new
    @client.crawl!(url)
    @video_url = "https://scontent-nrt1-1.cdninstagram.com/v/t50.2886-16/92718886_1379888755517042_8390533929808907856_n.mp4?_nc_ht=scontent-nrt1-1.cdninstagram.com&_nc_cat=102&_nc_ohc=tVAGECr3PAcAX-06nZn&oe=5EA27632&oh=cec6382de5a99533cb4d2ab3e05aff73"
    logger.info("コントローラーでは")
    logger.info(@video_url)
  end
end
