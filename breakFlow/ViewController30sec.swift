//
//  ViewController30sec.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 3/3/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import UIKit

class ViewController30sec: UIViewController {

    var counter = 31
    var counterOverall = 0
    var isPaused = true
    var timer = Timer()

    //timer show
    @IBOutlet weak var labelTimer: UILabel!
    //"next" label
    @IBOutlet weak var labelNext: UILabel!
    //start timer
    @IBOutlet weak var timerButton: UIButton!
    
    //30 seconds of love rules button
    @IBOutlet weak var gameRulesButton: UIBarButtonItem!
    
    
    @IBAction func startTimerButtonTapped(_ sender: UIButton) {
        if isPaused{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            isPaused = false
            timerButton.setTitle(NSLocalizedString("pause", comment: ""), for: .normal)
        } else {
            timer.invalidate()
            isPaused = true
            timerButton.setTitle(NSLocalizedString("resume", comment: ""), for: .normal)
        }
    }
    
    @IBAction func cancelTimerButtonTapped(_ sender: UIButton) {
        timer.invalidate()
    }
    
    // called every time interval from the timer
    @objc func timerAction() {
        if counter > 6 {
            labelNext.text = "\(NSLocalizedString("overallTime", comment: ""))\(String(format: "%02d", counterOverall/60)):\(String(format: "%02d", counterOverall%60))"
            counter -= 1
        } else if counter > 1 {
            labelNext.text = NSLocalizedString("getReady", comment: "")
            counter -= 1
        } else if counter == 1 {
            labelNext.text = NSLocalizedString("next", comment: "")
            counter -= 1
            counter = 30
        } else {
            labelNext.text = "\(NSLocalizedString("overallTime", comment: ""))\(String(format: "%02d", counterOverall/60)):\(String(format: "%02d", counterOverall%60))"
            counter -= 1
        }
        counterOverall += 1
        labelTimer.text = "\(counter)"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        labelNext.text = NSLocalizedString("getReady", comment: "")
        timerButton.setTitle(NSLocalizedString("startTimer", comment: ""),for: .normal)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: NSLocalizedString("back", comment: ""), style: .plain, target: nil, action: nil)
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("gameRulesTitle", comment: ""), style: .plain, target: nil, action: #selector())
        
        gameRulesButton.title = NSLocalizedString("gameRulesTitle", comment: "")
        navigationItem.title = NSLocalizedString("30secTitle", comment: "")

    }
}
