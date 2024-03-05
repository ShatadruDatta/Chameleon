//
//  AppDelegate.swift
//  expaTPA
//
//  Created by Shatadru Datta on 11/03/20.
//  Copyright © 2020 Procentris. All rights reserved.
//



import UIKit

//@available(iOS 13.0, *)
class LaunchController: BaseViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.mainContainerViewController!.bottomConstraint.constant = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: false, content: "")
        NavigationHelper.helper.tabBarViewController?.isShowBottomBar(isShow: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.moveToIntroPage()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func moveToIntroPage() {
        let introVC = mainStoryboard.instantiateViewController(withIdentifier: "IntroController") as! IntroController
        NavigationHelper.helper.contentNavController!.pushViewController(introVC, animated: true)
        
//        let introVC = mainStoryboard.instantiateViewController(withIdentifier: "WorkViewController") as! WorkViewController
//        NavigationHelper.helper.contentNavController!.pushViewController(introVC, animated: true)
    }
}
