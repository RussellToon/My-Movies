# My-Movies
Show a list of movies from TMDB, with detail screen


Notes
-----

This is implemented in SwiftUI.



Assumptions / Improvements
--------------------------

Initial query is for movie release date in the past year. A better query could be formed depending on requirements.

The app is not fetching configuration, it is using hard coded values for now (for images).

No loading indicators / loading screens / resetting view state on commencing load yet.

No page handling yet. Easy to add, but not enough time.

API key is not committed in repository, please add your own to Secrets.plist (should be obfuscated for real app).

Errors fetching data from the API are not yet alerted to the user and there is no retry option (errors only printed in console).

Would have made explicit view models and translated API result objects into app specific data model objects given more time.

Would obviously add more details to the detail view.

Ideally would add more tests to increase coverage.

Implementing an image cache may improve performance, though it doesn't seem poor currently.



