//
//  IntroController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 29/12/23.
//

import UIKit

class ProductParts: ObservableObject {
    @Published var prodModels: ProductModels?
    static var shared = ProductParts.init()
    private init() { }
}


class IntroController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.background(background: {
            // do something in background
            self.productAPI()
        }, completion:{
            // when background job finished, do something in main thread
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @IBAction func signin(_ sender: UIButton) {
        let signInVC = mainStoryboard.instantiateViewController(withIdentifier: "SignInController") as! SignInController
        NavigationHelper.helper.contentNavController!.pushViewController(signInVC, animated: true)
        
//        let signInVC = mainStoryboard.instantiateViewController(withIdentifier: "WorkReportController") as! WorkReportController
//        NavigationHelper.helper.contentNavController!.pushViewController(signInVC, animated: true)
    }
}
