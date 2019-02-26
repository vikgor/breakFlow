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
        // call it here
        //print(data!)
        //print(example.tableMoves)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func randomizeAction(_ sender: UIButton) {

        //randomize a number of moves
        let x = Int(arc4random_uniform(2)+5)
        
        //Used to be like this:
        //var moves = ["ТопРок","Индиан Степ","Сальса Степ","Флор рок (мини промокашка)","Циркуль","3 степ","4 степ","Бейби лав","6 степ на локтях","6 степ олдскул","Скрэмбл","Мини-свайп","Мини-свайп через К","Зулу спин","Зулу спин через К","Зулу спин нога на коленке","Питер Пэн","Кувырок","Ножницы","Голень слайд","СС","СС на спине","СС обратный","СС с проворотом","СС с киком","Кик двумя ногами","Шафл степ","Рашн степс","Свайп нога на коленке","Вэб","Гелик","Свайп","Свайп на двух ногах","Бочка","Тартл","Джекхаммер","Бэкспин","Флаер","99","Хедспин","Бейби фриз","Бейби фриз","Чеир","Эир бейби","Бэк/полубэк","Фриз на плече","Фриз на локте","Фриз на руках","Фриз на руке","Фриз на голове"]
        
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
        let scracthSounds = ["90sp14", "90sp18","90sp50"]
        let randomScratchIndex = Int(arc4random_uniform(UInt32(scracthSounds.count)))
        let randomScratch = scracthSounds[randomScratchIndex]
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: randomScratch, ofType: "wav")!)
        print(alertSound)
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        try! audioPlayer = AVAudioPlayer(contentsOf: alertSound)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        
    }
    

}

