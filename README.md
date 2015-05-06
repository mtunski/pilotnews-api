pilotnews-api
=============

Simple API for HackerNews clone (Pilot Academy workshop)

Setup
-----

```
git clone https://github.com/mtunski/pilotnews-api.git pilotnews-api && cd $_
bundle
# create databases
cp .env.example .env; cp .env.example .env.test # adjust
bundle exec rake db:migrate; bundle exec rake db:migrate ENV=test
```

Usage
-----

### Running locally

```
bundle exec rackup
```

### Tests

```
bundle exec rake
```
