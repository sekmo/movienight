# Welcome to MovieNight! 🙌

MovieNight is an app for people that prefer watching movies than arguing on titles.

It comes from an idea I had some months ago, after I spent my girlfriend something like two hours choosing a 95-minute movie.

I thought we could create a personal "Movies I want to (re)watch" list, so when you are with your friends or your partner, the app cross-compares the lists and tells what film you both want to watch. Easy peasy.

## Current stage

The application is in its embryo stage - at the moment it has the movie searcher and the "Add to whishlist" feature.
Currently we have three models: *User*, *Movie*, and *Wish*.
*Wish* represents the film that a *User* wants to (re)watch; it's basically a HABTM association between *User* and *Movie*.

When the user logs in and searches for a movie, the *RemoteMoviesController* makes a request to the TMDB api and presents a list with the matching movies. When the user clicks on a movie, we create (if needed) a new record on the *movies* table (caching the *tmdb_id* and the *title*), then we create a new *Wish* that relates the *Movie* with the *User*.

## Next steps

* Add a validation with external api call (to check tmdb_id/movie title validity) before persisting movie data
* Add Foundation to prototype faster
* Feature: Event creation and inviting
* Feature: Comment on events

Possible features:
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
