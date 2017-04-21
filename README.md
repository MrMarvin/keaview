# Install
`bundle install`

# Usage

Keaview supports two modes: A web based viewer mode and an interactive shell mode.

## interactive shell:
```
DATABASE_URL=mysql2://user:passwort@databasehost.acme.com:3306/kea1-db1 bundle exec ruby ./console.rb
```

## web viewer:
```
DATABASE_URL=mysql2://user:passwort@databasehost.acme.com:3306/kea1-db1 bundle exec rackup
```
and browse to http://localhost:9292

## Configuration
Keaview uses to Environment variables:
* `DATABASE_URL` which is an url to the database to connect to
* `NAMSERVER` which is optional and can be used to specify a dedicated nameserver to use for resolution (e.g. the autorative NS for a particular zone, so errors due to non-local caching can be reduced)
