class AddThumbnailHighToYoutubeVideo < ActiveRecord::Migration
  def change
    add_column :youtube_videos, :thumbnail_high, :string
  end
end
