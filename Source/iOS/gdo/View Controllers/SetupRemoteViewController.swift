//
//  SetupRemoteViewController.swift
//  gdo
//
//  Created by Jerry Yu on 2/24/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import UIKit

class SetupRemoteViewController: UIViewController {

    let textView = UITextView()
    let qrCodeButtonView = QRCodeButtonView()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))

        setupViews()
    }

    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    private func setupViews() {
        textView.backgroundColor = UIColor(white: 0.98, alpha: 1)
        view.addSubview(textView)
        textView.pin(attributes: [.centerX, .width, .topMargin], to: view)

        view.addSubview(qrCodeButtonView)
        qrCodeButtonView.topAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        qrCodeButtonView.pin(attributes: [.centerX, .width, .bottomMargin], to: view)
        qrCodeButtonView.pin(width: nil, height: 140)
    }
}
