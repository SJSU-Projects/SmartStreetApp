//
//  signUpScannerViewController.swift
//  SmartStreetApp
//
//  Created by Preethi on 3/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//
import UIKit
import AVFoundation

class signUpScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    var objCaptureSession:AVCaptureSession?
    var objCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var vwQRCode:UIView?
    var name:String = ""
    var phone:String = ""
    var mail:String = ""
    
    @IBOutlet var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Configure Video Capture for reading QRCode
    
    func configureVideoCapture() {
        let objCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error:NSError?
        let objCaptureDeviceInput: AnyObject!
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        if (error != nil) {
            let alertView:UIAlertView = UIAlertView(title: "Device Error", message:"Device not Supported for this Application", delegate: nil, cancelButtonTitle: "Ok Done")
            alertView.show()
            return
        }
        objCaptureSession = AVCaptureSession()
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    func addVideoPreviewLayer()
    {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(objCaptureVideoPreviewLayer!)
        objCaptureSession?.startRunning()
      
        self.view.bringSubviewToFront(doneButton)
        // print(lblQRCodeResult)
    }
    
    func initializeQRView() {
        vwQRCode = UIView()
        vwQRCode?.layer.borderColor = UIColor.redColor().CGColor
        vwQRCode?.layer.borderWidth = 5
        self.view.addSubview(vwQRCode!)
        self.view.bringSubviewToFront(vwQRCode!)
    }
    
    // optional func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!);
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        objCaptureSession?.stopRunning()
        if metadataObjects == nil || metadataObjects.count == 0 {
            vwQRCode?.frame = CGRectZero
            print( "NO QRCode text detacted")
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObjectForMetadataObject(objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            vwQRCode?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                var lab = objMetadataMachineReadableCodeObject.stringValue
                var vdata:String =  lab
                var splitarr = vdata.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ":\n"))
                var i = 0
                for loop in splitarr{
                     print("Line \(i): \(loop)")
                    
                     if splitarr[0] == "BEGIN"{
                        name = splitarr[7]
                        phone = splitarr[17]
                        mail = splitarr[21]
                        print("Name: \(name) , Phone:\(phone) , mail = \(mail)")
                        
                    } else{
                        print("Not valid Vcard QRCode")
                    }
                    
                    i++
                    
                    
                }
                
                
            }
        }
    }
   
    @IBAction func doneButton(sender: AnyObject) {
    
        objCaptureSession?.stopRunning()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var signUpVC: signUpViewController = segue.destinationViewController as! signUpViewController
        
        signUpVC.receivedname =  name
        signUpVC.receivedphone =  phone
        signUpVC.receivedmail =  mail
        }

}
