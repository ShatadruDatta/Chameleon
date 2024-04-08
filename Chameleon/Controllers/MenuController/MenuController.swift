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
    var arrMenuSecOne = ["Home", "Edit Profile", "FAQ", "Help", "Settings"]
    var arrMenuSecTwo = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenu.tableFooterView = UIView()
        NavigationHelper.helper.reloadData = {
            self.tblMenu.reloadData()
        }
        NavigationHelper.helper.logout = {
            self.loggedOut()
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
        return 3
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return arrMenuSecOne.count
        default:
            return arrMenuSecTwo.count
        }
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
        } else if indexPath.section == 2 {
            let cellLogout = tableView.dequeueReusableCell(withIdentifier: "LogoutCell", for: indexPath) as! LogoutCell
            cellLogout.datasource = "" as AnyObject
            cellLogout.btnLogout.addTarget(self, action: #selector(logOut), for: .touchUpInside)
            return cellLogout
        } else {
            let cellMenu = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            cellMenu.datasource = arrMenuSecOne[indexPath.row] as AnyObject
            cellMenu.selectionStyle = .none
            return cellMenu
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                self.homePage()
            case 1:
                self.profilePage()
            case 2:
                self.faq()
            case 3:
                self.helpPage()
            default:
                self.settingsPage()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200.0
        } else if indexPath.section == 2 {
            return 100.0
        } else {
            return 60.0
        }
    }
    
    @objc func faq() {
        guard let url = URL(string: "https://chameleoncodewing.co.uk/") else {
          return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func helpPage() {
        guard let url = URL(string: "https://chameleoncodewing.co.uk/") else {
          return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func settingsPage() {
        self.presentAlertWithTitle(title: APP_TITLE, message: "Work in progress!!")
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
            let homePageVC = mainStoryboard.instantiateViewController(withIdentifier: "WorkViewController") as! WorkViewController
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
            REMOVE_OBJ_FOR_KEY(key: "TOKEN")
            Chameleon.token = ""
            NavigationHelper.helper.contentNavController!.pushViewController(loginPageVC, animated: true)
        }
        self.checkController = false
        NavigationHelper.helper.openSidePanel(open: false)
    }
}

//MARK: MenuCell
class MenuCell: BaseTableViewCell {
    
    @IBOutlet weak var lblMenu: UILabel!
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
    @IBOutlet weak var lblEnggId: UILabel!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                imgProfile.layer.cornerRadius = 50.0
                imgProfile.layer.borderWidth = 4.0
                imgProfile.layer.borderColor = UIColor.white.cgColor
                if ProfileData.imgProf_base64.count > 0 {
                    let dataDecoded: NSData = NSData(base64Encoded: ProfileData.imgProf_base64, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    ProfileData.imgProf = UIImage(data: dataDecoded as Data)!
                    imgProfile.image = ProfileData.imgProf
                }
                lblTitle.text = "\(ProfileData.firstName) \(ProfileData.lastName)"
                lblSubTitle.text = "Engineer"
                lblEnggId.text = "User ID \(ProfileData.code)"
            }
        }
    }
}


//MARK: LogoutCell
class LogoutCell: BaseTableViewCell {
    
    @IBOutlet weak var btnLogout: UIButton!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
            }
        }
    }
}
