# OLX Scraper 🏠

Застосунок на Ruby on Rails, який парсить оголошення про нерухомість з OLX.ua і показує їх у вигляді карток.

## Технології

- Ruby on Rails 8.1
- HTTParty + Nokogiri — парсинг
- SQLite3
- Docker / Kamal

## Запуск

```bash
git clone https://github.com/karnyty1/olx_scraper.git
cd olx_scraper
bundle install
bin/rails db:setup
bin/dev
```

Відкрийте [http://localhost:3000](http://localhost:3000)

## Як користуватись

1. Оберіть кількість сторінок (1–10)
2. Оберіть сортування (ціна ↑ / ↓ / назва)
3. Натисніть «Знайти»

