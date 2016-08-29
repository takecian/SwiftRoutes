# SwiftRoutes

[![CI Status](http://img.shields.io/travis/takecian/SwiftRoutes.svg?style=flat)](https://travis-ci.org/takecian/SwiftRoutes)
[![Version](https://img.shields.io/cocoapods/v/SwiftRoutes.svg?style=flat)](http://cocoapods.org/pods/SwiftRoutes)
[![License](https://img.shields.io/cocoapods/l/SwiftRoutes.svg?style=flat)](http://cocoapods.org/pods/SwiftRoutes)
[![Platform](https://img.shields.io/cocoapods/p/SwiftRoutes.svg?style=flat)](http://cocoapods.org/pods/SwiftRoutes)

A URL Router for iOS, written in Swift 2.2, inspired by  [JLRoutes](https://github.com/joeldev/JLRoutes).

## Requirements

iOS 8.0 or later.

## Installation

### Carthage

SwiftRoutes is compatible with [Carthage](https://github.com/Carthage/Carthage). Add it to your `Cartfile`:

```ruby
github "takecian/SwiftRoutes"
```

### Cocoapods

SwiftRoutes is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftRoutes"
```

## Usage

1. Register route(NSURL) and handler.
2. Call `routeUrl` with NSURL.
3. SwiftRoutes fire a handler that matched.

```
SwiftRoutes.addRoute(NSURL(string: "http://yourdomain.com/users/")!) { (params) -> Bool in
	let viewController = SomeViewController()
	navigationController.pushViewController(viewController, animated: true)
    return true
}

SwiftRoutes.routeUrl(NSURL(string: "http://yourdomain.com/users/")!))
```

### The Parameters Dictionary

SwiftRoutes provides parameters as Dictionary from following data.

- a part of url (Developer can specify name wit prefix `:`)
- Query String

```
SwiftRoutes.addRoute(NSURL(string: "http://yourdomain.com/users/:userid")!) { (params) -> Bool in
	let viewController = SomeViewController()
	let userId = params["userid"]   <- userId is "1234"
	let name = params["name"]   <- name is "testname"
	viewController.userid = userId
	navigationController.pushViewController(viewController, animated: true)
    return true
}

SwiftRoutes.routeUrl(NSURL(string: "http://yourdomain.com/users/1234?name=testname")!))
```

## Author

takecian

## License

SwiftRoutes is available under the MIT license. See the LICENSE file for more info.
