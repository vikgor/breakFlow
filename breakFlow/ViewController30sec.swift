//
//  ViewController30sec.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 3/3/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import UIKit

class ViewController30sec: UIViewController {

    var counter = 30
    var isPaused = true
    var timer = Timer()

    //timer show
    @IBOutlet weak var labelTimer: UILabel!
    //"next" label
    @IBOutlet weak var labelNext: UILabel!
    //start timer
    @IBOutlet weak var timerButton: UIButton!
    
    @IBAction func startTimerButtonTapped(_ sender: UIButton) {
        if isPaused{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            isPaused = false
            timerButton.setTitle("pause", for: .normal)
        } else {
            timer.invalidate()
            isPaused = true
            timerButton.setTitle("resume", for: .normal)
        }
    }
    
    @IBAction func cancelTimerButtonTapped(_ sender: UIButton) {
        timer.invalidate()
    }
    
    // called every time interval from the timer
    @objc func timerAction() {
        if counter > 5 {
            labelNext.text = ""
            counter -= 1
        } else if counter > 1 {
            labelNext.text = "приготовиться"
            counter -= 1
        } else if counter == 1 {
            labelNext.text = "следующий!"
            counter -= 1
        } else {
            counter = 31
            labelNext.text = ""
            counter -= 1
        }
        
        labelTimer.text = "\(counter)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
