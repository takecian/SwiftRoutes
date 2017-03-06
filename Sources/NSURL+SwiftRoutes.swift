//
//  NSURL+SwiftRoutes.swift
//  SwiftRoutes
//
//  Created by Fujiki Takeshi on 2016/08/29.
//  Copyright © 2016年 takecian. All rights reserved.
//

import UIKit

extension URL {

    func adjustComponents(_ components: [String]) -> [String] {
        var adjustedComponents = [String]()

        components.forEach { (string) in
            if string.substring(from: string.index(string.startIndex, offsetBy: 1)).contains(":") {
                let components = string.components(separatedBy: ":")
                if string.hasPrefix(":") {
                    adjustedComponents.append(contentsOf: components.filter{ $0.characters.count > 0 }.flatMap({ ":"+$0 }))
                } else if components.count == 2 {
                    adjustedComponents.append(contentsOf: [components[0], ":"+components[1]])
                }
            } else {
                adjustedComponents.append(string)
            }
        }

        return adjustedComponents
    }

    var routeParams: [String] {
        get {
            if let scheme = self.scheme {
                return adjustComponents(self.absoluteString.replacingOccurrences(of: "\(scheme)://", with: "", options: [], range: nil).components(separatedBy: "/").filter({ (s) -> Bool in
                    s.characters.count > 0
                }))
            } else {
                return adjustComponents(self.absoluteString.components(separatedBy: "/").filter({ (s) -> Bool in
                    s.characters.count > 0
                }))
            }

        }
    }

    var urlParams: [String] {
        get {
            let charSet = CharacterSet(charactersIn: "/?")
            if let scheme = self.scheme {
                return self.absoluteString.replacingOccurrences(of: "\(scheme)://", with: "", options: [], range: nil).components(separatedBy: charSet).filter({ (s) -> Bool in
                    s.characters.count > 0
                })
            } else {
                return self.absoluteString.components(separatedBy: charSet).filter({ (s) -> Bool in
                    s.characters.count > 0
                })
            }
            
        }
    }
}
