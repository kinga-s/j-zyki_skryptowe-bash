# Crawler in Ruby for Empik website. The data of each book is stored in postgres database.


## To run:
1. Install the required gems using RubyGems:

```bash
gem install open-uri
gem install nokogiri
gem install pg
```

2. Start the database:
```bash
docker-compose up -d
```

3. Run the script:
```bash
ruby crawler.rb
```

