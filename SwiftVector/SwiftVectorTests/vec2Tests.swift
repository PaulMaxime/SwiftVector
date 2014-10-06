//
//  vec2Tests.swift
//  SwiftVector
//
//  Created by Paul Franceus on 10/5/14.
//  Copyright (c) 2014 SoFIE Studios. All rights reserved.
//

import UIKit
import XCTest

class vec2Tests: XCTestCase {
  let epsilon = 0.000000001

  /// Test that the initializers produce equivalent vectors.
  func testInitPoints() {
    let p1 = CGPoint(x: 1, y: 1)
    let p2 = CGPoint(x: 3, y: 4)

    let v1 = vec2(from:p1, to:p2)
    let v2 = vec2(2, 3)

    XCTAssertEqual(v1, v2)
  }

  /// Test that rotating by radians works.
  func testRotateRadians() {
    let v = vec2(0, 1)
    let rot = v.rotate(radians:0.1)
    XCTAssertEqualWithAccuracy(rot.angle, v.angle + 0.1, epsilon)

    let v1 = vec2(1.5 ,1)

    let v2 = v1.rotate(radians: M_PI_2)
    XCTAssertEqualWithAccuracy(v1.y, -v2.x, epsilon)
    XCTAssertEqualWithAccuracy(v1.x, v2.y, epsilon)
  }

  func testRotateDegrees() {
    let v1 = vec2(2, 3);
    let v2 = v1.rotate(degrees: 90)
    XCTAssertEqualWithAccuracy(v2.angleDegrees, v1.angleDegrees + 90.0, epsilon)
    let v3 = v1.rotate(degrees: 180)
    let v4 = v1.rotate(degrees: 270)
    let v5 = v1.rotate(degrees: 360)

    XCTAssertEqualWithAccuracy(v1.x, v2.y, epsilon)
    XCTAssertEqualWithAccuracy(v1.y, -v2.x, epsilon)
    XCTAssertEqualWithAccuracy(v2.x, v3.y, epsilon)
    XCTAssertEqualWithAccuracy(v2.y, -v3.x, epsilon)
    XCTAssertEqualWithAccuracy(v3.x, v4.y, epsilon)
    XCTAssertEqualWithAccuracy(v3.y, -v4.x, epsilon)
    XCTAssertEqualWithAccuracy(v4.x, v5.y, epsilon)
    XCTAssertEqualWithAccuracy(v4.y, -v5.x, epsilon)
    XCTAssertEqualWithAccuracy(v1.x, v5.x, epsilon)
    XCTAssertEqualWithAccuracy(v1.y, v5.y, epsilon)
  }

  func testScale() {
    let v1 = vec2(4, 5)
    let l1 = v1.length

    let v2 = v1.scale(3.0)
    let l2 = v2.length
    XCTAssertEqualWithAccuracy(l1 * 3.0, l2, epsilon)
  }

  func testNormalize() {
    let v1 = vec2(100, 1000)
    let v2 = v1.normalize()
    XCTAssertEqualWithAccuracy(v2.length, 1.0, epsilon)
    XCTAssertEqualWithAccuracy(v1.angle, v2.angle, epsilon)
  }
}
