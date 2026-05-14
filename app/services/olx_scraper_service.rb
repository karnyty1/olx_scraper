require "httparty"
require "nokogiri"

class OlxScraperService
  BASE_URL = "https://www.olx.ua/uk/nedvizhimost/"

  HEADERS = {
    "User-Agent" =>  "Mozilla/5.0 (Windows NT 10.0; Win64; x64;) AppleWebKit/537.36",
    "Accept-Language" => "uk-UA,uk;q=0.9",
    "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
  }.freeze


  def initialize(pages: 5)
    @pages = pages
  end


  def call
    apartments = []

    (1..@pages).each do |page_number|
      url = "#{BASE_URL}?page=#{page_number}"

      begin
        response = HTTParty.get(url, headers: HEADERS, timeout: 15)
        doc = Nokogiri::HTML(response.body)
        doc.css('[data-cy="l-card"]').each do |card|
          apt = parse_card(card)
          apartments << apt if apt
        end

        sleep(rand(0.8..1.5))
      rescue => t
        Rails.logger.warn "OLX scraper error on page #{page_number}: #{t.message}"
      end
    end
    apartments.sort_by { |apt| apt[:price] }
  end



  private

  def parse_card(card)
    title = card.css('[data-testid="ad-card-title"] h4').text.strip
    return nil if title.empty?

    raw_price  = card.css('[data-testid="ad-price"]').text
    price = parse_price(raw_price)
    return nil if price.nil? || price.zero?

    href = card.css("a").first&.attr("href")
    return nil if href.nil?

    link = href.start_with?("http") ? href : "https://www.olx.ua#{href}"
    image = extract_image(card)
    location = card.css('[data-testid="location-date"]').text.strip

    {
      title: title,
      price: price,
      link: link,
      image: image,
      location: location
    }
  end


  def parse_price(raw)
    match = raw.match(/[\d][\d\s,.]+/)
    return nil unless match

    match.to_s.strip.gsub(/[\s\u00a0]/, "").gsub(",", ".").to_f
  end


  def extract_image(card)
    img = card.css("img").first
    return nil unless img
    img.attr("src").presence || img.attr("data-src").presence
  end
end
