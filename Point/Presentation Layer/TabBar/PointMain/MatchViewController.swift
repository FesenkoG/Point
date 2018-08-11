//
//  MatchViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 11.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }
    

}
