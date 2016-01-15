//
//  ViewController.swift
//  Bubbles
//
//  Created by Paul Vagner on 11/9/15.
//  Copyright © 2015 Paul Vagner. All rights reserved.
//

import UIKit

import AVFoundation

//class ViewController: UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate, AVAudioPlayerDelegate {
//
//    var session = AVCaptureSession()
//    
//    var players: [AVAudioPlayer] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    
//        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
//        
//       
//         let captureInput = try? AVCaptureDeviceInput(device: captureDevice!)
//        
//        session = AVCaptureSession()
//        
//        if session.canAddInput(captureInput) {
//        
//        session.addInput(captureInput)
//        
//        }
//    
//        let captureOutput = AVCaptureAudioDataOutput()
//        
//        if session.canAddOutput(captureOutput) {
//            
//            session.addOutput(captureOutput)
//            
//        }
//        
//        
//                captureOutput.setSampleBufferDelegate(self, queue: dispatch_get_main_queue())
//        
//            session.startRunning()
//        
//    }
//   
//    
//    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
//        
//        
//        guard let channel = connection.audioChannels.first where channel.averagePowerLevel > -5 else { return }
// 
//        let bubbleSize = CGFloat(arc4random_uniform(15) * 5) + 30
// 
//        //randomize width & height
//        /// Creates the Bubble object
//        let bubble = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: bubbleSize, height: bubbleSize)))
//
//        
//        //creates color array to chose from
//        let colors = [UIColor.blueColor(), UIColor.cyanColor(), UIColor.purpleColor()]
//        //randomizes the colors - colorArray
//        let randomColorIndex = Int(arc4random_uniform(3))
//        //forces the cornerRadius to be equal to bubbleSize devided by 2 -> creates a round shape
//        bubble.layer.cornerRadius = bubbleSize / 2
//        //chooses the random color from the colors Array
//        bubble.layer.borderColor = colors[randomColorIndex].CGColor
//        //sets the bubbles border width
//        bubble.layer.borderWidth = 1
//        
//        bubble.center = CGPoint(x: view.frame.midX ,y: view.frame.maxY)
//        
//        dispatch_async(dispatch_get_main_queue()) { () -> Void in
//            
//            
//        }
//        
//        view.addSubview(bubble)
//        
//        //changes duration based on APL
//        let randomDuration = Double(abs(channel.averagePowerLevel))
//        
//        let randomX = CGFloat(arc4random_uniform(UInt32(self.view.frame.maxX)))
//        
//        let randomY = CGFloat(arc4random_uniform(UInt32(self.view.frame.midY)))
//        
//        
//        UIView.animateWithDuration(randomDuration, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
//            
//            
//            //randomize the bubble.center x & y
//            bubble.center.x = randomX
//            bubble.center.y = randomY
//            
//            
//            }) { (finished) -> Void in
//                
//                bubble.removeFromSuperview()
//                
//                //MARK: ////play pop sound
//           
//                //accessses the the Assetts catalogue
//                let popData = NSDataAsset(name: "Pop")
//                //
//                let player = try? AVAudioPlayer(data: popData!.data)
//            //
//                self.players.append(player!)
//             
//                player?.delegate = self
//                
//                // playes the sound
//                player?.play()
//            }
//        
//        }
//    
//    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
//        
//        guard let index = players.indexOf(player) else { return }
//        
//        players.removeAtIndex(index)
//        
//        print(players.count)
//    }
//    
//}
//    


    @IBDesignable class Bubble: UIView {

    @IBInspectable var color: UIColor = UIColor.blackColor()
        
        @IBInspectable var spacing: CGFloat = 1
        
        @IBInspectable var maxRings: Int = 0
        
        override func drawRect(rect: CGRect) {
            
            print(maxRings)
            
            if spacing < 1 { spacing = 1 }
            if maxRings < 1 { maxRings = 1000 }
            
            let context = UIGraphicsGetCurrentContext()
            
            let radius = rect.width / 2
            
            var inset: CGFloat = 1
            
            color.set()
            
            var ringCount = 0
            
            while inset < radius {
                
                if ringCount == maxRings { inset = radius }
                
                let insetRect = CGRectInset(rect, inset, inset)
                
                CGContextStrokeEllipseInRect(context, insetRect)
                
                ringCount++
                inset += spacing
                
                
                
            }
            
        }
    }
   
    import UIKit
    
    import AVFoundation
    
    class ViewController: UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate, AVAudioPlayerDelegate {
        
        var session = AVCaptureSession()
        
        var players: [AVAudioPlayer] = []
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
            
            let captureInput = try? AVCaptureDeviceInput(device: captureDevice!)
            
            
            
            if session.canAddInput(captureInput) {
                
                session.addInput(captureInput)
                
            }
            
            let captureOutput = AVCaptureAudioDataOutput()
            
            if session.canAddOutput(captureOutput) {
                
                session.addOutput(captureOutput)
                
            }
            
            captureOutput.setSampleBufferDelegate(self, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
            //
            //        captureOutput.setSampleBufferDelegate(self, queue: dispatch_get_main_queue())
            
            session.startRunning()
            
        }
        
        func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
            
            
            
            guard let channel = connection.audioChannels.first else { return }
            //
            //        print("APL : \(channel?.averagePowerLevel) PHL : \(channel?.peakHoldLevel)")
            //
            if channel.averagePowerLevel > -5 {
                
                //            print("Blowing")
                
                
                dispatch_async(dispatch_get_main_queue())  {
                    
                    let bubbleSize = CGFloat(arc4random_uniform(15)*5) + 30
                    // randomize width and height
                    let bubble = Bubble(frame: CGRect(origin: CGPointZero, size: CGSize(width: bubbleSize, height: bubbleSize)))
                    
                    bubble.backgroundColor = UIColor.clearColor()
                    
                    bubble.spacing = CGFloat(arc4random_uniform(10))
                    
                    
                    
                    bubble.setNeedsDisplay()
                    
                    let colors = [UIColor.blackColor(),UIColor.redColor(),UIColor.purpleColor()]
                    let randomColorIndex = Int(arc4random_uniform(3))
                    // randomize color between blue and purple
                    bubble.color = colors[randomColorIndex]
                    
                    bubble.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.maxY)
                    
                    self.view.addSubview(bubble)
                    
                    //            bubble.isMemberOfClass(Bubble)
                    
                    
                    let randomDuration = Double(abs(channel.averagePowerLevel))
                    
                    let randomX = CGFloat(arc4random_uniform(UInt32(self.view.frame.maxX)))
                    
                    let randomY = CGFloat(arc4random_uniform(UInt32(self.view.frame.midY)))
                    
                    UIView.animateWithDuration(randomDuration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                        
                        
                        
                        // randomize the bubble.center x & y
                        bubble.center.y = randomY
                        bubble.center.x = randomX
                        
                        })  { (finished) -> Void in
                            
                            // play pop sound
                            bubble.removeFromSuperview()
                            
                            let balloonData = NSDataAsset(name: "Balloon")
                            
                            let player = try?AVAudioPlayer(data: balloonData!.data)
                            
                            self.players.append(player!)
                            
                            player?.delegate = self
                            player?.play()
                    }
                }
                
            }
            
        }
        func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
            
            guard let index = players.indexOf(player) else { return }
            players.removeAtIndex(index)
            
            print(players.count)
        }
    }










