//
//  QRCodeButtonView.swift
//  gdo
//
//  Created by Jerry Yu on 2/24/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import UIKit

class QRCodeButtonView: UIView {

    let stackview = UIStackView()
    private let qrShapeView = QRShapeView()
    let bottomButton = UIButton(type: .custom)
    let qrViewController = QRScannerViewController(nibName: nil, bundle: nil)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor(white: 0.99, alpha: 1)

        stackview.axis = .vertical
        stackview.alignment = .center
        stackview.addArrangedSubview(qrShapeView)
        stackview.addArrangedSubview(bottomButton)
        self.addSubview(stackview)
        stackview.pinToSuperviewEdges()

        addSubview(qrViewController.view)
        qrViewController.view.pinToSuperviewEdges()
    }

}
