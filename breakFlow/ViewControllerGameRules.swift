//
//  ViewControllerGameRules.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 3/9/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import UIKit

class ViewControllerGameRules: UIViewController {

    @IBOutlet weak var gameRules: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameRules.text = NSLocalizedString("gameRules", comment: "")
        navigationItem.title = NSLocalizedString("gameRulesTitle", comment: "")

    }

}
