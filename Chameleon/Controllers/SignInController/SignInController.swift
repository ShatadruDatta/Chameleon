//
//  SignInController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 29/12/23.
//

import UIKit
import Alamofire

class SignInController: BaseViewController {

    @IBOutlet weak var txtUsername: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    @IBOutlet weak var btnEye: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtUsername.layer.cornerRadius = 24.0
        self.txtPassword.layer.cornerRadius = 24.0
        
//        let baseurl = "https://engapi.chameleonerp.net/dev/v1/token?accesskey=VzEzfHBhc3N3b3Jk"
//        print(baseurl)
//        let headers = ["x-api-key" : "EAIa6X1ZCF7uNV1VG7IZk1upaWw5xNed1uJUsf7G"]
//        AFWrapper.requestGETURL(baseurl, headers: headers) { jsonVal in
//            
//            print(jsonVal)
//            if jsonVal["ResponseCode"].intValue == 200 {
//               
//            }
//            
//        } failure: { error in
//            
//            print(error)
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: false, content: "")
        NavigationHelper.helper.tabBarViewController?.isShowBottomBar(isShow: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func signin(_ sender: UIButton) {
        let workViewVC = mainStoryboard.instantiateViewController(withIdentifier: "WorkViewController") as! WorkViewController
        NavigationHelper.helper.contentNavController!.pushViewController(workViewVC, animated: true)
    }
    
}

// MARK: TextFieldDelegate
extension SignInController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
