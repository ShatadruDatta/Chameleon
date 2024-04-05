//
//  ProfileViewController.swift
//  Chameleon
//
//  Created by Shatadru Datta on 28/03/24.
//

import UIKit

struct ProfileData {
    static var firstName: String = ""
    static var lastName: String = ""
    static var code: Int = 0
    static var mobNo: String = ""
    static var emailAdd: String = ""
    static var imgProf_base64: String = ""
    static var imgProf: UIImage = UIImage()
}

class ProfileViewController: BaseViewController {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // PROFILE SCREEN ALL BUTTON USER INTERACTION IS DISABLED FROM STORYBOARD PLEASE ENSURE ENABLED ON WORKING PROFILE UPDATE RELATED TASKS
        imgProfile.layer.cornerRadius = 82.0
        imgProfile.layer.borderWidth = 3.0
        imgProfile.layer.borderColor = UIColor.white.cgColor
        btnBack.layer.cornerRadius = 5.0
        if ProfileData.firstName.count == 0 || ProfileData.imgProf_base64.count == 0 {
            self.profileAPI()
        } else {
            let dataDecoded: NSData = NSData(base64Encoded: ProfileData.imgProf_base64, options: NSData.Base64DecodingOptions(rawValue: 0))!
            ProfileData.imgProf = UIImage(data: dataDecoded as Data)!
            self.imgProfile.image = ProfileData.imgProf
            self.tblProfile.reloadData()
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        // PROFILE SCREEN ALL BUTTON USER INTERACTION IS DISABLED FROM STORYBOARD PLEASE ENSURE ENABLED ON WORKING PROFILE UPDATE RELATED TASKS
        NavigationHelper.helper.contentNavController!.popViewController(animated: true)
    }
    
    @IBAction func btnCamera(_ sender: UIButton) {
        // PROFILE SCREEN ALL BUTTON USER INTERACTION IS DISABLED FROM STORYBOARD PLEASE ENSURE ENABLED ON WORKING PROFILE UPDATE RELATED TASKS
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.imgProfile.image = image
            DispatchQueue.background(background: {
                ProfileData.imgProf_base64 = image.toBase64() ?? ""
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
            let headers = ["x-api-key" : apiKey, "x-token": Chameleon.token]
            AFWrapper.requestGETURL(baseurl, headers: headers) { jsonVal, _  in
                print(jsonVal)
                self.activity.stopAnimating()
                if jsonVal["result"]["id"].intValue > 0 {
                    ProfileData.firstName = jsonVal["result"]["first_name"].stringValue
                    ProfileData.lastName = jsonVal["result"]["last_name"].stringValue
                    ProfileData.mobNo = jsonVal["result"]["mobile"].stringValue
                    ProfileData.emailAdd = jsonVal["result"]["email"].stringValue
                    ProfileData.code = jsonVal["result"]["id"].intValue
                    if jsonVal["result"]["image"].stringValue.count > 0 {
                        ProfileData.imgProf_base64 = jsonVal["result"]["image"].stringValue
                        let dataDecoded: NSData = NSData(base64Encoded: ProfileData.imgProf_base64, options: NSData.Base64DecodingOptions(rawValue: 0))!
                        ProfileData.imgProf = UIImage(data: dataDecoded as Data)!
                        self.imgProfile.image = ProfileData.imgProf
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
            cellFirstName.txtField.text = ProfileData.firstName
            cellFirstName.didEndWriteTextEngName = { val in
                ProfileData.firstName = val
            }
            return cellFirstName
        case 1:
            let cellLastName = self.tblProfile.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
            cellLastName.datasource = "name_icon" as AnyObject
            cellLastName.lblTitle.text = "Last Name"
            cellLastName.txtField.placeholder = "Last Name"
            cellLastName.txtField.text = ProfileData.lastName
            cellLastName.didEndWriteTextEngName = { val in
                ProfileData.lastName = val
            }
            return cellLastName
        case 2:
            let cellMobNo = self.tblProfile.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
            cellMobNo.datasource = "call_icon" as AnyObject
            cellMobNo.lblTitle.text = "Mobile Number"
            cellMobNo.txtField.placeholder = "Mobile Number"
            cellMobNo.txtField.text = ProfileData.mobNo
            cellMobNo.didEndWriteTextEngName = { val in
                ProfileData.mobNo = val
            }
            return cellMobNo
        case 3:
            let cellEmailAdd = self.tblProfile.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
            cellEmailAdd.datasource = "mail_icon" as AnyObject
            cellEmailAdd.lblTitle.text = "Email Address"
            cellEmailAdd.txtField.placeholder = "Email Address"
            cellEmailAdd.txtField.text = ProfileData.emailAdd
            cellEmailAdd.didEndWriteTextEngName = { val in
                ProfileData.emailAdd = val
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
        if !ProfileData.firstName.isEmpty {
            if !ProfileData.lastName.isEmpty {
                if !ProfileData.mobNo.isEmpty {
                    if !ProfileData.emailAdd.isEmpty {
                        
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
