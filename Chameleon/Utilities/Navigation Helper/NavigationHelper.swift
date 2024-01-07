//
//  AppDelegate.swift
//  expaTPA
//
//  Created by Shatadru Datta on 11/03/20.
//  Copyright © 2020 Procentris. All rights reserved.
//

import UIKit

class NavigationHelper: NSObject {
    
    static let helper = NavigationHelper()
    private override init() {}
    
    var navController: UINavigationController!
    var contentNavController: ContentNavigationController?
    var headerViewController: HeaderViewController?
    var tabBarViewController: TabBarController?
    var mainContainerViewController: MainContainerController?
    var menuView = UIView()
    var menuWidth: CGFloat?
    var blurLayer: UIView?
    var isOpen = false
    
    var enableSideMenuSwipe = true // Make it false in view will appear to disable swipr to open menu feature
    var didOpen: ((_ open: Bool) -> ())?
    var reloadData: (() -> ())?
    var logout:(() -> ())?
    var reloadTabBarComponent: (() -> ())?
    
    var currentViewController: UIViewController? {
        return contentNavController?.viewControllers.last!
    }

    internal func navigateToViewController(isSpeciality: Bool, index: Int) {
        navController.popViewController(animated: true)
    }
}



//MARK:- NavigationHelper
extension NavigationHelper {
    
    func setUpSideMenu(view: UIView, blurView: UIView, menuWidth: CGFloat) {
        menuView = view
        blurLayer = blurView
        self.menuWidth = menuWidth
        view.translatesAutoresizingMaskIntoConstraints = true
       // view.frame = CGRect(x: navController.view.bounds.width, y: 64, width: self.menuView.bounds.width, height: navController.view.bounds.height - 64)
        view.frame = CGRect(x: -navController.view.bounds.width, y: 0, width: self.menuView.bounds.width, height: navController.view.bounds.height)
        navController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(NavigationHelper.panDidMoved(gesture:))))
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NavigationHelper.didTap(gesture:))))
    }
    
    func reloadMenu() {
        if (reloadData != nil) {
            reloadData!()
        }
    }
    
    func logoutFromApp() {
        if (logout != nil) {
            logout!()
        }
    }
   
    
    func openSidePanel(open: Bool) {
        NavigationHelper.helper.mainContainerViewController?.view.bringSubviewToFront(blurLayer!)
        NavigationHelper.helper.mainContainerViewController?.view.bringSubviewToFront(menuView)
        if open {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.blurLayer?.alpha = 0.5
                // self.menuView.frame = CGRectMake(CGRectGetWidth(self.navController.view.bounds) - self.menuWidth!, 64, CGRectGetWidth(self.menuView.bounds), CGRectGetHeight(self.menuView.bounds))
                self.menuView.frame = CGRect(x: 0, y: 0, width: self.menuView.bounds.width, height: self.menuView.bounds.height)
            }, completion: { (completed) in
                if self.didOpen != nil && !self.isOpen {
                    self.didOpen!(true)
                }
                self.isOpen = true
            })
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.blurLayer?.alpha = 0
                //  self.menuView.frame = CGRectMake(CGRectGetWidth(self.navController.view.bounds), 64, CGRectGetWidth(self.menuView.bounds), CGRectGetHeight(self.menuView.bounds))
                self.menuView.frame = CGRect(x: -self.navController.view.bounds.width, y: 0, width: self.menuView.bounds.width, height: self.menuView.bounds.height)
            }, completion: { (completed) in
                if self.didOpen != nil && self.isOpen {
                    self.didOpen!(false)
                }
                self.isOpen = false
            })
        }
    }
    
    @objc func panDidMoved(gesture: UIPanGestureRecognizer) {
        
        if enableSideMenuSwipe {
            let translationInView = gesture.translation(in: navController.view)
            
            switch gesture.state {
            case .began:
                NavigationHelper.helper.mainContainerViewController?.view.bringSubviewToFront(blurLayer!)
                NavigationHelper.helper.mainContainerViewController?.view.bringSubviewToFront(menuView)
            case .changed:
                
                let movingx = menuView.center.x + translationInView.x;
                
                if ((navController.view.frame.width - movingx) > -self.menuWidth! / 2 && (navController.view.frame.width - movingx) < self.menuWidth! / 2) {
                    
                    menuView.center = CGPoint(x: movingx, y: menuView.center.y);
                    gesture.setTranslation(CGPoint(x: 0, y: 0), in: navController.view)
                    let changingAlpha = 0.5 / menuWidth! * (navController.view.frame.width - movingx) + 0.5 / 2; // y=mx+c
                    blurLayer?.alpha = changingAlpha
                }
            case .ended:
                if (menuView.center.x > navController.view.frame.width) {
                    openSidePanel(open: false)
                } else if (menuView.center.x < navController.view.frame.width) {
                    openSidePanel(open: true)
                }
            default: break
            }
        }
    }
    
    @objc func didTap(gesture: UITapGestureRecognizer) {
        openSidePanel(open: false)
    }
    
    func checkLoginPage() -> Bool {
        if let login = OBJ_FOR_KEY(key: "IS_LOGIN") {
            if login == "1" {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func checkWelcomePage() -> Bool {
        if let login = OBJ_FOR_KEY(key: "welcome") {
            if login == "1" {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func checkDontAskCode() -> Bool {
        if let login = OBJ_FOR_KEY(key: "chk_code") {
            if login == "1" {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func isFirstTime() -> Bool {
        if let startPage = OBJ_FOR_KEY(key: "IS_START") {
            if startPage == "1" {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
}






