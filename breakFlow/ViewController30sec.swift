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
    var timer = Timer()

    @IBOutlet weak var label: UILabel!
    
    //start timer
    
    @IBAction func startTimerButtonTapped(_ sender: UIButton) {
        timer.invalidate() // just in case this button is tapped multiple times
        
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @IBAction func cancelTimerButtonTapped(_ sender: UIButton) {
        timer.invalidate()
    }
    
    // called every time interval from the timer
    @objc func timerAction() {
        if counter > 0{
        counter -= 1
        } else {
            counter = 31
            counter -= 1
        }
        label.text = "\(counter)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
