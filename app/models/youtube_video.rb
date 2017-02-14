class YoutubeVideo < ActiveRecord::Base
  default_scope :order => "published_at DESC"

  scope :without_captions, -> { where(subtitle: nil) }
end
