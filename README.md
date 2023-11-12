# CREDDY CARDS

This is a 'fictitious' app that allows users to retrieve a random, mocked list of credit cards, sort/order, and favourite them.

## 'raw' requirements
* display a list of fetched credit carts
* sort/group cards by type
* favourite cards - which will be persisted and available also on the next launch (as in, save it to the disk).

### Dev environment

I made this app on a 16" Apple M2 Pro running Sonoma 14.0, working in Xcode 15.0.
```
swift -version                                       
swift-driver version: 1.87.1 Apple Swift version 5.9 (swiftlang-5.9.0.128.108 clang-1500.0.40.1)
Target: arm64-apple-macosx14.0
```

## Architecture

This app is based on MVVM, where the Model is provided by a Repository abstraction.
SwiftUI views react to observable state in the ViewModels, and delegate any form of interaction into the view models.

### Dependencies 

While in previous lives, I'd really want to bring in things like ObjectMapper, maybe an AFNetworking type thing, or a library for SQLite, the foundation of Swift is just getting super good, and you most likely don't need much of those things, because its probably already built in the foundation of Swift somewhere. 
I've heard some good things about GRDB, but decided to stick to the 'first party' offerings.

TL;DR generally I don't opt for many dependencies. 

I might look at pulling in Vexil later, just because chances are, most companies are doing some sort of GitFlow, or want to be able to toggle stuff remotely (maybe for a marketed feature release?). Vexil is a tool that allows for that - decoupling deployments from releases.
I might just use this for the 'max number of items' for the API call.

I also might look at Swinject for managing the dependency graph.

## Test strategy

ViewModels are tested via unit tests, covering the callable methods. Unit tests (as much as possible) do NOT test observable publishing works (i.e. when you assign something to a published property, that you can get the new value in your subscriber) mainly because this is part of how SwiftUI works, and so falls out of scope (and surely we should give some degree of trust to Apple for this working, right?)

UI Tests will be implemented via a couple UI Automation tests (XCUITest) and Snapshot tests.

It is worth noting that network calls are not needed to be mocked/replayed, as instead an appropriate abstraction can be stubbed for the test - and are also by nature unstable (the API returns random results).

### Learning Objectives

#### SwiftData

Recently, well.. at WWDC'23, SwiftData was showcased, and it caught my eye. 
Most of the apps I've work on throughout my career were either solely online (so didn't need something as complex as CoreData), had their own SQLite DB all abstracted away through a strongly typed 'repo' style layer, or used Realm DB. 
I have toyed with Firebase Realtime database, but besides a small integration to store 'hearted' products I haven't had much exposure to CoreData. 
I selfishly set a learning objective to get a good feel for SwiftData, as making CoreData less... obj-c and more "Swiftey" helps a lot with newbies to Apple's ORM (myself included in that grouping btw!). 
So, You'll probably see some 'overkill' in here - especially with the versioned schemas, but I just wanted to explore this given the opportunity and time/energy.

#### The balancing act of testability

one of my biggest gripes with SwiftUI is also one of the things that makes it so accessible and quick to write. 

Building a navigation stack is insanely easy, but as this doesn't go through the view model, you can't unit test the navigation (i.e. when I click this button, the app should navigate) as it is tightly coupled to the UI framework.

Similarly, I started with the SwiftData/SwiftUI app project template, and some of the property wrappers are amazing and leave very little 'hand crafted' boilerplatey code. 
It is fascinating to try and reconcile the engineering directives of "make it testable", "be efficient", and "rely on abstractions" with Apple's starting point - which has SwiftData everywhere through the code (read: if something even cooler comes along, SwiftData would be hard to replace) and a lot of things that you could test with abstractions.
I opted to lean towards testability, at the expense of more code - which at the start of this project I hadn't worked in a purely SwiftUI app.