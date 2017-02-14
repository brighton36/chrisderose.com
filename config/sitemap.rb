# Change this to your host. See the readme at https://github.com/lassebunk/dynamic_sitemaps
# for examples of multiple hosts and folders.
host "www.chrisderose.com"

sitemap :site do
  url "https://#{host}", last_mod: Time.now, change_freq: "daily", priority: 1.0
end

sitemap_for YoutubeVideo.all, name: :videos do |video|
  url "https://#{host}/video/#{video.slug}", last_mod: video.updated_at
end

ping_with "http://#{host}/sitemap.xml"
