class ViewhandlerController < ApplicationController
  caches_page :index
  caches_page :video_thumbnail

  def index
    @sections = Section.all
  end
end
