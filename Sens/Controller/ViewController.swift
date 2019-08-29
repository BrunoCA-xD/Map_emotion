//
//  ViewController.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 21/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var entrarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entrarButton.layer.borderColor = UIColor(red: 130/255.0, green: 71/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }

}

