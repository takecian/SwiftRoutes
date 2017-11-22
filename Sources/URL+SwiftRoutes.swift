//
//  NSURL+SwiftRoutes.swift
//  SwiftRoutes
//
//  Created by Fujiki Takeshi on 2016/08/29.
//  Copyright © 2016年 takecian. All rights reserved.
//

import UIKit

extension URL {
    var routeParams: [String] {
        get {
            if let scheme = self.scheme {
                return self.absoluteString.replacingOccurrences(of: "\(scheme)://", with: "", options: [], range: nil).components(separatedBy: "/").filter({ (s) -> Bool in
                    s.count > 0
                })
            } else {
                return self.absoluteString.components(separatedBy: "/").filter({ (s) -> Bool in
                    s.count > 0
                })
            }

        }
    }
}
