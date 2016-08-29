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
 SwiftRoutes manages NSURL and corresponding handler.
 */
public class SwiftRoutes {

    private static var routesControllers = [SwiftRoutes]()

    private var handlers = Dictionary<String, SwiftRoutesHandler>()
    private var scheme: String
    private var routes = [SwiftRoute]()
    
    init(scheme: String) {
        self.scheme = scheme
    }
    
    public class func addRoute(routePattern: NSURL, handler: SwiftRoutesHandler) {
        if routePattern.scheme.characters.count > 0 {
            SwiftRoutes.routesForScheme(routePattern.scheme).addRoute(routePattern, priority: 0, handler: handler)
        } else {
            SwiftRoutes.globalRoutes().addRoute(routePattern, priority: 0, handler: handler)
        }
    }

    public class func removeRoute(routePattern: NSURL) {
        if routePattern.scheme.characters.count > 0 {
            SwiftRoutes.routesForScheme(routePattern.scheme).removeRoute(routePattern)
        } else {
            SwiftRoutes.globalRoutes().removeRoute(routePattern)
        }
    }
    
    public class func removeAllRoutes() {
        for controller in routesControllers {
            controller.removeAllRoutes()
        }
    }
    
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
    
    private class func globalRoutes() -> SwiftRoutes {
        return SwiftRoutes.routesForScheme(globalScheme)
    }
    
    public func addRoute(routePattern: NSURL, priority: Int, handler: SwiftRoutesHandler) {
        let route = SwiftRoute(pattern: routePattern, priority: priority, handler: handler)
        routes.append(route)
    }
    
    public func removeRoute(routePattern: NSURL) {
        let removeTargets = routes.filter( { r -> Bool in
            routePattern == r.routePattern
        })
        
        for target in removeTargets {
            routes.remove(target)
        }
    }

    public func removeAllRoutes() {
        routes.removeAll()
    }

    public func routeUrl(url: NSURL) -> Bool {
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
