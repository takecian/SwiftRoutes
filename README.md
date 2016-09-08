# SwiftRoutes

[![CI Status](http://img.shields.io/travis/takecian/SwiftRoutes.svg?style=flat)](https://travis-ci.org/takecian/SwiftRoutes)
[![Version](https://img.shields.io/cocoapods/v/SwiftRoutes.svg?style=flat)](http://cocoapods.org/pods/SwiftRoutes)
[![License](https://img.shields.io/cocoapods/l/SwiftRoutes.svg?style=flat)](http://cocoapods.org/pods/SwiftRoutes)
[![Platform](https://img.shields.io/cocoapods/p/SwiftRoutes.svg?style=flat)](http://cocoapods.org/pods/SwiftRoutes)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A URL Router for iOS, written in Swift 3, inspired by  [JLRoutes](https://github.com/joeldev/JLRoutes).

## Requirements

iOS 8.0 or later.

## Installation

### Carthage

SwiftRoutes is compatible with [Carthage](https://github.com/Carthage/Carthage). Add it to your `Cartfile`:

#### Swift 3

```ruby
github "takecian/SwiftRoutes" "0.2.0"
```

#### Swift 2.2

```ruby
github "takecian/SwiftRoutes" "0.1.3"
```

### Cocoapods

SwiftRoutes is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

#### Swift 3

```ruby
pod "SwiftRoutes", "0.2.0"
```

#### Swift 2.2

```ruby
pod "SwiftRoutes", "0.1.3"
```

# Usage

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

## The Parameters Dictionary

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

# Practical example - Use SwiftRoutes for UIApplicationShortcutItem

This example shows how to perform `UIApplicationShortcutItem` using SwiftRoutes.

## 1. Define UIApplicationShortcutItem in info.plist

Here, two UIApplicationShortcutItems are defined. ShortcutItemType has url to be handled.

```
	...
	<key>UIApplicationShortcutItems</key>
	<array>
		<dict>
			<key>UIApplicationShortcutItemIconFile</key>
			<string>Home</string>
			<key>UIApplicationShortcutItemTitle</key>
			<string>Home</string>
			<key>UIApplicationShortcutItemType</key>
			<string>/home</string>
			<key>UIApplicationShortcutItemUserInfo</key>
			<dict>
				<key>key1</key>
				<string>value1</string>
			</dict>
		</dict>
		<dict>
			<key>UIApplicationShortcutItemIconFile</key>
			<string>Setting</string>
			<key>UIApplicationShortcutItemTitle</key>
			<string>Setting</string>
			<key>UIApplicationShortcutItemType</key>
			<string>/setting</string>
			<key>UIApplicationShortcutItemUserInfo</key>
			<dict>
				<key>key1</key>
				<string>value1</string>
			</dict>
		</dict>
	</array>
	...
```

## 2. Define Route Handler

Define route and handler at app launches.

```AppDelegate.swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    	// Define routing
 		SwiftRoutes.addRoute(NSURL(string: "/home")!) { (params) -> Bool in
            self.window.rootViewController.moveToHome()  // pseudo code
            return true
        }

        SwiftRoutes.addRoute(NSURL(string: "/setting")!) { (params) -> Bool in
            self.window.rootViewController.moveSetting() // pseudo code
            return true
        }
    }
}
```

## 3. Handle routes

Just put `SwiftRoutes.routeUrl(_)` in `application(application:performActionForShortcutItem:completionHandler)` and pass return value of `SwiftRoutes.routeUrl(_)` into `completionHandler(_)`.

```
@available(iOS 9.0, *)
func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        let val = SwiftRoutes.routeUrl(NSURL(string: shortcutItem.type)!)
        completionHandler(val)
}
```

## Author

takecian

## License

SwiftRoutes is available under the MIT license. See the LICENSE file for more info.
