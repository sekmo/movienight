# Welcome to MovieNight! 🙌

MovieNight is an app for people that prefer watching movies than arguing on titles.

It comes from an idea I had some months ago, after I spent with my girlfriend about two hours choosing a one-and-a-half-hour movie.

I thought we could create a personal movie wishlist (with movies that you want to watch or re-watch), so when you are with your friends or your partner, the app cross-compares the lists and tells which films you both want to watch. Easy peasy.

## Current features

* Profile creation
* Search for movies (TMDB api)
* Add movies to the wishlist
* Search for friends
* Send friendship requests to other profiles

Currently we have five models: *User*, *Profile*, *Movie*, *Wish*, and *Friendship*.

*Wish* represents the movie that a *Profile* wants to watch, it's basically a lookup table between *Profile* and *Movie*. The Wish and Friendship models relate with the Profile model rather than Users, since
we pass around Profiles, not Users (think about friendships and event invites).
Also, in this way the authentication is kept separated from the social feature.

When the user logs in and searches for a movie, the *RemoteMoviesController* makes a request to the TMDB api and presents a list with the requested movies. When the user clicks on a movie, we create (if needed) a new record on the *movies* table (caching the *tmdb_id* and the *title*), then we create a new *Wish* that relates the *Movie* with the *User*.

*Profile*: a user is asked to create a Profile with first name, last name and username to add movies on her wishlist.

*Friendship* represent a friendship request: has a sender and a receiver. To represent that the
receiver has confirmed the friendship, we just fill the confirmation date on the friendship,
otherwise remains a pending request.

## Feature roadmap:

* Event creation, invite friends
* Comment on events

## Possible features:

* Movie reviews
* Follow people to see updates (reviews, wishlists updates)
* Date-chooser à la Doodle


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
