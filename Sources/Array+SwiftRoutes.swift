//
//  Array+SwiftRoutes.swift
//  SwiftRoutes
//
//  Created by Fujiki Takeshi on 2016/08/29.
//  Copyright © 2016年 takecian. All rights reserved.
//

import UIKit

extension Array where Element : Equatable {
    mutating func remove(_ object : Iterator.Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}
