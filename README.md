# CREDDY CARDS

This is a 'fictitious' app that allows users to retrieve a random, mocked grouped list of credit cards, and favourite them.

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

### Repository Abstraction

As needed, this is implemented as a SwiftData abstraction, and additionally with a Network abstraction (as needed).

### Dependencies 

While in previous lives, I'd really want to bring in things like ObjectMapper, maybe an AFNetworking type thing, or a library for SQLite, the foundation of Swift is just getting super good, and you most likely don't need much of those things, because its probably already built in the foundation of Swift somewhere. 
I've heard some good things about GRDB, but decided to stick to the 'first party' offerings.

TL;DR generally I don't opt for many dependencies.

I might look at pulling in Vexil later, just because chances are, most companies are doing some sort of GitFlow, or want to be able to toggle stuff remotely (maybe for a marketed feature release?). Vexil is a tool that allows for that - decoupling deployments from releases.
I might just use this for the 'max number of items' for the API call.

I also might look at Swinject for managing the dependency graph.
(and I'd integrate them with SwiftPM, of course!)

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

#### Do something cool in SwiftUI
I often don't get opportunities to do something kinda cool in SwiftUI - and I spent a fair chunk of time (having fun with) getting the 'Card' looking how it does.

### Future opportunities for improvement with this app
I think I did reasonably well with this, but given this is only a fictious thing, I'd like to write on some of the areas I'd look to improve.
* Testable navigation - I thought I'd have time to rip out nav from the SwiftUI views, but I probably have spent enough time. I had found [this guide](https://www.avanderlee.com/swiftui/navigationlink-programmatically-binding/) on doing so, and would've gone that way (with bindings - which can be observed in tests).
* CardList refreshing 'everytime' you view it. It could be a 'feature', or a bug, depending on how you look at it. I think I'd call it more of a bug personally, and would want to only refresh if needed. Perhaps two `ModelContext` instances would fix it, where one is 'persisted' for favouriting and the other is not (in the plain list).
* duplication of SwiftUI code. some examples include `contentUnavailable(title: String, systemImageName: String, description: String)`, and the approach 'loading' data and view state. The next step would be moving the switches to a `AsyncContentView` [style approach](https://www.swiftbysundell.com/articles/handling-loading-states-in-swiftui/). A big fan of that approach. super flexible, and expressive.
* fix the `test_migrationCreditCardsFromV1ToV2_allEndUpUnfavourited` test. There are some comments in that class.
* internationalisation / string constant management - I am using magic strings - which is a bit meh in terms of i10n.
* maybe some more fun animations with the card?
* Feature Flags - I didn't get there, but would want Vexil to manage the number of items per API call.
* Dependency management - yeah, it was getting kinda hectic especially passing around the ModelContext. I'd use Swinject to simplify this, or something like Swinject. Xero has a cool `@Injected` property wrapper that works nicely.
* the UI tests can be flaky.. well, specifically, I found a snippet of code on the web to uninstall the app between tests. Instead of a magic launch argument that means I need to write test specific code in the prod app, I opted to just nuke the thing between tests. That code is flaky - or at least it is on my machine. The two tests I wrote worked pretty well on my machine otherwise besides the `tearDown()`!

---

#### aside
I don't really like to write comments for code, but I know some people do. I have added _some_ comments, but generally think that the code should be self documenting, and comments are prone to rot.
Also, "Stubs" in the tests -- I wish Swift had strong reflection capabilities, and swizzling wasn't so tricky -- I say that especially coming from a bunch of .NET experience - where libraries like [MOQ](https://github.com/devlooped/moq) exist and allow for some really cool stuff with just interfaces like this:
```
  ILoveThisLibrary lovable = Mock.Of<ILoveThisLibrary>(l =>
    l.DownloadExists("2.0.0.0") == true);
```
(you don't have to define all of that boilerplate Stub stuff, instead it all works on this 'fluent'ish API.)

Also also, I decided to leave my branches undeleted, so if anyone was curious to how I split this out, its all there.