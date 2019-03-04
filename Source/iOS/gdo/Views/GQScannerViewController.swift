//
//  QRScannerViewController.swift
//  gdo
//
//  Created by Jerry Yu on 3/3/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession = AVCaptureSession()

    var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    // Modified from https://github.com/appcoda/QRCodeReader
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)

        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Set the input device on the capture session.
            captureSession.addInput(input)

            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)

            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }

        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        // Start video capture.
        captureSession.startRunning()
    }

    // MARK: AVCaptureMetadataOutputObjectsDelegate

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let readableCodeObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }

        guard let stringValue = readableCodeObject.stringValue,
            let data = stringValue.data(using: .utf8) else {
                GDOLog.logDebug("No data in QR code")
                return
        }

        GDOLog.logDebug("Data from QR code:\n'\(stringValue)'")

        guard let environment = try? JSONDecoder().decode(Environment.self, from: data) else {
            GDOLog.logDebug("Couldn't parse QR code into Environment")
            return
        }

        let alert = UIAlertController(title: "Use This Configuration?", message: environment.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            environment.makeNewDefaultEnvironment()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
