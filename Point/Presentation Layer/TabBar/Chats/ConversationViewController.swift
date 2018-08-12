//
//  ConversationViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 12.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

