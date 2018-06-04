require "yaml"
require "open-uri"
require "nokogiri"
require "fileutils"

class Default < Thor
  CONFIG_DIR = "config"
  TARGET_URL = "https://commons.wikimedia.org/wiki/Emoji"

  desc "download", "download twitter emoticon files"
  def download
    FileUtils.mkdir_p(CONFIG_DIR)
    doc = Nokogiri::HTML(open(TARGET_URL))
    imgs = doc.search("td:nth-child(10) img")[0, 89]
    urls = imgs.map {|img| img["src"] }
    urls.each do |url|
      url = url.split("/")[0..-2].join("/")
      url = url.gsub(%r(/thumb), "")
      filename = File.basename(url)
      File.write(File.join(CONFIG_DIR, filename), Nokogiri::XML(open(url)).to_s)
    end
  end

  desc "organize", "organize emoticon parts"
  def organize
    FileUtils.mkdir_p(CONFIG_DIR)
    skins = []
    parts = []
    paths = Dir[File.join(CONFIG_DIR, "*.svg")]
    paths.each do |path|
      svg = Nokogiri::XML(open(path))
      g_list = svg.search("svg g g g g")
      g_list.each do |g|
        next unless path = g.at_css("path")
        g.remove_attribute("id")
        path.remove_attribute("id")
        if path["style"].match(/^fill:#ffcc4d;/)
          skins << g.to_s
        else
          parts << g.to_s
        end
      end
    end
    skins = skins.uniq
    parts = parts.uniq
    svg = Nokogiri::XML(open(paths.first))
    svg.search("svg g g g g").remove
    base = svg.to_s
    File.write(File.join(CONFIG_DIR, "config.yml"), {
      "skins" => skins,
      "parts" => parts,
      "base" => base 
    }.to_yaml)
  end
end
