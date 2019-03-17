//
//  DotView.swift
//  gdo
//
//  Created by Jerry Yu on 3/16/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import UIKit

class DotLayer: CAShapeLayer {

    enum State {
        case open
        case closed
    }

    var state = State.closed
    var closedColor = UIColor.green
    var openColor = UIColor.primaryAppColor

    override init() {
        super.init()
        commonInit()
    }

    override init(layer: Any) {
        super.init(layer: layer)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers() {
        super.layoutSublayers()

        let outer = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.midX, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        let inner = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.midX * 0.85, startAngle: 0, endAngle: .pi * 2, clockwise: true)

        let path = UIBezierPath()
        path.append(outer)
        path.append(inner)

        self.path = path.cgPath
        self.fillRule = .evenOdd
    }

    func commonInit() {
        strokeColor =  UIColor.clear.cgColor
        fillColor = closedColor.cgColor // closedColor.cgColor
    }
}

class DotView: UIView {

    class override var layerClass: AnyClass {
        return DotLayer.self
    }

    override var intrinsicContentSize: CGSize {
        let s: CGFloat = 12
        return CGSize(width: s, height: s)
    }

    init() {
        super.init(frame: .zero)
//        backgroundColor = .red
    }

    func pulse() {
        let scaleUp: CGFloat = 1.3
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.values = [
            NSValue(caTransform3D: CATransform3DIdentity),
            NSValue(caTransform3D: CATransform3DMakeScale(scaleUp, scaleUp, scaleUp)),
            NSValue(caTransform3D: CATransform3DIdentity),
        ]
//        animation.timingFunctions =
        animation.duration = 0.8
        layer.add(animation, forKey: "transform")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
