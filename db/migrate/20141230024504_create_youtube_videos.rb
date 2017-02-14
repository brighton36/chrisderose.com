class CreateYoutubeVideos < ActiveRecord::Migration
  def change
    create_table :youtube_videos do |t|
      t.string :title
      t.string :href
      t.text :description
      t.datetime :published_at
      t.string :thumbnail_url
      t.string :youtube_id
      t.string :slug

      t.timestamps
    end
    add_index :youtube_videos, :slug, unique: true
  end
end
