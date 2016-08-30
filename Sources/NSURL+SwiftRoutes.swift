//
//  NSURL+SwiftRoutes.swift
//  SwiftRoutes
//
//  Created by Fujiki Takeshi on 2016/08/29.
//  Copyright © 2016年 takecian. All rights reserved.
//

import UIKit

extension NSURL {
    var routeParams: [String] {
        get {
            return self.absoluteString.stringByReplacingOccurrencesOfString("\(self.scheme)://", withString: "", options: [], range: nil).componentsSeparatedByString("/").filter({ (s) -> Bool in
                s.characters.count > 0
            })

        }
    }
}
