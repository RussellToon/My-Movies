

Assumptions / Improvements:

Initial query is for movie release date in the past year. There may be better ones depending on requirements.

Not fetching configuration in the app, using hard coded values for now (for images).

No loading indicators / loading screens / resetting view state on commencing load yet.

No page handling yet. Easy to add, but not enough time.

API key is not committed in repository, please add your own to Secrets.plist (should be obfuscated for real app).

Errors fetching data from API not yet alerted to the user and no retry option (only printed in console).

Would have made explicit view models and translated API result objects into app specific data model objects given more time.

Would obviously add more details to the detail view.

Ideally more tests would increase coverage.

Implementing an image cache may improve performance, though it doesn't seem poor currently.


