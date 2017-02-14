class DTIYamlObject
  def initialize yaml
    self.class.yaml_accessors.each{|a| instance_variable_set "@#{a}", yaml[a]}
  end

  class << self
    attr_accessor :yaml_accessors

    def yaml_accessor(*attrs)
      attr_accessor *attrs
      @yaml_accessors = attrs
    end
  end
end

class Link < DTIYamlObject
  yaml_accessor *%w(title description date href image)

  def slug
    @title.parameterize
  end
end

class Section < DTIYamlObject
  yaml_accessor *%w(title klass description href template nav images)
  attr_accessor :links
  
  def initialize section 
    super section
    @template ||= 'landscape'
    @links = section['links'].collect{|link| Link.new link} if section['links']
  end

  def format
    @template
  end

  def slug
    @title.parameterize
  end

  def find_link(slug)
    links.find{|l| l.slug == slug}
  end

  def self.all(page='home')
    config = File.join(Rails.root, 'config', '%s.yml' % page)
    YAML::load_documents(File.open config).collect do |s|
      klass = s['klass'] || 'Section'
      Kernel.const_get(klass).new s
    end
  end

  def self.find_by_slug(slug, page='home')
    all(page).find{|s| s.slug == slug }
  end

  def self.find_by_klass(klass, page='home')
    all(page).find_all{|s| s.klass == klass}
  end
end

class YoutubeSection < Section
  yaml_accessor *%w(title klass description href template nav images channel scrape_since)

  def initialize section
    super section
  end

  def links
    YoutubeVideo.all.collect {|v| Link.new v}
  end
end
