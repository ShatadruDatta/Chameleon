//
//  AppDelegate.swift
//  expaTPA
//
//  Created by Shatadru Datta on 11/03/20.
//  Copyright © 2020 Procentris. All rights reserved.
//


import UIKit
import SwiftyJSON

class MainContainerController: UIViewController {

    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.mainContainerViewController = self
        headerHeightConstraint.constant = 0
        tabBarHeightConstraint.constant = 0
        menuContainer.translatesAutoresizingMaskIntoConstraints = true
        menuContainer.frame = CGRect(x: self.view.bounds.width * 0.3, y: 0, width: self.view.bounds.width * 0.7, height: self.view.bounds.height )
        NavigationHelper.helper.setUpSideMenu(view: menuContainer, blurView: blurView, menuWidth: self.view.bounds.width * 0.7)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "HeaderControllerEmbedSegue")
        {
            //NavigationHelper.helper.headerViewController = ((sender as AnyObject).destination as? HeaderViewController)!
        }
        else if (segue.identifier == "MainNavigationControllerEmbedSegue")
        {}
        else if (segue.identifier == "TabBarControllerEmbedSegue")
        {}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



