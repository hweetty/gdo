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

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(resetButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))

        setupViews()
        updateUI()
    }

    @objc func resetButtonPressed() {
        Environment.resetSavedEnvironment() // todo: put inside a confirm block

        updateUI()
    }

    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    func updateUI() {
        self.navigationItem.leftBarButtonItem?.isEnabled = Environment.loadFromDiskIfPossible() != nil
        textView.text = Environment.loadFromDiskIfPossible()?.description
    }

    private func setupViews() {
        textView.backgroundColor = UIColor(white: 0.98, alpha: 1)
        textView.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(textView)
        textView.pin(attributes: [.centerX, .width, .top], to: view)
        textView.pin(width: nil, height: 360)

        view.addSubview(qrCodeButtonView)
        qrCodeButtonView.topAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        qrCodeButtonView.pin(attributes: [.centerX, .width, .bottomMargin], to: view)
        qrCodeButtonView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
