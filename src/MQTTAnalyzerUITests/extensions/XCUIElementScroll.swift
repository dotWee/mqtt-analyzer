//
//  XCUIElementScroll.swift
//  MQTTAnalyzerUITests
//
//  Created by Philipp Arndt on 2020-05-02.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//
// https://stackoverflow.com/questions/32646539/scroll-until-element-is-visible-ios-ui-automation-with-xcode7
import XCTest

enum TestSwipeDirections {
    case up
    case down
    case left
    case right
}

private let min = 0.05
private let mid = 0.25
private let max = 0.5

private let leftPoint = CGVector(dx: min, dy: mid)
private let rightPoint = CGVector(dx: max, dy: mid)
private let topPoint = CGVector(dx: mid, dy: min)
private let bottomPoint = CGVector(dx: mid, dy: max)

extension TestSwipeDirections {
    var vector: (begin: CGVector, end: CGVector) {
        switch self {
        case .up:
            return (begin: bottomPoint,
                    end:   topPoint)
        case .down:
            return (begin: topPoint,
                    end:   bottomPoint)
        case .left:
            return (begin: rightPoint,
                    end:   leftPoint)
        case .right:
            return (begin: leftPoint,
                    end:   rightPoint)
        }
    }
}

extension XCUIElement {
    func isVisible() -> Bool {
        if !self.exists || !self.isHittable || self.frame.isEmpty {
            return false
        }

        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}

extension XCUIElement {
    @discardableResult func swipeOnIt(_ direction: TestSwipeDirections,
                                      swipeLimit: Int = 6,
                                      swipeDuration: TimeInterval = 1.0,
                                      until: () -> Bool) -> Bool {
        XCTAssert(exists)

        let begining = coordinate(withNormalizedOffset: direction.vector.begin)
        let ending = coordinate(withNormalizedOffset: direction.vector.end)

        var swipesRemaining = swipeLimit
        while !until() && swipesRemaining > 0 {
            begining.press(forDuration: swipeDuration, thenDragTo: ending)
            swipesRemaining -= 1
        }
        return !until()
    }

    @discardableResult func swipeOnIt(_ direction: TestSwipeDirections,
                                      swipeLimit: Int = 6,
                                      swipeDuration: TimeInterval = 1.0,
                                      untilHittable element: XCUIElement) -> Bool {
        return swipeOnIt(direction, swipeLimit: swipeLimit, swipeDuration: swipeDuration) { element.isHittable }
    }

    @discardableResult func swipeOnIt(_ direction: TestSwipeDirections,
                                      swipeLimit: Int = 6,
                                      swipeDuration: TimeInterval = 1.0,
                                      untilExists element: XCUIElement) -> Bool {
        return swipeOnIt(direction, swipeLimit: swipeLimit, swipeDuration: swipeDuration) { element.exists }
    }
	
    @discardableResult func swipeOnIt(_ direction: TestSwipeDirections,
                                      swipeLimit: Int = 6,
                                      swipeDuration: TimeInterval = 1.0,
                                      untilVisible element: XCUIElement) -> Bool {
        return swipeOnIt(direction, swipeLimit: swipeLimit, swipeDuration: swipeDuration) { element.isVisible() }
    }
}

extension XCUIElement {
    func scrollToElement(element: XCUIElement) {
        while !element.isVisible() {
            swipeUp()
        }
    }
}
