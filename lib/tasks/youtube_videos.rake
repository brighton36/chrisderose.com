require Rails.root.join('lib', 'subtitle_sync')
require 'yt'

Yt.configure do |config|   
  config = File.join(Rails.root, 'config', 'database.yml')
  s = YAML::load_documents(File.open config)
  env_config = s[0][ENV['RAILS_ENV']]

  config.log_level = :debug
  config.api_key = env_config['youtube_api_key']
end


namespace :youtube do
  desc "Scrape all videos and store in database since last scrapped"
  task :sync => :environment do

    Section.find_by_klass('YoutubeSection').collect do |s|
      # Date of first video we care about scraping. In YAML config file.
      scrape_since = Date.parse s.scrape_since
      start_date = YoutubeVideo.first.try(:published_at).try(:to_date).try(:days_ago, 2)
      start_date = scrape_since if start_date.nil? || start_date < scrape_since

      start_date = Time.parse '2014-11-15'

      Yt::Channel.new(id: s.channel).videos.each do |yt|
        next unless start_date < yt.published_at.to_time

        video = YoutubeVideo.find_by_youtube_id(yt.id) || YoutubeVideo.new
        video.assign_attributes(
         :title => yt.title,
         :href => 'http://www.youtube.com/watch?v=%s&feature=youtube_gdata_player' % yt.id,
         :description => yt.description,
         :published_at => yt.published_at,
         :youtube_id => yt.id,
         :thumbnail_url => yt.thumbnail_url(:medium),
         :thumbnail_high => yt.thumbnail_url(:high),
         :slug => yt.title.parameterize )


        video.save if video.changed?
      end

      YoutubeVideo.without_captions.each do |video|
        video.subtitle = YoutubeDlParser.new(video.href).subtitle
        video.save if video.changed?
      end

    end
  end

end
