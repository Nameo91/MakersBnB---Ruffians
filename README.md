# Team Ruffians presents Ruffhouses(tm)

## Intoduction

A web app clone of MakersBnB, allowing any young Ruffian to book their space to stay.

This repo contains the codebase for the MakersBnB project in Ruby (using Sinatra, Active Record & RSpec, deployed to Heroku).

## Functions
- Databases seeded & built using ORM (Active Record)
- Displays all available spaces
- Allows users to create an account
- Allows users to login
- Added sessions so that login persists
- Logged-in users can add new spaces including images
- Logged-in users can make bookings for a space using a calendar
- Spaces display images and currently booked dates
- If users make input errors, bespoke error pages displayed
- HTML & CSS refined
- Standardised HyperLinks on each page
- Deployed via Heroku: https://quiet-mountain-48625.herokuapp.com/

## Setup

```bash
# Install gems
bundle install

rake db:create

rake db:migrate

rake db:migrate RACK_ENV=test
# rack db:migrate RACK_ENV=production?

# Run tests
rspec

# Run to local server (better to do this in a separate terminal).
rackup

# OR visit https://quiet-mountain-48625.herokuapp.com/
```

## Testing & Code clarity
- Rubocopped*
- Fully tested, 95% pass completion*
