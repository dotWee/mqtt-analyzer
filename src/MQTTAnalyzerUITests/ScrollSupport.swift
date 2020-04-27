//
//  ScrollSupport.swift
//  MQTTAnalyzerUITests
//
//  Created by Philipp Arndt on 2020-04-26.
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

fileprivate let min = 0.05
fileprivate let mid = 0.5
fileprivate let max = 0.95

fileprivate let leftPoint = CGVector(dx: min, dy: mid)
fileprivate let rightPoint = CGVector(dx: max, dy: mid)
fileprivate let topPoint = CGVector(dx: mid, dy: min)
fileprivate let bottomPoint = CGVector(dx: mid, dy: max)

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
}

extension XCUIElement {
    func isVisible() -> Bool {
        if !self.exists || !self.isHittable || self.frame.isEmpty {
            return false
        }

        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}

extension XCTestCase {
    func scrollToElement(_ element: XCUIElement) {
        while !element.isVisible() {
            let app = XCUIApplication()
            let startCoord = app.tables.element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            let endCoord = startCoord.withOffset(CGVector(dx: 0.0, dy: -262))
            startCoord.press(forDuration: 0.01, thenDragTo: endCoord)
        }
    }
}

extension XCUIElement {
    func clearText(andReplaceWith newText: String? = nil) {
        tap()
		
		if let v = value as? String {
			if !v.isEmpty {
				press(forDuration: 1.0)
				var select = XCUIApplication().menuItems["Select All"]

				if !select.exists {
					select = XCUIApplication().menuItems["Select"]
				}
				//For empty fields there will be no "Select All", so we need to check
				if select.waitForExistence(timeout: 0.5), select.exists {
					select.tap()
					typeText(String(XCUIKeyboardKey.delete.rawValue))
				} else {
					tap()
				}
			}
		}

        if let newVal = newText {
            typeText(newVal)
        }
    }
}
