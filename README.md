# fetchRepo
Fetch firebase iOS SDK  issues and comments from GitHub

Used the GitHub web API to retrieve all open issues associated with the firebase-ios-sdk repository.

First Screen - 

list of issues order by most recent updated.

Issue titles and first 140 characters of the issue body 

Second Screen -

The complete comment body and user name of each comment author

-----

Implemented persistent storage for issues using Core Data 
Added a check to fetch issues once in 24 hours from the API, else ftch it from local table. 
Used basic RxSwift & RxCocoa 
