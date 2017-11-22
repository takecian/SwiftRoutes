//
//  SwiftRoutes.swift
//  SwiftRoutes
//
//  Created by FUJIKI TAKESHI on 2016/08/27.
//  Copyright © 2016年 takecian. All rights reserved.
//

import UIKit

public typealias SwiftRoutesHandler = ((Dictionary<String, String>) -> Bool)

let globalScheme = "SwiftRoutesGlobalScheme"
let keyAbsoluteString = "absoluteString"

/**
 SwiftRoutes manages URL as route pattern and corresponding handler.
 */
open class SwiftRoutes {

    /**
     Array of SwiftRoutes. Each SwiftRoutes is responsible for a specified scheme such as "http://", "myapp://".
     */
    fileprivate static var routesControllers = [SwiftRoutes]()

    /**
     Responsible scheme
     */
    fileprivate var scheme: String

    /**
     Array of SwiftRoute, each SwiftRoute has routing rule and handler.
     */
    fileprivate var routes = [SwiftRoute]()

    // Create SwiftRoutes with scheme
    init(scheme: String) {
        self.scheme = scheme
    }

    /**
     Add route pattern and handler.
     
     SwiftRoutes is instantiated for each scheme. For example, SwiftRoutes instance for 'http://'. If developer does not specify scheme, SwiftRoutes for `globalRoutes` is instantiated.

     - parameter routePattern: Url to be added.
     - Parameter handler:   Block called when route passed in `routeUrl(_)` matches routePattern.
     */
    open class func addRoute(_ routePattern: URL, handler: @escaping SwiftRoutesHandler) {
        if let scheme = routePattern.scheme, scheme.count > 0 {
            SwiftRoutes.routesForScheme(routePattern.scheme!).addRoute(routePattern, priority: 0, handler: handler)
        } else {
            SwiftRoutes.globalRoutes().addRoute(routePattern, priority: 0, handler: handler)
        }
    }

    /**
     Remove route that matches `routePattern`

     - parameter routePattern: NSURL to be removed from SwiftRoutes.

     */
    open class func removeRoute(_ routePattern: URL) {
        if let scheme = routePattern.scheme, scheme.count > 0 {
            SwiftRoutes.routesForScheme(routePattern.scheme!).removeRoute(routePattern)
        } else {
            SwiftRoutes.globalRoutes().removeRoute(routePattern)
        }
    }
    
    /**
     Remove all routes.
     */
    open class func removeAllRoutes() {
        for controller in routesControllers {
            controller.removeAllRoutes()
        }
    }
    
    /**
     Routing url. SwiftRoutes will fire a handler that matches url.
     
     - parameter route: NSURL to be routed.
     - Returns: The results of routing. when handled, return true, when not handled, return false.

     */
    open class func routeUrl(_ route: URL) -> Bool {
        var handled = false
        if let scheme = route.scheme, scheme.count > 0 {
            let routes = SwiftRoutes.routesForScheme(scheme)
            handled = routes.routeUrl(route)
        }
        
        if !handled {
            let routes = SwiftRoutes.globalRoutes()
            handled = routes.routeUrl(route)
        }
        
        return handled
    }

    fileprivate class func routesForScheme(_ scheme: String) -> SwiftRoutes {
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

    /**
     Returns default SwiftRoutes. This instance is used when routePattern does not have scheme.
     */
    fileprivate class func globalRoutes() -> SwiftRoutes {
        return SwiftRoutes.routesForScheme(globalScheme)
    }
    
    func addRoute(_ routePattern: URL, priority: Int, handler: @escaping SwiftRoutesHandler) {
        let route = SwiftRoute(pattern: routePattern, priority: priority, handler: handler)
        routes.append(route)
    }
    
    func removeRoute(_ routePattern: URL) {
        let removeTargets = routes.filter( { r -> Bool in
            routePattern == r.routePattern as URL
        })
        
        for target in removeTargets {
            routes.remove(target)
        }
    }

    func removeAllRoutes() {
        routes.removeAll()
    }

    func routeUrl(_ url: URL) -> Bool {
        #if DEBUG
        print("trying to route \(url.absoluteString), scheme = \(scheme)")
        #endif

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

        #if DEBUG
        if didRoute {
            print("matched, scheme = \(scheme), \(url.absoluteString)")
        } else {
            print("not matched, scheme = \(scheme), \(url.absoluteString)")
        }
        #endif
        
        return didRoute
    }

}
