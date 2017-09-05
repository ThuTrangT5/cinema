# cinema

## 1. Home screen with list of available movies
<br/>a. Ordered by release date
<br/>b. Pull to refresh
<br/>c. Load when scrolled to bottom
<br/>d. Each movie to include:
* i. Poster/Backdrop image
* ii. Title
* iii. Popularity

## 2. Detail screen
<br/> a. Movie details with these  additional  details:
* i. Synopsis
* ii. Genres
* iii. Language
* iv. Duration
<br/> b. Book the movie (simulate opening http://www.cathaycineplexes.com.sg/ in a web view)


### Use the  API from TMDb (https://developers.themoviedb.org/3):
1. http://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877d9080ccb1604c91&primary_release_date.lte=2016-12-31&sort_by=release_date.desc&page=1
2. http://api.themoviedb.org/3/movie/328111?api_key=328c283cd27bd1877d9080ccb1604c91
