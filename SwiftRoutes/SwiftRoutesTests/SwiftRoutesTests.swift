//
//  SwiftRoutesTests.swift
//  SwiftRoutesTests
//
//  Created by FUJIKI TAKESHI on 2016/08/27.
//  Copyright © 2016年 takecian. All rights reserved.
//

import XCTest
@testable import SwiftRoutes

class SwiftRoutesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        SwiftRoutes.addRoute(NSURL(string: "http://abc/:key/aaa")!) { (params) -> Bool in
            print("abc called, \(params)")
            return true
        }

        SwiftRoutes.addRoute(NSURL(string: "/search")!) { (params) -> Bool in
            print("search called, \(params)")
            return true
        }

//        SwiftRoutes.routeUrl(NSURL(string: "http://abc/qqq/aaa?test=true")!)
        SwiftRoutes.routeUrl(NSURL(string: "/search?keyword=aaaa")!)
        
    }
    
}
