//
//  QRCodeButtonView.swift
//  gdo
//
//  Created by Jerry Yu on 2/24/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import UIKit

private class QRShapeLayer: CAShapeLayer {

    override var cornerRadius: CGFloat {
        get { return 4 }
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
        self.strokeColor = UIColor.primaryAppColor.cgColor
        self.lineWidth = 3
        self.fillColor = nil
    }
}

class QRCodeButtonView: UIView {

    private let qrShapeLayer = QRShapeLayer()
    let qrButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor(white: 0.99, alpha: 1)

        qrShapeLayer.frame = CGRect(x: 110, y: 30, width: 64, height: 64)
        self.layer.addSublayer(qrShapeLayer)
    }

}
