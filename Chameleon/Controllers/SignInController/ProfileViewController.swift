//
//  ProfileViewController.swift
//  Chameleon
//
//  Created by Shatadru Datta on 28/03/24.
//

import UIKit

class ProfileViewController: BaseViewController {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    var firstName = ""
    var lastName = ""
    var mobNo = ""
    var emailAdd = ""
    var imgProf: UIImage = UIImage()
    var imgProf_base64 = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.layer.cornerRadius = 82.0
        imgProfile.layer.borderWidth = 3.0
        imgProfile.layer.borderColor = UIColor.white.cgColor
        btnBack.layer.cornerRadius = 5.0
        self.profileAPI()
    }
    
    @IBAction func back(_ sender: UIButton) {
        NavigationHelper.helper.contentNavController!.popViewController(animated: true)
    }
    
    @IBAction func btnCamera(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.imgProfile.image = image
            DispatchQueue.background(background: {
                self.imgProf_base64 = image.toBase64() ?? ""
            }, completion:{
            })
        }
    }
    
    // MARK: Profile API
    @objc func profileAPI() {
        if Reachability.isConnectedToNetwork() {
            activity.startAnimating()
            let baseurl = "\(baseurl)/v1/profile"
            print(baseurl)
            let headers = ["x-api-key" : apiKey, "X-Token": Chameleon.token]
            AFWrapper.requestGETURL(baseurl, headers: headers) { jsonVal, _  in
                print(jsonVal)
                self.activity.stopAnimating()
                if jsonVal["result"]["id"].intValue > 0 {
                    self.firstName = jsonVal["result"]["first_name"].stringValue
                    self.lastName = jsonVal["result"]["last_name"].stringValue
                    self.mobNo = jsonVal["result"]["mobile"].stringValue
                    self.emailAdd = jsonVal["result"]["email"].stringValue
                    if jsonVal["result"]["image"].stringValue.count > 0 {
                        self.imgProf_base64 = jsonVal["result"]["image"].stringValue
                        let dataDecoded: NSData = NSData(base64Encoded: self.imgProf_base64, options: NSData.Base64DecodingOptions(rawValue: 0))!
                        self.imgProf = UIImage(data: dataDecoded as Data)!
                        self.imgProfile.image = self.imgProf
                    }
                    self.tblProfile.reloadData()
                } else {
                    SharedClass.sharedInstance.alert(view: self, title: "Failure", message: jsonVal["message"].stringValue)
                }
            } failure: { error in
                self.activity.stopAnimating()
                SharedClass.sharedInstance.alert(view: self, title: "Failure", message: "Something problem!")
                print(error)
            }
        } else {
            NoInternetController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!) { contextVal in } didFinish: { txt in }
        }
    }
}

// MARK: TableViewDelegate, TableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 100.0
        } else {
            return 110.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cellFirstName = self.tblProfile.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
            cellFirstName.datasource = "name_icon" as AnyObject
            cellFirstName.lblTitle.text = "First Name"
            cellFirstName.txtField.placeholder = "First Name"
            cellFirstName.txtField.text = self.firstName
            cellFirstName.didEndWriteTextEngName = { val in
                self.firstName = val
            }
            return cellFirstName
        case 1:
            let cellLastName = self.tblProfile.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
            cellLastName.datasource = "name_icon" as AnyObject
            cellLastName.lblTitle.text = "Last Name"
            cellLastName.txtField.placeholder = "Last Name"
            cellLastName.txtField.text = self.lastName
            cellLastName.didEndWriteTextEngName = { val in
                self.lastName = val
            }
            return cellLastName
        case 2:
            let cellMobNo = self.tblProfile.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
            cellMobNo.datasource = "call_icon" as AnyObject
            cellMobNo.lblTitle.text = "Mobile Number"
            cellMobNo.txtField.placeholder = "Mobile Number"
            cellMobNo.txtField.text = self.mobNo
            cellMobNo.didEndWriteTextEngName = { val in
                self.mobNo = val
            }
            return cellMobNo
        case 3:
            let cellEmailAdd = self.tblProfile.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
            cellEmailAdd.datasource = "mail_icon" as AnyObject
            cellEmailAdd.lblTitle.text = "Email Address"
            cellEmailAdd.txtField.placeholder = "Email Address"
            cellEmailAdd.txtField.text = self.emailAdd
            cellEmailAdd.didEndWriteTextEngName = { val in
                self.emailAdd = val
            }
            return cellEmailAdd
        default:
            let cellSave = self.tblProfile.dequeueReusableCell(withIdentifier: "UserProfileSaveCell", for: indexPath) as! UserProfileSaveCell
            cellSave.datasource = "" as AnyObject
            cellSave.btnSave.addTarget(self, action: #selector(saveProfileData), for: .touchUpInside)
            return cellSave
        }
    }
    
    @objc func saveProfileData() {
        if !self.firstName.isEmpty {
            if !self.lastName.isEmpty {
                if !self.mobNo.isEmpty {
                    if !self.emailAdd.isEmpty {
                        
                    } else {
                        self.presentAlertWithTitle(title: APP_TITLE, message: "Email address is mandatory!")
                    }
                } else {
                    self.presentAlertWithTitle(title: APP_TITLE, message: "Mobile number is mandatory!")
                }
            } else {
                self.presentAlertWithTitle(title: APP_TITLE, message: "Last name is mandatory!")
            }
        } else {
            self.presentAlertWithTitle(title: APP_TITLE, message: "First name is mandatory!")
        }
    }
}

// MARK: UserProfileTableCell
class UserProfileCell: BaseTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var viewTxtField: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var txtField: UITextField!
    var didEndWriteTextEngName:((String) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewTxtField.layer.cornerRadius = 30.0
                imgIcon.image = UIImage(named: datasource as? String ?? "name_icon")
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
            let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        self.didEndWriteTextEngName!(txtAfterUpdate)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: UserProfileSaveCell
class UserProfileSaveCell: BaseTableViewCell {
    @IBOutlet weak var btnSave: UIButton!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                
            }
        }
    }
}
