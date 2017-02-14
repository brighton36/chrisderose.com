class VideosController < ApplicationController
  caches_page :show, :thumbnail

  def show 
    @sections = Section.all
    @video = YoutubeVideo.find_by_slug params[:title]
    @sidebar_videos = YoutubeVideo.where.not(id: @video.id).offset(rand(YoutubeVideo.count)).first(3)
  end

  def thumbnail
    link = YoutubeVideo.find_by_slug(params[:title]) ||
      Section.find_by_slug(params[:section]).find_link(params[:title])

    logger.error "Huhuh"+link.inspect

    yt = Yt::Video.new url: link.href

    thumbnail = link.try(:thumbnail_high) || yt.thumbnail_url(:high)

    send_file( 
      open(thumbnail),
      :disposition => 'inline',
      :type => 'image/jpeg',
      :x_sendfile => true 
    )
  end
end
