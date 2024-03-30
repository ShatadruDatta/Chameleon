//
//  AppDelegate.swift
//  expaTPA
//
//  Created by Shatadru Datta on 11/03/20.
//  Copyright © 2020 Procentris. All rights reserved.
//

import UIKit

//@available(iOS 13.0, *)
class MenuController: BaseViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tblMenu: UITableView!
    var isOpen = false
    var checkController = false
    var arrMenuSecOne = ["Home", "Edit Profile", "FAQ", "Help"]
    var arrMenuSecTwo = ["Account", "Settings"]
    var arrMenuSecThree = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenu.tableFooterView = UIView()
        NavigationHelper.helper.reloadData = {
            self.tblMenu.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
//@available(iOS 13.0, *)
extension MenuController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return arrMenuSecOne.count
        case 2:
            return arrMenuSecTwo.count
        default:
            return arrMenuSecThree.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewBottomBorder = UIView(frame: CGRect(x: 0, y:0, width: tableView.frame.width, height: 1))
        viewBottomBorder.backgroundColor = section == 3 ? .clear : UIColor.init(hexString: "dddddd")
        return viewBottomBorder
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellProfile = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            cellProfile.datasource = "" as AnyObject
            cellProfile.selectionStyle = .none
            return cellProfile
        } else {
            let cellMenu = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            if indexPath.section == 1 {
                cellMenu.datasource = arrMenuSecOne[indexPath.row] as AnyObject
                if indexPath.row == 0 {
                    cellMenu.btnMenu.addTarget(self, action: #selector(homePage), for: .touchUpInside)
                } else {
                    cellMenu.btnMenu.addTarget(self, action: #selector(profilePage), for: .touchUpInside)
                }
            } else if indexPath.section == 2 {
                cellMenu.datasource = arrMenuSecTwo[indexPath.row] as AnyObject
            } else {
                cellMenu.datasource = arrMenuSecThree[indexPath.row] as AnyObject
                cellMenu.lblMenu.textColor = UIColor.init(hexString: "c22f22")
                cellMenu.btnMenu.addTarget(self, action: #selector(logOut), for: .touchUpInside)
            }
            cellMenu.selectionStyle = .none
            return cellMenu
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90.0
        } else {
            return 60.0
        }
    }
    
    @objc func profilePage() {
        let allViewController: [UIViewController] =  NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
        for aviewcontroller: UIViewController in allViewController
        {
            if aviewcontroller.isKind(of: ProfileViewController.classForCoder())
            {
                NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                self.checkController = true
                break
            }
        }
        
        if self.checkController == false {
            let profPageVC = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            NavigationHelper.helper.contentNavController!.pushViewController(profPageVC, animated: true)
        }
        self.checkController = false
        NavigationHelper.helper.openSidePanel(open: false)
    }
    
    // MARK: HomePage
    @objc func homePage() {
        let allViewController: [UIViewController] =  NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
        for aviewcontroller: UIViewController in allViewController
        {
            if aviewcontroller.isKind(of: WorkViewController.classForCoder())
            {
                NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                self.checkController = true
                break
            }
        }
        
        if self.checkController == false {
            let homePageVC = mainStoryboard.instantiateViewController(withIdentifier: "SignInController") as! WorkViewController
            NavigationHelper.helper.contentNavController!.pushViewController(homePageVC, animated: true)
        }
        self.checkController = false
        NavigationHelper.helper.openSidePanel(open: false)
    }
    
    //MARK: LogOutFunction
    @objc func logOut() {
        let alert = UIAlertController(title: "Chameleon", message: "Do you want to log out?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            self.loggedOut()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: LoggedOut To LoginPage
    @objc func loggedOut() {
        let allViewController: [UIViewController] =  NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
        for aviewcontroller: UIViewController in allViewController
        {
            if aviewcontroller.isKind(of: SignInController.classForCoder())
            {
                NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                self.checkController = true
                break
            }
        }
        
        if self.checkController == false {
            let loginPageVC = mainStoryboard.instantiateViewController(withIdentifier: "SignInController") as! SignInController
            NavigationHelper.helper.contentNavController!.pushViewController(loginPageVC, animated: true)
        }
        self.checkController = false
        NavigationHelper.helper.openSidePanel(open: false)
    }
}

//MARK: MenuCell
class MenuCell: BaseTableViewCell {
    
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgIcon: UIImageView!
    
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                self.lblMenu.text = datasource as? String
                self.imgIcon.image = UIImage(named: datasource as? String ?? "")
            }
        }
    }
}

//MARK: ProdileCell
class ProfileCell: BaseTableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                imgProfile.layer.cornerRadius = 25.0
                imgProfile.backgroundColor = .green
            }
        }
    }
}
