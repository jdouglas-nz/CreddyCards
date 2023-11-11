# CREDDY CARDS

This is a 'fictitious' app that allows users to retrieve a random, mocked list of credit cards, sort/order, and favourite them.

## 'raw' requirements
* display a list of fetched credit carts
* sort/group cards by type
* favourite cards - which will be persisted and available also on the next launch (as in, save it to the disk).

## Architecture

This app is based on MVVM, where the Model is provided by an Repository abstraction.
SwiftUI views react to observable state in the ViewModels, and delegate any form of interaction into the view models.

## Test strategy

ViewModels are tested via unit tests, covering the callable methods. Unit tests (as much as possible) do NOT test observable publishing works (i.e. when you assign something to a published property, that you can get the new value in your subscriber) mainly because this is part of how SwiftUI works, and so falls out of scope (and surely we should give some degree of trust to Apple for this working, right?)

UI Tests will be implemented via a couple UI Automation tests (XCUITest) and Snapshot tests.

It is worth noting that network calls are not needed to be mocked/replayed, as instead an appropriate abstraction can be stubbed for the test - and are also by nature unstable (the API returns random results).