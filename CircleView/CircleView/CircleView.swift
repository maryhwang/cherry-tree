//
//  CircleView.swift
//  Timer
//
//  Created by Mary Wang on 1/14/16.
//

import UIKit

// Add an extension to UIColor to generate a random color
extension UIColor {
    class func randomColor() -> UIColor {
        let redValue: CGFloat = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        let greenValue: CGFloat = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        let blueValue: CGFloat = CGFloat(arc4random()) / CGFloat(UINT32_MAX)

        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
}

extension CGRect {
    init(center: CGPoint, var maxSide: UInt32) {
        maxSide = max(maxSide, 10)
        let sideLength = CGFloat(arc4random_uniform(maxSide) + 1)

        size = CGSize(width: sideLength, height: sideLength)
        origin = CGPoint(x: center.x - sideLength / 2, y: center.y - sideLength / 2)
    }
}

class Circle {
    var color = UIColor.randomColor()
    let path: UIBezierPath

    init(rect: CGRect) {
        path = UIBezierPath(ovalInRect: rect)
    }

    func draw() {
        color.set()
        path.fill()
    }
}

class CircleView: UIView {

    var circleList: [Circle] = []

    func commonInit() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        self.addGestureRecognizer(tapRecognizer)

        // Adding additional gesture recognizers to change color on swipe

        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        self.addGestureRecognizer(rightSwipeRecognizer)

        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        leftSwipeRecognizer.direction = .Left
        self.addGestureRecognizer(leftSwipeRecognizer)

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    func handleTap(sender: UITapGestureRecognizer) {
        let tapLocation = sender.locationInView(self)
        circleList.append(Circle(rect: CGRect(center: tapLocation, maxSide: 100)))
        self.setNeedsDisplay()
    }

    func handleSwipe(sender: UISwipeGestureRecognizer) {

        for circle in circleList {
            circle.color = UIColor.randomColor()
        }
        self.setNeedsDisplay()
    }

    override func drawRect(rect: CGRect) {

        for circle in circleList {
            circle.draw()
        }

    }
}
