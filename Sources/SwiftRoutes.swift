//
//  SwiftRoutes.swift
//  SwiftRoutes
//
//  Created by FUJIKI TAKESHI on 2016/08/27.
//  Copyright © 2016年 takecian. All rights reserved.
//

import UIKit

typealias RouteHandler = ((Dictionary<String, String>) -> Bool)

let globalScheme = "SwiftRoutesGlobalScheme"
let keyAbsoluteString = "absoluteString"

public class SwiftRoutes {

    private static var routesControllers = [SwiftRoutes]()

    private var handlers = Dictionary<String, RouteHandler>()
    private var scheme: String
    private var routes = [SwiftRoute]()
    
    init(scheme: String) {
        self.scheme = scheme
    }
    
    class func addRoute(routePattern: NSURL, handler: RouteHandler) {
        if routePattern.scheme.characters.count > 0 {
            SwiftRoutes.routesForScheme(routePattern.scheme).addRoute(routePattern, priority: 0, handler: handler)
        } else {
            SwiftRoutes.globalRoutes().addRoute(routePattern, priority: 0, handler: handler)
        }
    }

    class func removeRoute(routePattern: NSURL) {
        if routePattern.scheme.characters.count > 0 {
            SwiftRoutes.routesForScheme(routePattern.scheme).removeRoute(routePattern)
        } else {
            SwiftRoutes.globalRoutes().removeRoute(routePattern)
        }
    }
    
    class func removeAllRoutes() {
        for controller in routesControllers {
            controller.removeAllRoutes()
        }
    }
    
    class func routeUrl(route: NSURL) -> Bool {
        var handled = false
        if route.scheme.characters.count > 0 {
            let routes = SwiftRoutes.routesForScheme(route.scheme)
            handled = routes.routeUrl(route)
        }
        
        if !handled {
            let routes = SwiftRoutes.globalRoutes()
            handled = routes.routeUrl(route)
        }
        
        return handled
    }

    private class func routesForScheme(scheme: String) -> SwiftRoutes {
        if let route = SwiftRoutes.routesControllers.filter({ (r) -> Bool in
            r.scheme == scheme
        }).first {
            return route
        } else {
            let route = SwiftRoutes(scheme: scheme)
            SwiftRoutes.routesControllers.append(route)
            return route
        }
    }
    
    private class func globalRoutes() -> SwiftRoutes {
        return SwiftRoutes.routesForScheme(globalScheme)
    }
    
    func addRoute(routePattern: NSURL, priority: Int, handler: RouteHandler) {
        let route = SwiftRoute(pattern: routePattern, priority: priority, handler: handler)
        routes.append(route)
    }
    
    func removeRoute(routePattern: NSURL) {
        let removeTargets = routes.filter( { r -> Bool in
            routePattern == r.routePattern
        })
        
        for target in removeTargets {
            routes.remove(target)
        }
    }

    func removeAllRoutes() {
        routes.removeAll()
    }

    func routeUrl(url: NSURL) -> Bool {
        print("trying to route \(url.absoluteString), scheme = \(scheme)")
        
        var didRoute = false
        
        for route in routes {
            
            let matched = route.isMatchUrl(url)
            
            if matched.isMatched {
                didRoute = route.handler(matched.params)
            }

            if didRoute {
                break
            }
        }
        
        if didRoute {
            print("matched, scheme = \(scheme), \(url.absoluteString)")
        } else {
            print("not matched, scheme = \(scheme), \(url.absoluteString)")
        }
        
        return didRoute
    }

}

class SwiftRoute: Equatable {
    private let routePattern: NSURL
    private var handler: RouteHandler
    private var priority: Int
    
    init(pattern: NSURL, priority: Int, handler: RouteHandler) {
        self.routePattern = pattern
        self.priority = priority
        self.handler = handler
    }
    
    func isMatchUrl(url: NSURL) -> (isMatched: Bool, params: Dictionary<String, String>) {
        var isMatched = true
        var params = Dictionary<String, String>()
        
        params[keyAbsoluteString] = url.absoluteString

        guard routePattern.routeParames.count == url.routeParames.count else {
            return (false, params)
        }
        
        var iterator = zip(routePattern.routeParames, url.routeParames).generate()
        while let i = iterator.next() {
            let key = i.0.stringByReplacingOccurrencesOfString(":", withString: "", options: [], range: nil)
            let value = getValue(i.1)

            if i.0.containsString(":") {
                params[key] = value
            } else {
                if key != value {
                    isMatched = false
                    break
                }
            }
        }

        if let queryItems = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)?.queryItems {
            for item in queryItems {
                params[item.name] = item.value
            }
        }

        return (isMatched, params)
    }
    
    private func getValue(original: String) -> String {
        var string = original
        if let dotRange = string.rangeOfString("?") {
            string.removeRange(dotRange.startIndex..<string.endIndex)
        }
        return string
    }
    
}

func ==(lhs: SwiftRoute, rhs: SwiftRoute) -> Bool {
    return lhs.routePattern == rhs.routePattern
}

extension NSURL {
    var routeParames: [String] {
        get {
            return self.absoluteString.stringByReplacingOccurrencesOfString("\(self.scheme)://", withString: "", options: [], range: nil).componentsSeparatedByString("/").filter({ (s) -> Bool in
                s.characters.count > 0
            })

        }
    }
}

extension Array where Element : Equatable {
    mutating func remove(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}
