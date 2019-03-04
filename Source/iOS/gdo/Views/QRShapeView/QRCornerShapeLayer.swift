//
//  QRCornerShapeLayer.swift
//  gdo
//
//  Created by Jerry Yu on 2/24/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import UIKit

class QRCornerShapeLayer: CAShapeLayer {

    // MARK: Constants

//    private struct Constants {
//        static let lineWidth: CGFloat = 5
//        static let
//    }

    override var cornerRadius: CGFloat {
        get { return 6 }
        set { /* No-op */ }
    }

    override init() {
        super.init()

        updateLayerPath()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers() {
        super.layoutSublayers()

        updateLayerPath()
    }

    private func updateLayerPath() {
        self.path = CGPath(roundedRect: self.bounds, cornerWidth: self.cornerRadius, cornerHeight: self.cornerRadius, transform: nil)
        self.lineWidth = 6
        self.strokeColor = UIColor.primaryAppColor.cgColor
        self.fillColor = nil
        self.lineCap = .round

        let gap: CGFloat = 0.08
        self.strokeStart = gap / 2
        self.strokeEnd = 0.25 - gap / 2
    }


}
