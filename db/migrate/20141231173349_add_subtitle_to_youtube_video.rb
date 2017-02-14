class AddSubtitleToYoutubeVideo < ActiveRecord::Migration
  def change
    add_column :youtube_videos, :subtitle, :string
  end
end
