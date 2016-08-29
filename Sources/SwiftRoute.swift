//
//  SwiftRoute.swift
//  SwiftRoutes
//
//  Created by Fujiki Takeshi on 2016/08/29.
//  Copyright © 2016年 takecian. All rights reserved.
//

import UIKit

/**
 SwiftRoute store NSURL and corresponding handler and proiroty.
 */
class SwiftRoute: Equatable {
    let routePattern: NSURL
    var handler: SwiftRoutesHandler
    var priority: Int

    init(pattern: NSURL, priority: Int, handler: SwiftRoutesHandler) {
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
