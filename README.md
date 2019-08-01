# Welcome to MovieNight! 🙌

MovieNight is an app for people that prefer watching movies than arguing on titles.

It comes from an idea I had with [my love](https://www.instagram.com/p/BTra0oQFT9y/), when a day we spent more time choosing the movie than actually watching it. 😅

I thought we could create a personal movie watchlist (with movies that you want to watch or re-watch), so when you are with your friends or your partner, the app cross-compares the lists and tells which films you both want to watch. Easy, no?

## Current features

* Search for movies and add them to your watchlist ([TMDB](themoviedb.org) api)
* Search for people and send friendship requests

Currently we have the following models: `User`, `Movie`, `Wish`, and `Friendship`.

`Wish` represents the movie that a `User` wants to watch, it's basically a lookup table between `User` and `Movie`.

When the user logs in and searches for a movie, the `RemoteMoviesController` makes a request to the TMDB api and presents a list with the requested movies. When the user clicks on a movie, we create (if needed) a new record on the *movies* table (caching some info from tmdb), then we create a new `Wish` that relates the `Movie` with the `User`.

`Friendship` represent a friendship request: has a sender and a receiver. To represent that the
receiver has confirmed the friendship, we just fill the confirmation date on the friendship,
otherwise remains a pending request.

## Feature roadmap:

* Movie sync from TMDB - done
* Move movie search from TMDB to local db
* Get more details when searching for a movie (or while browsing your watchlist)
* Public profile page - done
* Unified search for movies and friends
* Search directors (director page with movies)
* Notifications for friendship requests
* Facebook login (now just Google login)
* Movie suggestor

## Possible features:

* Movie reviews
* "Wall" where you can see your friends' updates (reviews, watchlists updates)
* Event creation, invite friends, commenting events (Date-chooser à la Doodle?)


## Installation

Run:
```shell
bundle
bin/rails db:create db:migrate
bin/rails s
```

App is running at [localhost:3000](http://localhost:3000/).

## Test

Run:
```shell
bundle exec rspec
```
