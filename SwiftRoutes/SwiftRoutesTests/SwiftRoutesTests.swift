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
    }

    override func tearDown() {
        super.tearDown()
        SwiftRoutes.removeAllRoutes()
    }

    func testExampleWithParams() {
        var abcRouteHandled = false
        let testUrl = "http://abc/qqq/aaa?test=aaaaaaa&hatena=bookmark"
        
        SwiftRoutes.addRoute(NSURL(string: "http://abc/:key/aaa")!) { (params) -> Bool in
            abcRouteHandled = true
            XCTAssertTrue(params["absoluteString"] == testUrl)
            XCTAssertTrue(params["key"] == "qqq")

            XCTAssertTrue(params["test"] == "aaaaaaa")
            XCTAssertTrue(params["hatena"] == "bookmark")
            return true
        }

        XCTAssertTrue(!abcRouteHandled, "abcRouteHandled handled")
        XCTAssertTrue(SwiftRoutes.routeUrl(NSURL(string: testUrl)!), "not handled")
        XCTAssertTrue(abcRouteHandled, "abcRouteHandled not handled")
    }

    func testWithoutSchemeForHttp() {
        var httpRouteHandled = false
        SwiftRoutes.addRoute(NSURL(string: "/abc/:key/aaa")!) { (params) -> Bool in
            httpRouteHandled = true
            return true
        }

        XCTAssertTrue(!httpRouteHandled, "abcRouteHandled handled")
        XCTAssertTrue(SwiftRoutes.routeUrl(NSURL(string: "http://abc/qqq/aaa?test=true")!), "not handled")
        XCTAssertTrue(httpRouteHandled, "abcRouteHandled not handled")
    }

    func testWithoutSchemeForCustom() {
        var customRouteHandled = false
        SwiftRoutes.addRoute(NSURL(string: "/abc/:key/aaa")!) { (params) -> Bool in
            customRouteHandled = true
            return true
        }

        XCTAssertTrue(!customRouteHandled, "abcRouteHandled handled")
        XCTAssertTrue(SwiftRoutes.routeUrl(NSURL(string: "myapp://abc/qqq/aaa?test=true")!), "not handled")
        XCTAssertTrue(customRouteHandled, "abcRouteHandled not handled")
    }

    func testWitDifferentScheme() {
        var customAbcRouteHandled = false
        SwiftRoutes.addRoute(NSURL(string: "http://abc/:key/aaa")!) { (params) -> Bool in
            customAbcRouteHandled = true
            return true
        }

        XCTAssertTrue(!SwiftRoutes.routeUrl(NSURL(string: "myapp://abc/qqq/aaa?test=true")!), "not handled")
        XCTAssertTrue(!customAbcRouteHandled, "abcRouteHandled not handled")
    }


}
