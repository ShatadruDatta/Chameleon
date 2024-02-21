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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtUsername.layer.cornerRadius = 24.0
        self.txtPassword.layer.cornerRadius = 24.0
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

    @IBAction func signin(_ sender: UIButton) {
        self.checkCred()
    }
    
    @objc func checkCred() {
        if txtUsername.text != "" {
            if txtPassword.text != "" {
                self.generateToken()
            } else {
                SharedClass.sharedInstance.alert(view: self, title: APP_TITLE, message: "Please enter password")
            }
        } else {
            SharedClass.sharedInstance.alert(view: self, title: APP_TITLE, message: "Please enter username")
        }
    }
    
    // MARK: GenerateToken API
    @objc func generateToken() {
        activity.startAnimating()
        let baseurl = "\(baseurl)/v1/token?\(accessDefaultKey)"
        print(baseurl)
        let headers = ["x-api-key" : apiKey]
        AFWrapper.requestGETURL(baseurl, headers: headers) { [self] jsonVal in
            print(jsonVal)
            let username = txtUsername.text
            let password = txtPassword.text
            let credBase64 = "\(username ?? "")|\(password ?? "")".toBase64()
            self.signInApi(usernamePasswordBase64: credBase64, token: jsonVal["token"].stringValue)
        } failure: { error in
            print(error)
        }
    }
    
    // MARK: SignIn API
    @objc func signInApi(usernamePasswordBase64: String, token: String) {
        let baseurl = "\(baseurl)/v1/token?\(accessParam)\(usernamePasswordBase64)"
        print(baseurl)
        let headers = ["x-api-key" : apiKey, "token": Chameleon.token]
        AFWrapper.requestGETURL(baseurl, headers: headers) { jsonVal in
            print(jsonVal)
            self.activity.stopAnimating()
            Chameleon.token = jsonVal["token"].stringValue
            DispatchQueue.main.async {
                let workViewVC = mainStoryboard.instantiateViewController(withIdentifier: "WorkViewController") as! WorkViewController
                NavigationHelper.helper.contentNavController!.pushViewController(workViewVC, animated: true)
            }
        } failure: { error in
            print(error)
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
