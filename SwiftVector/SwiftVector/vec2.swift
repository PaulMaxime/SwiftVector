//
//  vec2.swift
//  SwiftVector
//
//  Created by Paul Franceus on 10/5/14.
//  Copyright (c) 2014 SoFIE Studios. All rights reserved.
//

import UIKit

/// 2 Dimensional vector structure with simple vector operations. Operations that manipulate the
/// vector return a new vector.
public struct vec2: Equatable, CustomStringConvertible {
  public let x: Double
  public let y: Double

  // For purposes of comparisons and scaling operations, any magnitude less than this value is
  // considered to be 0. Note: it's not a good idea to use this value directly when comparing
  // (e.g. fabs(a - b) < EPSILON). See http://www.cygnus-software.com/papers/comparingfloats/comparingfloats.htm
  // for more info.
  internal let EPSILON = 1.0e-14;

  public var asCGVector: CGVector {
    get {
      return CGVector(dx: x, dy: y)
    }
  }

  public var length: Double {
    get {
      return sqrt(x*x + y*y)
    }
  }

  public var angle: Double {
    return atan2(y, x)
  }

  public var angleDegrees: Double {
    return self.angle * 180 / M_PI
  }

  public var description: String {
    return "(\(x),\(y))"
  }

  /// Initialize the vector with a pair of doubles
  ///
  ///  - parameter x: The x value
  ///  - parameter y: The y value
  ///
  public init(_ x: Double, _ y:Double) {
    self.x = x;
    self.y = y;
  }

  /// Initialize the vector with a pair of CGFloat
  ///
  ///  - parameter x: The x value
  ///  - parameter y: The y value
  ///
  public init(_ x:CGFloat, _ y:CGFloat) {
    self.x = Double(x);
    self.y = Double(y);
  }

  /// Initialize a vector with a single CGPoint.
  ///
  /// - parameter point: the point
  ///
  public init(point p:CGPoint) {
    x = Double(p.x)
    y = Double(p.y)
  }

  /// Create a vector which represents the offset between two points. The magnitude
  /// of the vector will be the distance between the points and the direction will
  /// be the direction from the first to the second.
  ///
  ///  - parameter from: The starting point
  ///  - parameter to:   The end point
  ///
  public init(from p1: CGPoint, to p2: CGPoint) {
    x = Double(p2.x - p1.x)
    y = Double(p2.y - p1.y)
  }

  /// Create a vector from a CGVector.
  ///
  /// - parameter vector: the CGVector
  ///
  public init(vector v:CGVector) {
    self.x = Double(v.dx)
    self.y = Double(v.dy)
  }

  /// Rotate the vector by radians.
  ///
  ///  - parameter radians: The number of radians to rotate.
  ///  - returns: A new vector that is rotated.
  public func rotate(radians r: Double) -> vec2 {
    let x1 = x * cos(r) - y * sin(r)
    let y1 = x * sin(r) + y * cos(r)
    return vec2(x1, y1)
  }

  /// Rotate the vector by degrees.
  ///
  ///  - parameter degrees: The number of degrees to rotate.
  ///  - returns: A new vector that is rotated.
  public func rotate(degrees d: Double) -> vec2 {
    return rotate(radians:d * M_PI / 180)
  }

  /// Multiply the vector's length by a constant scale factor.
  ///
  /// - parameter factor: The scale factor
  /// - returns: A new vector that is scaled by the factor.
  public func scale(factor: Double) -> vec2 {
    return vec2(x * factor, y * factor)
  }

  /// Return a vector that has a unit length, but in the same direction as the original.
  ///
  ///  - returns: A normalized vector
  public func normalize() -> vec2 {
    let m = self.length;
    if m < EPSILON {
      return vec2(0.0, 0.0);
    } else {
      return scale(1/m);
    }
  }
}

// MARK: Operator overloads

public func ==(lhs: vec2, rhs: vec2) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y
}

/// MARK: Extension for CGPoint that use vec2.

public extension CGPoint {

  /// Make a new point that is translated by the vector.
  ///
  /// - parameter v: A translation vector
  /// - returns: A new point that is translated.
  public func translate(v:vec2) -> CGPoint {
    return CGPoint(x: self.x + CGFloat(v.x), y: self.y + CGFloat(v.y))
  }
}

/// MARK: Extension for UIBezierPath that uses vec2.

public extension UIBezierPath {

  /// Convenience initializer that makes a box that surrounds a line with a specified width
  /// that is evenly distributed on either side of the original line.
  ///
  /// - parameter start: The starting point of the line.
  /// - parameter end:   The ending point of the line.
  /// - parameter width: The width of the box.
  ///
  public convenience init(boxFromPoint start:CGPoint, toPoint end:CGPoint, width:CGFloat) {
    self.init()
    // If the line has no length, there's no box.
    if start == end {
      return
    }
    // Make 2 vectors. One is +90 degrees from the original line and one is -90 degrees
    // from the line. Make the vector's length half the width of the desired box.
    let w = Double(width / 2.0)
    let v = vec2(from: start, to: end).normalize().rotate(degrees: 90.0).scale(w)
    let v2 = v.rotate(degrees: 180.0)

    // Make 4 points by translating the end points in the +90 and -90 directtions.
    let p1 = start.translate(v)
    let p2 = start.translate(v2)
    let p3 = end.translate(v)
    let p4 = end.translate(v2)

    // Build the path.
    self.moveToPoint(p1)
    self.addLineToPoint(p3)
    self.addLineToPoint(p4)
    self.addLineToPoint(p2)
    self.closePath()
  }

  /// Convenience initializer that makes a box centered on a point at a specified angle and size.
  /// The angle is projected along the width of the box.
  ///
  /// - parameter center: The center of the box.
  /// - parameter angle:  The angle of the box, in degrees
  /// - parameter size:   The size of the box.
  ///
  public convenience init(boxWithCenter center:CGPoint, angle:Double, size:CGSize) {
    self.init()
    let dx = size.width / 2.0
    let dy = size.height / 2.0

    // Make 4 points for the box
    let v1 = vec2(dx, dy).rotate(degrees: angle)
    let p1 = center.translate(v1)
    let v2 = vec2(dx,-dy).rotate(degrees: angle)
    let p2 = center.translate(v2)
    let v3 = vec2(-dx, dy).rotate(degrees: angle)
    let p3 = center.translate(v3)
    let v4 = vec2(-dx, -dy).rotate(degrees: angle)
    let p4 = center.translate(v4)

    // Build the path.
    self.moveToPoint(p1)
    self.addLineToPoint(p3)
    self.addLineToPoint(p4)
    self.addLineToPoint(p2)
    self.closePath()
  }
}
