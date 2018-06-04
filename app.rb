require "yaml"
require "nokogiri"
require "sinatra"

configure do
  CONFIG = YAML.load(File.read("config/config.yml"))
  def svg
    svg = Nokogiri::XML(CONFIG["base"])
    [2, 3, 4].sample.times do
      svg.at_css("svg g g g") << CONFIG["skins"].sample
    end
    [5, 6, 7].sample.times do
      svg.at_css("svg g g g") << CONFIG["parts"].sample
    end
    svg.to_s
  end
end

get "/" do
  haml :index
end

get "/svg" do
  content_type "image/svg+xml"
  svg
end

__END__
@@ index
%meta{name:"viewport",content:"width=device-width,initial-scale=1.0"}
%link{rel:"stylesheet",href:"//stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css"}
%script{type:"text/javascript",src:"//code.jquery.com/jquery-3.3.1.min.js"}
%p{style:"margin-left:10px;margin-top:10px"}
  "fukuwarai" feat.
  %a{href:"https://github.com/twitter/twemoji",target:"_blank"} twitter/twemoji
%p
  %img#svg{style:"display:none; opacity: 0"}!= svg
  %canvas#canvas
%p{style:"margin-left:10px"}
  %a{href:"/"} retry
  |
  download:
  %a#download-svg{target:"_blank"} svg
  %a#download-png{target:"_blank"} png
  |
  api:
  %a{href:"/svg",target:"_blank"} svg
:javascript
  const width = $(window).width()
  const xml = $("#svg").get(0).nextElementSibling.outerHTML
  const img = new Image()
  img.src = "data:image/svg+xml;base64," + btoa(xml)
  $("#download-svg").attr("href", img.src)
  img.onload = ()=> {
    $("#canvas").get(0).getContext("2d").drawImage(img, 0, 0, width, width)
    $("#download-png").attr("href", $("#canvas").get(0).toDataURL())
    $("#canvas").hide()
  }
  $("#canvas").attr({width: width, height: width})
