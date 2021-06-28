# ArticleSummizer.new(url: 'https://www.theguardian.com/world/2021/jun/26/eighteen-bodies-found-after-suspected-drug-cartel-shootout-in-northern-mexico')

class ArticleSummizer
  attr_reader :url, :content

  def initialize(url:, content: nil)
    @url = ::CGI::unescape(url.split('uddg=').last.split('&rut=').first)
    @content = content
  end

  def self.perform(url)
    ::ArticleSummizer.new(url: url).perform
  end

  # Shorten the article based on a url or content passed as an argument
  #
  # @return [String]
  def perform
    return content.summarize if content.present?

    article_content = RestClient.get(url)
    html = Nokogiri::HTML(article_content.body)
    p_tags = html.search('p')
    # Content contains anchors
    inner_content = p_tags.map(&:inner_html).join('')
    # Content only contains text
    text_content = Nokogiri::HTML(inner_content).xpath("//p//text()")
    content_to_summarize = text_content.map(&:text).join('')

    # Summarized content
    return content_to_summarize if content_to_summarize.length < 1000

    content_to_summarize.summarize.force_encoding("utf-8")
  end
end