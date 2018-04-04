//
//  AnimationRegisteryView.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 03.04.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import Foundation
import UIKit
public class AnimationViewRegistery {
    
    var effect:UIVisualEffect!
    
    public func animationViewIn(globalView: UIView, showView: UIView, visualEffect: UIVisualEffectView, effecView: UIVisualEffect) {
        globalView.addSubview(showView)
        showView.center = globalView.center
        
        showView.transform = CGAffineTransform.init(translationX: 0, y: -800) //(scaleX: 1.3, y: 1.3)
        //self.registeryView.alpha = 1
        
        UIView.animate(withDuration: 1.4) {
            visualEffect.isHidden = false
            visualEffect.effect = effecView
            showView.alpha = 1
            showView.transform = CGAffineTransform.identity
        }
    }
    public func animationViewOut(globalView: UIView, showView: UIView, visualEffect: UIVisualEffectView, effecView: UIVisualEffect) {
        UIView.animate(withDuration: 1.4, animations: {
            showView.transform = CGAffineTransform.init(translationX: 0, y: -800)
            showView.alpha = 0
            //self.visualEffectView.isHidden = true
            visualEffect.effect = nil
        }) { (succes: Bool) in
            showView.removeFromSuperview()
            visualEffect.isHidden = true
        }
        
    }
}
