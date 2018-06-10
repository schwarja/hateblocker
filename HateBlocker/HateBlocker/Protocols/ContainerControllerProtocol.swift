//
//  ContainerControllerProtocol.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit
import QuartzCore

protocol ContainerController: class {
    var embededController: UIViewController? { get set }
}

extension ContainerController where Self: UIViewController {
    
    func embed(controller: UIViewController, useSafeArea: Bool = false, animated: Bool = true) {
        embed(controller: controller, toView: self.view, useSafeArea: useSafeArea, animated: animated)
    }
    
    func embed(controller: UIViewController, toView view: UIView, useSafeArea: Bool = false, animated: Bool = true) {
        let fadeOutDuration: TimeInterval = animated ? 0.1 : 0
        let fadeInDuration: TimeInterval = animated ? 0.15 : 0
        
        if let controller = embededController, animated {
            controller.view.layer.removeAllAnimations()
            controller.view.layer.opacity = 0
            let disappearAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.opacity))
            disappearAnimation.values = [1, 0]
            disappearAnimation.duration = fadeOutDuration
            disappearAnimation.keyTimes = [0, 1]
            controller.view.layer.add(disappearAnimation, forKey: "opacityAnimation")
            controller.willMove(toParent: nil)
            controller.removeFromParent()
            runAfter(fadeOutDuration, closure: {
                if controller.parent == nil {
                    controller.view.removeFromSuperview()
                }
            })
        }
        else if let controller = embededController {
            controller.willMove(toParent: nil)
            controller.removeFromParent()
            if controller.parent == nil {
                controller.view.removeFromSuperview()
            }
        }
        
        let previous = embededController
        embededController = controller
        
        if previous == nil || !animated {
            view.addSubview(controller.view)
            self.addChild(controller)
            
            if useSafeArea {
                controller.view.attachToSafeArea(left: 0, top: 0, right: 0, bottom: 0)
            }
            else {
                controller.view.attach(left: 0, top: 0, right: 0, bottom: 0)
            }
            
            controller.didMove(toParent: self)
        }
        else {
            runAfter(fadeOutDuration) {
                guard self.embededController == controller else {
                    return
                }
                
                view.addSubview(controller.view)
                self.addChild(controller)
                
                if useSafeArea {
                    controller.view.attachToSafeArea(left: 0, top: 0, right: 0, bottom: 0)
                }
                else {
                    controller.view.attach(left: 0, top: 0, right: 0, bottom: 0)
                }
                
                controller.didMove(toParent: self)
                
                controller.view.layer.opacity = 1
                controller.view.layer.removeAllAnimations()
                let appearAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.opacity))
                appearAnimation.values = [0, 1]
                appearAnimation.duration = fadeInDuration
                appearAnimation.keyTimes = [0.4, 1]
                controller.view.layer.add(appearAnimation, forKey: "opacityAnimation")
            }
        }
    }
    
}
