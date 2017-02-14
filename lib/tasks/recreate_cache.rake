require 'fileutils'

namespace :cache do
  desc "Clear cached files in public directory"
  task :clear => :environment do
    SITE_DIR = "/var/www/chrisderose.com"
    #NOTE: rm files and noop verbose
    FileUtils.rm [
      "#{SITE_DIR}/public/index.html", 
      Dir.glob("#{SITE_DIR}/public/video/*.html")
    ], :force => true
  end
end
