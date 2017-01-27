//
//  PlusBtnView.swift
//  BottomSubMenu
//
//  Created by Alexander Lobanov on 26.01.17.
//  Copyright © 2017 iosnik. All rights reserved.
//

import Foundation
import UIKit

protocol PlusBtnViewDelgate {
    func plusBtnViewWillChangeState(to: Bool, step: Int)
}

class PlusBtnView: UIView {
    
    let plusBtnPadding: CGFloat = 5.0
    let plusBtnLineWidth: CGFloat = 2.0
    
    var delegate: PlusBtnViewDelgate?
    
    var plusBtnViewH: UIView!
    var plusBtnViewV: UIView!
    
    weak var subMenuView: UIView!
    
    var plusBtnViewVInitFrame: CGRect!
    var subMenuViewInitFrame: CGRect!
    
    var plusBtnColor: UIColor = UIColor.lightGray
    var plusBtnSelected = false
    
    // MARK: - Life Cycle
    
    init(side: CGFloat, alignWithView: UIView, menuView: UIView, color: UIColor) {
        super.init(frame: CGRect(x: (alignWithView.frame.width - side) / 2.0,
                                 y: alignWithView.frame.origin.y,
                                 width: side, height: side))
        
        subMenuView = menuView
        subMenuView.isHidden = true
        for view in self.subMenuView.subviews { view.alpha = 0 }
        
        subMenuViewInitFrame = subMenuView.frame
        
        subMenuView.frame = CGRect(x: subMenuViewInitFrame.origin.x + subMenuViewInitFrame.width / 2.0,
                                   y: subMenuViewInitFrame.origin.y,
                                   width: plusBtnLineWidth, height: subMenuViewInitFrame.height)
        
        plusBtnColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func  didMoveToWindow() {
        super.didMoveToWindow()

        prepare()
        resizeViews()
    }
    
    override func removeFromSuperview() {
        
        plusBtnViewH.removeFromSuperview()
        plusBtnViewV.removeFromSuperview()
        
        super.removeFromSuperview()
    }
    
    private func prepare() {

        // add views
        plusBtnViewH = UIView()
        plusBtnViewV = UIView()
        
        superview!.insertSubview(plusBtnViewV, belowSubview: self)
        superview!.insertSubview(plusBtnViewH, belowSubview: self)
        
        
        // background colors
        
        plusBtnViewH.backgroundColor = plusBtnColor
        plusBtnViewV.backgroundColor = plusBtnColor
        backgroundColor = UIColor.clear
        //layer.borderWidth = 1.0

        // touches
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(plusBtnTapped(gesture:)))
        addGestureRecognizer(tap)
        
        // kvo for frame changes
        
        addObserver(self, forKeyPath: "frame", options: [], context: nil)
    }
    
    private func resizeViews() {
        
        let plusBtnSide = bounds.height
        
        plusBtnViewV.frame = CGRect(x: frame.origin.x + (frame.size.width - plusBtnLineWidth) / 2.0 ,
                                    y: frame.origin.y + plusBtnPadding,
                                    width: plusBtnLineWidth, height: plusBtnSide - plusBtnPadding * 2)
        plusBtnViewH.frame = CGRect(x: frame.origin.x + plusBtnPadding,
                                    y: frame.origin.y + (frame.size.height - plusBtnLineWidth) / 2.0,
                                    width: plusBtnSide - plusBtnPadding * 2, height: plusBtnLineWidth)
        
        //initial frame
        
        plusBtnViewVInitFrame = plusBtnViewV.frame
    }
    
    // MARK: - Observer
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (object is PlusBtnView) && (keyPath == "frame") {
            resizeViews()
        }
    }
    
    // MARK: - Actions
    
    func plusBtnTapped(gesture: UITapGestureRecognizer) {
        
        switchBtn(toState: !plusBtnSelected)
    }
    
    func switchBtn(toState: Bool) {
        
        plusBtnSelected = toState
        
        if plusBtnSelected {
            animateForwardStep1()
        } else {
            animateBackwardStep1()
        }
    }

    // MARK: - Animation
    
    func animateForwardStep1() {
        
        delegate?.plusBtnViewWillChangeState(to: true, step: 1)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.plusBtnViewV.frame = CGRect(x: self.plusBtnViewV.frame.origin.x,
                                             y: self.subMenuView.frame.origin.y,
                                             width: self.plusBtnLineWidth, height: self.subMenuView.frame.height)
            self.plusBtnViewV.backgroundColor = self.subMenuView.backgroundColor
            
        }, completion: { status in
            
            self.subMenuView.isHidden = false
            self.plusBtnViewV.isHidden = true
            
            self.animateForwardStep2()
        })
    }
    
    func animateForwardStep2() {
        
        delegate?.plusBtnViewWillChangeState(to: true, step: 2)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.subMenuView.frame = self.subMenuViewInitFrame
            for view in self.subMenuView.subviews { view.alpha = 1.0 }
            
            self.subMenuView.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    func animateBackwardStep1() {
        
        delegate?.plusBtnViewWillChangeState(to: false, step: 1)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.subMenuView.frame = CGRect(x: self.subMenuViewInitFrame.origin.x + self.subMenuViewInitFrame.width / 2.0,
                                            y: self.subMenuViewInitFrame.origin.y,
                                            width: self.plusBtnLineWidth, height: self.subMenuViewInitFrame.height)
            for view in self.subMenuView.subviews { view.alpha = 0.0 }
            
            self.subMenuView.layoutIfNeeded()
            
        }, completion: { status in
            
            self.plusBtnViewV.isHidden = false
            self.subMenuView.isHidden = true
            
            self.animateBackwardStep2()
        })
    }
    
    func animateBackwardStep2() {
        
        delegate?.plusBtnViewWillChangeState(to: false, step: 2)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.plusBtnViewV.frame = self.plusBtnViewVInitFrame
            self.plusBtnViewV.backgroundColor = self.plusBtnColor
            
        }, completion: nil)
    }
}
