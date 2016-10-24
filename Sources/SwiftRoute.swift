//
//  SwiftRoute.swift
//  SwiftRoutes
//
//  Created by Fujiki Takeshi on 2016/08/29.
//  Copyright © 2016年 takecian. All rights reserved.
//

import UIKit

/**
 SwiftRoute store URL and corresponding handler and proiroty.
 */
class SwiftRoute: Equatable {
    let routePattern: URL
    var handler: SwiftRoutesHandler
    var priority: Int

    init(pattern: URL, priority: Int, handler: @escaping SwiftRoutesHandler) {
        self.routePattern = pattern
        self.priority = priority
        self.handler = handler
    }

    func isMatchUrl(_ url: URL) -> (isMatched: Bool, params: Dictionary<String, String>) {
        var isMatched = true
        var params = Dictionary<String, String>()

        params[keyAbsoluteString] = url.absoluteString

        guard routePattern.routeParams.count == url.routeParams.count else {
            return (false, params)
        }

        var iterator = zip(routePattern.routeParams, url.routeParams).makeIterator()
        while let i = iterator.next() {
            let key = i.0.replacingOccurrences(of: ":", with: "", options: [], range: nil)
            let value = getValue(i.1)

            if i.0.contains(":") {
                params[key] = value
            } else {
                if key != value {
                    isMatched = false
                    break
                }
            }
        }

        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
            for item in queryItems {
                params[item.name] = item.value
            }
        }

        return (isMatched, params)
    }

    fileprivate func getValue(_ original: String) -> String {
        var string = original
        if let dotRange = string.range(of: "?") {
            string.removeSubrange(dotRange.lowerBound..<string.endIndex)
        }
        return string
    }
}

func ==(lhs: SwiftRoute, rhs: SwiftRoute) -> Bool {
    return lhs.routePattern == rhs.routePattern
}
