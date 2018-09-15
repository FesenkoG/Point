//
//  PointViewController.swift
//  Point
//
//  Created by Георгий Фесенко on 08/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class PointViewController: UIViewController {
    
    @IBOutlet weak var pointButton: UIButton!
    
    
    var animate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointButton.layer.cornerRadius = pointButton.bounds.height / 2
        pointButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.4039215686, blue: 0.5764705882, alpha: 1)
        configureTabBar()
        //TODO: - Somewhat like a circle.
        let view = UIView(frame: CGRect(x: self.view.bounds.width / 2 - 100, y: self.view.bounds.height / 2 - 100, width: 100, height: 100))
        view.layer.cornerRadius = view.bounds.height / 2
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 10.0
        self.view.addSubview(view)
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func pointButtonTapped(_ sender: UIButton) {
        animate = !animate
        animateButton(sender: sender, animate: animate)
        
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
    
    private func animateButton(sender: UIButton, animate: Bool) {
        if animate {
//            let (view, transform) = self.getViewAndTransform(sender: sender)
//            UIView.animate(withDuration: 1.0, delay: 0.0, options: .allowUserInteraction, animations: {
//                view.transform = transform
//                view.alpha = 0.5
//            }) { (_) in
//                let (secondView, secondTransform) = self.getViewAndTransform(sender: sender)
//                UIView.animate(withDuration: 1.0,  delay: 0.0, options: .allowUserInteraction,animations: {
//                    view.transform = view.transform.scaledBy(x: 2.0, y: 2.0)
//                    view.alpha = 0.0
//                }, completion: { (_) in
//                    view.removeFromSuperview()
//                    self.animateButton(sender: sender, animate: self.animate)
//                })
//                UIView.animate(withDuration: 1.0,  delay: 0.0, options: .allowUserInteraction,animations: {
//                    secondView.transform = secondTransform
//                    secondView.alpha = 0.5
//                }, completion: { (_) in
//                    UIView.animate(withDuration: 1.0,  delay: 0.0, options: .allowUserInteraction,animations: {
//                        secondView.transform = secondTransform.scaledBy(x: 2.0, y: 2.0)
//                        secondView.alpha = 0.0
//                    }, completion: { (_) in
//                        secondView.removeFromSuperview()
//                    })
//                })
//            }
            let (view, transform) = getViewAndTransform(sender: sender)
            let (view2, transform2) = getViewAndTransform(sender: sender)
            let (view3, transform3) = getViewAndTransform(sender: sender)
            let (view4, transform4) = getViewAndTransform(sender: sender)
            UIView.animate(withDuration: 2.0, delay: 0.0, options: .allowUserInteraction, animations: {
                view.transform = transform
                view.alpha = 0.0
                UIView.animate(withDuration: 2.0, delay: 0.5, options: .allowUserInteraction, animations: {
                    view2.transform = transform2
                    view2.alpha = 0.0
                }, completion: { (_) in
                    view2.removeFromSuperview()
                })
                UIView.animate(withDuration: 2.0, delay: 1.0, options: .allowUserInteraction, animations: {
                    view3.transform = transform3
                    view3.alpha = 0.0
                }, completion: { (_) in
                    view3.removeFromSuperview()
                })
                UIView.animate(withDuration: 2.0, delay: 1.5, options: .allowUserInteraction, animations: {
                    view4.transform = transform4
                    view4.alpha = 0.0
                }, completion: { (_) in
                    view4.removeFromSuperview()
                })
            }) { (_) in
                view.removeFromSuperview()
                self.animateButton(sender: sender, animate: self.animate)
            }
        }
        
    }
    
    private func getViewAndTransform(sender: UIButton) -> (view: UIView, transform: CGAffineTransform) {
        let view = UIView(frame: sender.frame)
        view.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.4039215686, blue: 0.5764705882, alpha: 1)
        view.layer.cornerRadius = view.bounds.height / 2
        let originalTransform = view.transform
        let scaledTransform = originalTransform.scaledBy(x: 3.0, y: 3.0)
        sender.addSubview(view)
        return (view, scaledTransform)
    }
    
}

