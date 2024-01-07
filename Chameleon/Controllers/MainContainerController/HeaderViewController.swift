//
//  AppDelegate.swift
//  expaTPA
//
//  Created by Shatadru Datta on 11/03/20.
//  Copyright © 2020 Procentris. All rights reserved.
//

let notificationName = Notification.Name("ChangedLanguage")

import UIKit

class HeaderViewController: UIViewController {

    var didSetLang:((Bool) -> ())!
    var isBack = false
    var checkController = false
    var controller: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.headerViewController = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //.........
    func isShowNavBar(isShow: Bool, content: String) {
        if isShow == true {
            NavigationHelper.helper.mainContainerViewController!.headerHeightConstraint.constant = DeviceType.IS_IPAD ? 74.0 : (content == "StripList" ? 74.0 : 54.0)
            NavigationHelper.helper.mainContainerViewController!.view.layoutIfNeeded()
        } else {
            NavigationHelper.helper.mainContainerViewController!.headerHeightConstraint.constant = 0
            NavigationHelper.helper.mainContainerViewController!.view.layoutIfNeeded()
        }
    }
    
}
