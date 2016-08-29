# SwiftRoutes

[![CI Status](http://img.shields.io/travis/takecian/SwiftRoutes.svg?style=flat)](https://travis-ci.org/takecian/SwiftRoutes)
[![Version](https://img.shields.io/cocoapods/v/SwiftRoutes.svg?style=flat)](http://cocoapods.org/pods/SwiftRoutes)
[![License](https://img.shields.io/cocoapods/l/SwiftRoutes.svg?style=flat)](http://cocoapods.org/pods/SwiftRoutes)
[![Platform](https://img.shields.io/cocoapods/p/SwiftRoutes.svg?style=flat)](http://cocoapods.org/pods/SwiftRoutes)

## Requirements

iOS 8.0 or later.

## Installation

### Carthage

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
SwiftRoutes.addRoute(NSURL(string: "http://yourdomain.com/users/:userid")!) { (params) -> Bool in
	let userId = params["userid"]
	let viewController = SomeViewController()
	viewController.userid = userId
	navigationController.pushViewController(viewController, animated: true)
    return true
}

SwiftRoutes.routeUrl(NSURL(string: "http://yourdomain.com/users/:userid")!))
```

## Author

takecian

## License

SwiftRoutes is available under the MIT license. See the LICENSE file for more info.
