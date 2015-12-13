//
//  ViewController.swift
//  Bubbles
//
//  Created by Paul Vagner on 11/9/15.
//  Copyright © 2015 Paul Vagner. All rights reserved.
//

import UIKit

import AVFoundation

class ViewController: UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate, AVAudioPlayerDelegate {

    var session = AVCaptureSession()
    
    var players: [AVAudioPlayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        
       
         let captureInput = try? AVCaptureDeviceInput(device: captureDevice!)
        
        session = AVCaptureSession()
        
        if session.canAddInput(captureInput) {
        
        session.addInput(captureInput)
        
        }
    
        let captureOutput = AVCaptureAudioDataOutput()
        
        if session.canAddOutput(captureOutput) {
            
            session.addOutput(captureOutput)
            
        }
        
                captureOutput.setSampleBufferDelegate(self, queue: dispatch_get_main_queue())
        
            session.startRunning()
        
    }
   
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        
        guard let channel = connection.audioChannels.first where channel.averagePowerLevel > -5 else { return }
 
        let bubbleSize = CGFloat(arc4random_uniform(15) * 5) + 30
 
        //randomize width & height
        /// Creates the Bubble object
        let bubble = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: bubbleSize, height: bubbleSize)))

        
        //creates color array to chose from
        let colors = [UIColor.blueColor(), UIColor.cyanColor(), UIColor.purpleColor()]
        //randomizes the colors - colorArray
        let randomColorIndex = Int(arc4random_uniform(3))
        //forces the cornerRadius to be equal to bubbleSize devided by 2 -> creates a round shape
        bubble.layer.cornerRadius = bubbleSize / 2
        //chooses the random color from the colors Array
        bubble.layer.borderColor = colors[randomColorIndex].CGColor
        //sets the bubbles border width
        bubble.layer.borderWidth = 1
        
        bubble.center = CGPoint(x: view.frame.midX ,y: view.frame.maxY)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            
        }
        
        view.addSubview(bubble)
        
        //changes duration based on APL
        let randomDuration = Double(abs(channel.averagePowerLevel))
        
        let randomX = CGFloat(arc4random_uniform(UInt32(self.view.frame.maxX)))
        
        let randomY = CGFloat(arc4random_uniform(UInt32(self.view.frame.midY)))
        
        
        UIView.animateWithDuration(randomDuration, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            
            //randomize the bubble.center x & y
            bubble.center.x = randomX
            bubble.center.y = randomY
            
            
            }) { (finished) -> Void in
                
                bubble.removeFromSuperview()
                
                //MARK: ////play pop sound
           
                //accessses the the Assetts catalogue
                let popData = NSDataAsset(name: "Pop")
                //
                let player = try? AVAudioPlayer(data: popData!.data)
            //
                self.players.append(player!)
             
                player?.delegate = self
                
                // playes the sound
                player?.play()
            }
        
        }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        guard let index = players.indexOf(player) else { return }
        
        players.removeAtIndex(index)
        
        print(players.count)
    }
    
}
    
















