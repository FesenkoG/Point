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
    @IBOutlet weak var helperTextLabel: UILabel!
    
    var animate: Bool = false
    var gradient: CAGradientLayer?
    var toColors: [Any]?
    var fromColors: [Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient = CAGradientLayer()
        
        pointButton.layer.cornerRadius = pointButton.bounds.height / 2
        pointButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.4039215686, blue: 0.5764705882, alpha: 1)
        configureTabBar()
        //TODO: - Somewhat like a circle.
//        let view = UIView(frame: pointButton.frame)
//        view.layer.cornerRadius = view.bounds.height / 2
//        view.clipsToBounds = true
//        view.layer.borderColor = UIColor.white.cgColor
//        view.layer.borderWidth = 10
//        self.gradient?.frame = view.bounds
//        self.gradient?.colors = [UIColor.black, UIColor.white]
//        UIView.animate(withDuration: 0, delay: 0, options: [.repeat, .autoreverse], animations: {
//
//        }, completion: nil)
//        view.layer.insertSublayer(self.gradient!, at: 0)
//        animateLayer()
        //self.pointButton.addSubview(view)
        //
    }

//    func animateLayer(){
//
//        fromColors = self.gradient?.colors
//        toColors = [ UIColor.black.cgColor, UIColor.blue.cgColor]
//
//        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
//
//        animation.fromValue = fromColors
//        animation.toValue = toColors
//        animation.duration = 3.00
//        animation.isRemovedOnCompletion = true
//        animation.fillMode = kCAFillModeForwards
//        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        animation.delegate = self
//
//        self.gradient?.add(animation, forKey:"animateGradient")
//    }
    
    @IBAction func pointButtonTapped(_ sender: UIButton) {
        animate = !animate
        helperTextLabel.isHidden = !helperTextLabel.isHidden
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
//
//extension PointViewController: CAAnimationDelegate {
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        
//        self.toColors = self.fromColors;
//        self.fromColors = self.gradient?.colors
//        animateLayer()
//    }
//}

