//
//  DotView.swift
//  gdo
//
//  Created by Jerry Yu on 3/16/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import UIKit

private let defautDuration: TimeInterval = 0.35

class DotLayer: CAShapeLayer {

    var isHollow = true

    override func layoutSublayers() {
        super.layoutSublayers()

        updateStyle()
    }

    func updateStyle() {
        // Bounds
        let hollowFrame = CGRect.zero
        let filledFrame = CGRect(origin: .zero, size: CGSize(width: 8, height: 8))
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.duration = defautDuration
        animation.fromValue = NSValue(cgRect: isHollow ? hollowFrame : filledFrame)
        self.bounds = isHollow ? filledFrame : hollowFrame
        animation.toValue = NSValue(cgRect: self.bounds)
        self.add(animation, forKey: animation.keyPath!)

        // cornerRadius
        let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.duration = duration
        cornerRadiusAnimation.fromValue = self.cornerRadius
        self.cornerRadius = CGFloat(isHollow ? filledFrame.midX : 0)
        cornerRadiusAnimation.toValue = self.cornerRadius
        self.add(cornerRadiusAnimation, forKey: cornerRadiusAnimation.keyPath!)
    }
}

class DotView: UIView {

    enum Style {
        case open
        case closed
    }

    override var intrinsicContentSize: CGSize {
        let s: CGFloat = 12
        return CGSize(width: s, height: s)
    }

    var style = Style.closed {
        didSet {
            guard style != oldValue else {
                return
            }

            myLayer.isHollow = (style != .closed)
            myLayer.updateStyle()

            // Change outer ring color
            let animation = CABasicAnimation(keyPath: "backgroundColor")
            animation.duration = defautDuration
            animation.fromValue = layer.backgroundColor
            layer.backgroundColor = (style == .closed) ? closedColor.cgColor : openColor.cgColor
            animation.toValue = layer.backgroundColor
            layer.add(animation, forKey: animation.keyPath!)
        }
    }

    var closedColor = UIColor.green
    var openColor = UIColor.primaryAppColor
    var hollowColor = UIColor.white
    var myLayer = DotLayer()

    init() {
        super.init(frame: .zero)

        layer.backgroundColor = closedColor.cgColor

        myLayer.backgroundColor = hollowColor.cgColor
        layer.addSublayer(myLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.bounds.midX
        myLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    func blink() {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.duration = defautDuration * 2
        animation.fromValue = layer.backgroundColor
        animation.toValue = closedColor.withAlphaComponent(0.3).cgColor
        animation.autoreverses = true
        layer.add(animation, forKey: animation.keyPath!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
