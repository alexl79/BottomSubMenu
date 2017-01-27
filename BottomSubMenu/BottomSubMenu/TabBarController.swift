//
//  TabBarController.swift
//  BottomSubMenu
//
//  Created by Alexander Lobanov on 23.01.17.
//  Copyright © 2017 iosnik. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    let subMenuViewHeight: CGFloat = 80
    var subMenuView: SubMenuView!
    var plusBtnView: PlusBtnView!
    
    // MARK: - Life Cycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        prepareTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // we need all constraints already updated
        prepareSubMenu()
    }
    
    func prepareTabBar() {
        
        let bgColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        view.backgroundColor = bgColor
        tabBar.backgroundColor = bgColor
        tabBar.backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        
        for item in tabBar.items! {
            item.imageInsets = UIEdgeInsetsMake(5.0, 0, -5.0, 0)
        }
        
        for vc in viewControllers! {
            vc.view.backgroundColor = bgColor
        }
    }
    
    func prepareSubMenu() {
        
        subMenuView = Bundle.main.loadNibNamed(String(describing: SubMenuView.self), owner: self, options: nil)!.first as! SubMenuView!
        subMenuView.isHidden = true
        subMenuView.frame = CGRect(x: view.layoutMargins.left,
                                   y: view.bounds.height - tabBar.bounds.height - subMenuViewHeight,
                                   width: view.bounds.width - view.layoutMargins.left * 2, height: subMenuViewHeight)
        subMenuView.setup()
        subMenuView.delegate = self
        view.addSubview(subMenuView)
        
        // add plus btn
        
        let plusBtnColor = UIColor(red: 170.0/255.0, green: 177.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        plusBtnView = PlusBtnView(side: tabBar.frame.height, alignWithView: tabBar, menuView: subMenuView, color: plusBtnColor)
        plusBtnView.delegate = self
        view.addSubview(plusBtnView)
    }
        
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let oldIdx = tabBarController.selectedIndex
        let newIdx = viewControllers?.index(of: viewController)
        
        if oldIdx != newIdx {
            plusBtnView.switchBtn(toState: false)
        }
        
        return newIdx != 2
    }
    
}

extension TabBarController: PlusBtnViewDelgate {
    
    func plusBtnViewWillChangeState(to: Bool, step: Int) {
        
        let shift = subMenuView.bounds.height + view.layoutMargins.left
        
        if (to && step == 1) || (!to && step == 2) {
            UIView.animate(withDuration: 0.3, animations: {
                for vc in self.viewControllers! as! [ViewController] {
                    vc.scrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: to ? shift : 0.0, right: 0)
                    
                    let offset = vc.scrollView?.contentOffset
                    vc.scrollView?.contentOffset = CGPoint(x: offset!.x, y: offset!.y + (to ? shift : 0.0))
                }
            })
        }
    }
}

extension TabBarController: SubMenuViewDelegate {
    
    func subMenuViewDidSelectItem(idx: Int) {
        
        let alert = UIAlertController(title: "submenu", message: "clicked: \(idx)", preferredStyle: .alert)
        
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.plusBtnView.switchBtn(toState: false)
        })
        alert.addAction(actionOK)
        
        self.present(alert, animated: true, completion: nil)
    }
}
