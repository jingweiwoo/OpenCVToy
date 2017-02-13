//
//  FaceLiveCognitionViewController.swift
//  OpenCVToy
//
//  Created by Jingwei Wu on 08/02/2017.
//  Copyright © 2017 jingweiwu. All rights reserved.
//

import UIKit
import AVFoundation

class FaceLiveCognitionViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var session : AVCaptureSession!
    var myDevice : AVCaptureDevice!
    var myOutput : AVCaptureVideoDataOutput!
    
    let faceDetector = FaceDetector()
    
    var detectedFaces: [FaceWrapper] = []
    var originalImageBuffer: UIImage? = nil
    
    var detectQueue = DispatchQueue(label: "detectQueue", qos: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewTitle = NSLocalizedString("Face Live Cognition", comment: "")
        // Do any additional setup after loading the view.
        
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        session.startRunning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if session.isRunning {
            session.stopRunning()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @discardableResult
    func setupCamera() -> Bool {
        // 初始化Session
        session = AVCaptureSession()
        
        // 视频分辨率设定
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        // 获得可用的设备
        let devices = AVCaptureDevice.devices()
        
        for device in devices! {
            if((device as AnyObject).position == AVCaptureDevicePosition.back){
                //                if(device.position == AVCaptureDevicePosition.back){
                myDevice = device as! AVCaptureDevice
            }
        }
        if myDevice == nil {
            return false
        }
        
        // バックカメラからVideoInputを取得.
        var myInput: AVCaptureDeviceInput! = nil
        do {
            myInput = try AVCaptureDeviceInput(device: myDevice) as AVCaptureDeviceInput
        } catch let error {
            print(error)
        }
        
        // セッションに追加.
        if session.canAddInput(myInput) {
            session.addInput(myInput)
        } else {
            return false
        }
        
        // 出力先を設定
        myOutput = AVCaptureVideoDataOutput()
        myOutput.videoSettings = [ kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_32BGRA) ]
        
        
        
        // 设置FPS值
        do {
            try myDevice.lockForConfiguration()
            
            myDevice.activeVideoMinFrameDuration = CMTimeMake(1, 30)
            myDevice.unlockForConfiguration()
        } catch let error {
            print("lock error: \(error)")
            return false
        }
        
        // デリゲートを設定
        let queue: DispatchQueue = DispatchQueue(label: "myqueue")
        myOutput.setSampleBufferDelegate(self, queue: queue)
        
        
        // 遅れてきたフレームは無視する
        myOutput.alwaysDiscardsLateVideoFrames = true
        
        // セッションに追加.
        if session.canAddOutput(myOutput) {
            session.addOutput(myOutput)
        } else {
            return false
        }
        
        // カメラの向きを合わせる
        for connection in myOutput.connections {
            if let conn = connection as? AVCaptureConnection {
                if conn.isVideoOrientationSupported {
                    conn.videoOrientation = AVCaptureVideoOrientation.portrait
                }
            }
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FaceLiveCognitionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    // 每帧做处理
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!)
    {
        let image = CameraUtil.imageFromSampleBuffer(sampleBuffer: sampleBuffer)
        if self.originalImageBuffer == nil {
            self.originalImageBuffer = image
            
            // self.detectQueue.async() {
            DispatchQueue.global(qos: .default).async {
                let img = self.originalImageBuffer?.scaleToRatio(ratio: 0.6).compress(imageQuality: 0.2)
                self.detectedFaces = (self.faceDetector?.detectFace(img))!
                self.originalImageBuffer = nil
            }
        }
        
        DispatchQueue.main.sync {
            var faceImage: UIImage!
            var croppedFaceImages: [UIImage] = []
            
            if self.detectedFaces.count <= 0 {
                faceImage = image
            } else {
                // 标示出脸部
                let rects = convert(faces: self.detectedFaces, scaleRatio: CGFloat(0.6))
//                for rect in rects {
//                    let croppedFaceImage = image.clip(byRect: rect)
//                    let imageV = UIImageView.init(frame: rect)
//                    imageV.image = croppedFaceImage
//                    self.imageView.addSubview(imageV)
//                }

                faceImage = UIImage.draw(rects: rects, scaleRatio: CGFloat(0.6), onImage: image)
            }
            // 表示
            self.imageView.image = faceImage
            

        }
    }
}

func convert(faces: [FaceWrapper], scaleRatio: CGFloat) -> [CGRect] {
    var rects: [CGRect] = []
    for face in faces {
        rects.append(CGRect(x: (CGFloat(face.x) - CGFloat(face.width) / 4) / scaleRatio,
                            y: (CGFloat(face.y) - CGFloat(face.height) / 4) / scaleRatio, width: CGFloat(face.width) * 1.5 / scaleRatio, height: CGFloat(face.height) * 1.5 / scaleRatio))
    }
    return rects
}




