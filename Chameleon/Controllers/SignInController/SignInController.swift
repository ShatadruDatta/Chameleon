//
//  SignInController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 29/12/23.
//

struct Chameleon {
    static var token = ""
}

import UIKit
import Alamofire

class SignInController: BaseViewController {
    @IBOutlet weak var txtUsername: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var lblVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtUsername.layer.cornerRadius = 24.0
        self.txtPassword.layer.cornerRadius = 24.0
        btnEye.isSelected = true
        btnEye.setImage(UIImage(named: "eye_close"), for: .normal)
        txtPassword.isSecureTextEntry = true
        self.lblVersion.text = "Version: \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1.0")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: false, content: "")
        NavigationHelper.helper.tabBarViewController?.isShowBottomBar(isShow: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        txtUsername.text = ""
        txtPassword.text = ""
    }
    
    @IBAction func hideClose(_ sender: UIButton) {
        if btnEye.isSelected {
            btnEye.isSelected = false
            btnEye.setImage(UIImage(named: "eye"), for: .normal)
            txtPassword.isSecureTextEntry = false
        } else {
            btnEye.isSelected = true
            btnEye.setImage(UIImage(named: "eye_close"), for: .normal)
            txtPassword.isSecureTextEntry = true
        }
    }

    @IBAction func signin(_ sender: UIButton) {
        self.checkCred()
    }
    
    @objc func checkCred() {
        if txtUsername.text != "" {
            if txtPassword.text != "" {
                let username = txtUsername.text
                let password = txtPassword.text
                let credBase64 = "\(username ?? "")|\(password ?? "")".toBase64()
                self.signInApi(usernamePasswordBase64: credBase64)
            } else {
                SharedClass.sharedInstance.alert(view: self, title: APP_TITLE, message: "Please enter password")
            }
        } else {
            SharedClass.sharedInstance.alert(view: self, title: APP_TITLE, message: "Please enter username")
        }
    }
    
    // MARK: SignIn API
    @objc func signInApi(usernamePasswordBase64: String) {
        if Reachability.isConnectedToNetwork() {
            activity.startAnimating()
            let baseurl = "\(baseurl)/v1/token?\(accessParam)\(usernamePasswordBase64)"
            print(baseurl)
            let headers = ["x-api-key": apiKey]
            AFWrapper.requestGETURL(baseurl, headers: headers) { jsonVal, _  in
                print(jsonVal)
                self.activity.stopAnimating()
                Chameleon.token = jsonVal["token"].stringValue
                DispatchQueue.main.async {
                    let workViewVC = mainStoryboard.instantiateViewController(withIdentifier: "WorkViewController") as! WorkViewController
                    NavigationHelper.helper.contentNavController!.pushViewController(workViewVC, animated: true)
                }
            } failure: { error in
                self.activity.stopAnimating()
                SharedClass.sharedInstance.alert(view: self, title: "Failure", message: "Please try again with proper credentials")
                print(error)
            }
        } else {
            NoInternetController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!) { contextVal in } didFinish: { txt in }
        }
    }
}

// MARK: TextFieldDelegate
extension SignInController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUsername {
            txtPassword.becomeFirstResponder()
            return false
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
}
