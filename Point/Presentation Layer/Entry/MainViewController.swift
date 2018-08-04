//
//  MainViewController
//  Point
//
//  Created by Георгий Фесенко on 12/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }


}

