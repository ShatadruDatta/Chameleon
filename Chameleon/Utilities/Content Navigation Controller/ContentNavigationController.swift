//
//  AppDelegate.swift
//  expaTPA
//
//  Created by Shatadru Datta on 11/03/20.
//  Copyright © 2020 Procentris. All rights reserved.
//


import UIKit

class ContentNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.contentNavController = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
