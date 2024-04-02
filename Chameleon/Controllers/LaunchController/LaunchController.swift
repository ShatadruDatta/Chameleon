//
//  AppDelegate.swift
//  expaTPA
//
//  Created by Shatadru Datta on 11/03/20.
//  Copyright © 2020 Procentris. All rights reserved.
//



import UIKit

//@available(iOS 13.0, *)
class LaunchController: BaseViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.mainContainerViewController!.bottomConstraint.constant = 0
        DispatchQueue.background(background: {
            // do something in background
            self.productAPI()
        }, completion:{
            // when background job finished, do something in main thread
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: false, content: "")
        NavigationHelper.helper.tabBarViewController?.isShowBottomBar(isShow: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.moveToSignInPage()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: ProductAPI
    @objc func productAPI() {
        let baseurl = "\(baseurl)/v1/product"
        print(baseurl)
        let headers = ["x-api-key" : apiKey]
        AFWrapper.requestGETURL(baseurl, headers: headers) { [self] jsonVal, data in
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(ProductModels.self, from: data)
                ProductParts.shared.prodModels = data
            } catch {
                SharedClass.sharedInstance.alert(view: self, title: "Failure", message: jsonVal["message"].stringValue)
            }
        } failure: { error in
            SharedClass.sharedInstance.alert(view: self, title: "Failure", message: error.localizedDescription)
        }
    }
    
    @objc func moveToSignInPage() {
        let signInVC = mainStoryboard.instantiateViewController(withIdentifier: "SignInController") as! SignInController
        NavigationHelper.helper.contentNavController!.pushViewController(signInVC, animated: true)
    }
}
