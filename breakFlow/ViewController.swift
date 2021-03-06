//
//  ViewController.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 6/16/17.
//  Copyright © 2017 Viktor Gordienko. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation


class ViewController: UIViewController {
    
    //Audio Player in da House - to play random scracth sounds
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var randomNumberLabel: UILabel!
    @IBOutlet weak var randomizeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(data!)
        //print(example.tableMoves)
        
        //Localization
        randomizeButton.setTitle(NSLocalizedString("newFlow", comment: ""),for: .normal)
        randomNumberLabel.text = NSLocalizedString("breakFlow", comment: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func randomizeAction(_ sender: UIButton) {

        //randomize a number of moves
        let x = Int(arc4random_uniform(2)+5)
        
        //Used to be like this:
        //var moves = ["Toprock","Footwork", "Powermove", "Trick"]
        
        //get variable from different ViewController
        var moves = TableViewController().getData() as! [String]
        
        print("Связка из ", x, "движений")
        var breakFlow = [String]()
        
        while breakFlow.count < x {
            var new_val = String()              //пустой массив
            let randomIndex = Int(arc4random_uniform(UInt32(moves.count)))
            new_val = moves[randomIndex]        //случайный элемент массива
            if new_val != breakFlow.last {      //сравнение нового элемента с последним имеющимся
                breakFlow.append(new_val)       //дополняем новый массив
            }
        }
        let string = breakFlow.joined(separator: "\n")
        randomNumberLabel.text = (string)
        
        
        //play a random scratch sound on button press
        let scracthSounds = ["90sp14", "90sp18","90sp50", "90sp54", "100SP11", "110SP58", "110SP59", "115SP21", "115SP22", "115SP23"]
        let randomScratchIndex = Int(arc4random_uniform(UInt32(scracthSounds.count)))
        let randomScratch = scracthSounds[randomScratchIndex]
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: randomScratch, ofType: "wav")!)
        print(alertSound)
        //that stopped working after updating swift from 4 to 4.2:
        //try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        
        
//        Sound doesn't work for some reason
        
//        try! audioPlayer = AVAudioPlayer(contentsOf: alertSound)
//        audioPlayer.prepareToPlay()
//        audioPlayer.play()
        
        
    }
    

}

