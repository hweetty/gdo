//
//  QRShapeView.swift
//  gdo
//
//  Created by Jerry Yu on 2/24/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import UIKit

class QRShapeView: UIView {

    private let cornerLayers: [QRCornerShapeLayer]

    var preferredSize: CGFloat = 64

    override init(frame: CGRect) {
        self.cornerLayers = [0, 1, 2, 3].map({ (i) -> QRCornerShapeLayer in
            let corner = QRCornerShapeLayer()
            corner.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(i) * CGFloat.pi / 2))
            return corner
        })

        super.init(frame: frame)

        cornerLayers.forEach{ self.layer.addSublayer($0) }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: preferredSize, height: preferredSize)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Ensure we are a square at the center of this view
        let minSize = min(self.bounds.width, self.bounds.height)
        let squareBounds = CGRect(origin: .zero, size: CGSize(width: minSize, height: minSize))
        cornerLayers.forEach{ corner in
            corner.bounds = squareBounds
            corner.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        }
    }
}
