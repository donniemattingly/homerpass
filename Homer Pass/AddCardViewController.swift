//
//  AddCardViewController.swift
//  Homer Pass
//
//  Created by Donnie Mattingly on 1/7/17.
//  Copyright © 2017 Donnie Mattingly. All rights reserved.
//

import UIKit
import AVFoundation

class AddCardViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    

    @IBOutlet weak var previewView: UIView!
    
    @objc var videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
    @objc var device = AVCaptureDevice.default(for: AVMediaType.video)
    @objc var output = AVCaptureMetadataOutput()
    @objc var previewLayer: AVCaptureVideoPreviewLayer?
    
    @objc var captureSession = AVCaptureSession()
    @objc var code: String?
    @objc var cameraSetup = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupCamera() {
        
        let input = try? AVCaptureDeviceInput(device: videoCaptureDevice)
        
        if self.captureSession.canAddInput(input!) {
            self.captureSession.addInput(input!)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if let videoPreviewLayer = self.previewLayer {
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = self.view.bounds
            self.view.layer.insertSublayer(videoPreviewLayer, at: 0)
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if self.captureSession.canAddOutput(metadataOutput) {
            self.captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.aztec]
        } else {
            print("Could not add metadata output")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        super.viewWillAppear(animated)
        if(!cameraSetup){
            self.setupCamera()
        }
        if (captureSession.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    
   	func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // wait() is used to drop new notifications if old ones are still processing, to avoid queueing up a bunch of stale data.
        if let barcodeData = metadataObjects.first {
            // Turn it into machine readable code
            let barcodeReadable = barcodeData as? AVMetadataMachineReadableCodeObject;
            if let readableCode = barcodeReadable {
                // Send the barcode as a string to barcodeDetected()
                code = readableCode.stringValue
                performSegue(withIdentifier: "confirmCard", sender: nil)
            }
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "confirmCard"){
            (segue.destination as? ConfirmCardViewController)?.code = code
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
