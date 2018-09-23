//
//  PointViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class PointViewController: UIViewController {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var waitCircle: UIImageView!
    @IBOutlet weak var pointButton: UIButton!
    @IBOutlet weak var helperTextLabel: UILabel!
    
    var animate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        waitCircle.rotate360Degrees()
        pointButton.layer.cornerRadius = pointButton.bounds.height / 2
        pointButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.4039215686, blue: 0.5764705882, alpha: 1)
        configureTabBar()
    }
    
    @IBAction func pointButtonTapped(_ sender: UIButton) {
        animate = !animate
        helperTextLabel.isHidden = !helperTextLabel.isHidden
        animateButton(sender: sender, animate: animate, withInterval: 2.5)
        
        //let matchVC = MatchViewController()
        //matchVC.modalPresentationStyle = .custom
        //present(matchVC, animated: true, completion: nil)
    }
    
    //TODO: - Move this to AppDelegate
    private func configureTabBar() {
        guard let tabBar = tabBarController?.tabBar else { return }
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBarController?.viewControllers?.forEach({ (controller) in
            controller.tabBarItem.setImageInsets()
        })
    }
    
    private func animateButton(sender: UIButton, animate: Bool, withInterval interval: Double) {
        let delay = interval / 4
        if animate {
            let (view, transform) = getViewAndTransform(sender: sender)
            let (view2, transform2) = getViewAndTransform(sender: sender)
            let (view3, transform3) = getViewAndTransform(sender: sender)
            let (view4, transform4) = getViewAndTransform(sender: sender)
            UIView.animate(withDuration: interval, delay: 0, options: .allowUserInteraction, animations: {
                view.transform = transform
                view.alpha = 0.0
                UIView.animate(withDuration: interval, delay: delay, options: .allowUserInteraction, animations: {
                    view2.transform = transform2
                    view2.alpha = 0.0
                }, completion: { (_) in
                    view2.removeFromSuperview()
                })
                UIView.animate(withDuration: interval, delay: delay * 2, options: .allowUserInteraction, animations: {
                    view3.transform = transform3
                    view3.alpha = 0.0
                }, completion: { (_) in
                    view3.removeFromSuperview()
                })
                UIView.animate(withDuration: interval, delay: delay * 3, options: .allowUserInteraction, animations: {
                    view4.transform = transform4
                    view4.alpha = 0.0
                }, completion: { (_) in
                    view4.removeFromSuperview()
                })
            }) { (_) in
                view.removeFromSuperview()
                self.animateButton(sender: sender, animate: self.animate, withInterval: interval)
            }
        }
        
    }
    
    private func getViewAndTransform(sender: UIButton) -> (view: UIView, transform: CGAffineTransform) {
        let frame = CGRect(x: 0, y: 0, width: sender.frame.width, height: sender.frame.height)
        let view = UIView(frame: frame)
        view.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.4039215686, blue: 0.5764705882, alpha: 1)
        view.layer.cornerRadius = view.bounds.height / 2
        let originalTransform = view.transform
        let scaledTransform = originalTransform.scaledBy(x: 3.0, y: 3.0)
        sender.addSubview(view)
        return (view, scaledTransform)
    }
    
}


