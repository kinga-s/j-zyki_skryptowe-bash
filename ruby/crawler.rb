require 'open-uri'
require 'nokogiri'
require 'pg'


class WebCrawler
  def initialize(start_url, max_pages)
    @start_url = "https://www.empik.com"
    @max_pages = max_pages
    @visited_pages = Set.new
    @pages_to_visit = Queue.new
    @pages_to_visit << start_url
  end

  def crawl()
    conn = PG.connect(host: 'localhost', port: 5440, dbname: 'crawler', user: 'crawler', password: 'crawler')
    conn.exec_params('CREATE TABLE IF NOT EXISTS empik_books (
        id SERIAL PRIMARY KEY,
        title VARCHAR(255),
        author VARCHAR(100),
        book_category VARCHAR(30),
        link VARCHAR(255)
    );')
    url = @pages_to_visit.pop
    begin
      html = URI.open(url)
      doc = Nokogiri::HTML(html)

      extract_links(doc)

      @visited_pages << url
     rescue StandardError => e
      puts "Error crawling #{url}: #{e.message}"
     end

    while @visited_pages.size < @max_pages && !@pages_to_visit.empty?
      url = @pages_to_visit.pop
      next if @visited_pages.include?(url)

      puts "Crawling #{url}..."

      begin
        html = URI.open(url)
        doc = Nokogiri::HTML(html)

        read_data(conn, doc, url)

        @visited_pages << url
      rescue StandardError => e
        puts "Error crawling #{url}: #{e.message}"
      end
    end

    conn.close
    puts "Crawling finished, visited #{@visited_pages.size} pages."
  end

  private

  def extract_links(doc)
    links = doc.css('a').map { |link| link['href'] }.compact.uniq
    links.each do |link|
      if link.include?("ksiazka-p")
        if absolute_url?(link)
          @pages_to_visit << link
        else
          @pages_to_visit << URI.join(@start_url, link).to_s
        end
      end
    end
  end

  def read_data(conn, doc, url)
    title = doc.at_xpath('//h1[@data-ta="title"]').content
    author = doc.at_xpath('//div[@data-ta="smartauthor"]/a').content
    book_category = doc.at_xpath('//meta[@data-react-helmet="true" and @property="product:category2"]')['content']
    insert_into_postgres(conn, title, author, book_category, url)
  end

  def insert_into_postgres(conn, title, author, book_category, link)
    conn.exec_params('INSERT INTO empik_books (title, author, book_category, link) VALUES ($1, $2, $3, $4)', [title, author, book_category, link])
  end

  def absolute_url?(url)
    url.start_with?('http://') || url.start_with?('https://')
  end
end

keyword="camilla"
my_string = "https://www.empik.com/ksiazki,31,s?q=" + keyword + "&qtype=basicForm"
crawler = WebCrawler.new(my_string, 10)
crawler.crawl()
