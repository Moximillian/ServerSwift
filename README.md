# ServerSwift
Server side Swift

This is Swift server using Vapor and Heroku.
It works in both running locally (localhost) and on heroku server.

Currently it only serves "/" and responds with struct Stuff in json serialization.


## How to setup server side Swift with Vapor & Heroku from scratch

    mkdir <projectfolder>
    cd <projectfolder>
    git init

##### SETUP SWIFT PACKAGE MANAGER

    swift package init --type executable

##### SETUP VAPOR

Add Vapor dependency to Package.swift

    import PackageDescription

    let package = Package(
        name: "ServerSwift",
        dependencies: [
            .Package(url: "https://github.com/qutheory/vapor.git", majorVersion: 0, minor: 12)
        ]
    )

NOTE: the *.xcodeproj files are not committed to git repository

    swift package generate-xcodeproj

    open ProjectName.xcodeproj

Implement the vapor app –
See slide 24 of https://realm.io/news/slug-edward-jiang-server-side-swift/


##### SETUP HEROKU

    heroku create
    heroku buildpacks:set https://github.com/kylef/heroku-buildpack-swift
    echo 'web: ProjectName --port=$PORT' >Procfile


##### COMMIT AND PUSH TO HEROKU

    git add .
    git commit -m "Initial project"
    git push heroku master
    
