module VideosHelper
  def to_paragraphs(string, lines)
    res = ''
    string.each_line('.').each_with_index do |line, index|
      res += (index % lines == 0) ? "</p><p>%s" % [line] : line
    end
    content_tag(:p, res.html_safe)
  end
end
