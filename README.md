# codepath-Week1-rottentomatos

This is a movies app displaying box office using the [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON). See the [Week 1 Assignment](https://courses.codepath.com/courses/intro_to_ios/week/1#!assignment) tutorial.

Time spent: 10 hours spent in total
### Features

#### Required

  * [x] Required: User can view a list of movies from Rotten Tomatoes. Poster images must be loading asynchronously.
  * [x] Required: User can view movie details by tapping on a cell.
  * [x] Required: User sees loading state while waiting for movies API. Used [SVProgressHUD](http://samvermette.com/199)
  * [x] Required: User sees error message when there's a networking error. [Screenshot](network_error_screenshot.png)
  * [x] Required: User can pull to refresh the movie list. Guide: Using UIRefreshControl

#### Optional

  * [x] optional: Add a search bar (UISearchBar).
  * [x] optional: All images fade in. Images in the table view will fake in when first time loaded
  * [x] optional: For the large poster, load the low-res image first, switch to high-res when complete (optional)

#### Notes:

Found there is a bug with setImageWithURL or setImageWithURLRequest in AFNetworking pod. When a same url getting called that the same time or before first one is finished, the second call will fail to excute. I fixed it by adding a queue like wrapper method(Details in [Utils.swift](rottenTomato/Utils.swift)).

Added 2 sections in movies: coming soon and in theater

### Walkthrough

![Video Walkthrough](walk_through.gif)


Credits
---------
* [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* GIF created with [LiceCap](http://www.cockos.com/licecap/).
* [SVProgressHUD](http://samvermette.com/199)
