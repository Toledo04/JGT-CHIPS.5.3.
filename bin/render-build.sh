#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

bundle exec rails db:migrate
# Seed only when the table is empty, so redeploys don't duplicate the movies
bundle exec rails runner 'Rails.application.load_seed if Movie.count.zero?'
