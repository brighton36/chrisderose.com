require 'tempfile'

class SubtitleSyncError < StandardError; end
class InvalidYoutubeURL < StandardError; end

class YoutubeDlParser

  attr_reader :href, :subtitle

  YOUTUBEDL = '/usr/bin/youtube-dl --write-sub --restrict-filenames --skip-download -o "%s" "%s" 2>&1 > /dev/null'
  VALID_WARNINGS = ["video doesn't have subtitles"]
  VALID_YOUTUBE_URL = /\Ahttp(?:[\w\:\/\.\?\=\-\_\~\+\&]*)\z/

  def initialize(href)
    raise InvalidYoutubeURL, href unless VALID_YOUTUBE_URL.match href
    @href = href
    sub = srt_from_href @href
    @subtitle = sub.split("\n").reject{|s| s.try(:empty?) || is_scene_number?(s) || is_time_stamp?(s) }.join(" ") if sub
  end

  private

  def srt_from_href(href)
    begin
      #NOTE: only used for a random filename
      tmp_file = Tempfile.new 'sub'
      srt_file = "%s.en.srt" % [tmp_file.path] 
      stdin, stdout, stderr, wait_thr = Open3.popen3 YOUTUBEDL % [tmp_file.path, href]
      output = stdout.gets

      raise SubtitleSyncError, "%s | %s" % [output.to_s.chomp, href] unless has_valid_line?(output) || wait_thr.value.success? || stderr
      
      File.read srt_file if File.exist? srt_file
    ensure
      tmp_file.try(:close)
      tmp_file.try(:unlink)
      srt_file.try(:close)
      srt_file.try(:unlink)
    end
  end

  def has_valid_line?(output)
    output && output.lines.any?{ |line| is_valid_line? line }
  end
 
  def is_valid_line?(line)
    VALID_WARNINGS.any? {|w| line.match w}
  end

  def is_scene_number?(str)
    /\A[\d]*\z/.match(str.strip) ? true : false
  end

  def is_time_stamp?(str)
    /[\d]{2}:[\d]{2}:[\d]{2},[\d]{3}\s-->/.match(str.strip) ? true : false
  end
end
