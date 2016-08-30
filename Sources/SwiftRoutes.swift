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
 SwiftRoutes manages NSURL as route pattern and corresponding handler.
 */
public class SwiftRoutes {

    /**
     Array of SwiftRoutes. Each SwiftRoutes is responsible for a specified scheme such as "http://", "myapp://".
     */
    private static var routesControllers = [SwiftRoutes]()

    /**
     Responsible scheme
     */
    private var scheme: String

    /**
     Array of SwiftRoute, each SwiftRoute has routing rule and handler.
     */
    private var routes = [SwiftRoute]()

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
    public class func addRoute(routePattern: NSURL, handler: SwiftRoutesHandler) {
        if routePattern.scheme.characters.count > 0 {
            SwiftRoutes.routesForScheme(routePattern.scheme).addRoute(routePattern, priority: 0, handler: handler)
        } else {
            SwiftRoutes.globalRoutes().addRoute(routePattern, priority: 0, handler: handler)
        }
    }

    /**
     Remove route that matches `routePattern`

     - parameter routePattern: NSURL to be removed from SwiftRoutes.

     */
    public class func removeRoute(routePattern: NSURL) {
        if routePattern.scheme.characters.count > 0 {
            SwiftRoutes.routesForScheme(routePattern.scheme).removeRoute(routePattern)
        } else {
            SwiftRoutes.globalRoutes().removeRoute(routePattern)
        }
    }
    
    /**
     Remove all routes.
     */
    public class func removeAllRoutes() {
        for controller in routesControllers {
            controller.removeAllRoutes()
        }
    }
    
    /**
     Routing url. SwiftRoutes will fire a handler that matches url.
     
     - parameter route: NSURL to be routed.
     - Returns: The results of routing. when handled, return true, when not handled, return false.

     */
    public class func routeUrl(route: NSURL) -> Bool {
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

    /**
     Returns default SwiftRoutes. This instance is used when routePattern does not have scheme.
     */
    private class func globalRoutes() -> SwiftRoutes {
        return SwiftRoutes.routesForScheme(globalScheme)
    }
    
    func addRoute(routePattern: NSURL, priority: Int, handler: SwiftRoutesHandler) {
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
