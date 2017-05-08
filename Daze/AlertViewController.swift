//
//  AlertViewController.swift
//  Daze
//
//  Created by David M Sirkin on 9/13/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import AVFoundation

class AlertViewController: UIViewController {
    
    @IBOutlet weak var message: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        message.text = appDelegate.message
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
        } catch {
        }
        playAudio()
    }
    
    func playAudio() {
        let path = Bundle.main.path(forResource: "chord", ofType: "m4r")
        
        if path != nil {
            let url = NSURL.fileURL(withPath: path!)
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: url)
                audioPlayer.play()
            } catch {
            }
        }
    }
    
    @IBAction func yesAction(_ sender: UIButton) {
        performSegue(withIdentifier: "alertViewUnwind", sender: self)
    }
    
    @IBAction func noAction(_ sender: UIButton) {
        performSegue(withIdentifier: "alertViewUnwind", sender: self)
    }
}
