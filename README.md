# ServerSwift
Server side Swift

This is Swift server using Vapor and Heroku.
It works in both running locally (localhost) and on heroku server.

Currently it only serves "/" and responds with struct Stuff in json serialization.


## How to setup server side Swift with Vapor & Heroku from scratch

##### SETUP VAPOR TOOLBOX
  
    brew install vapor/tap/toolbox

##### CREATE PROJECT & folder
  
      vapor new <project-name>

##### CREATE XCODE PROJECT

      vapor xcode

      ...then you can open the project file in XCode

##### CODE STUFF

      code stuff (Main.swift)

##### SETUP HEROKU

      vapor heroku

##### COMMIT AND PUSH TO HEROKU

    git add .
    git commit -m "Initial project"
    git push heroku master
    
