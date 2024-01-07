//
//  IntroController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 29/12/23.
//

import UIKit

class IntroController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func signin(_ sender: UIButton) {
        let signInVC = mainStoryboard.instantiateViewController(withIdentifier: "SignInController") as! SignInController
        NavigationHelper.helper.contentNavController!.pushViewController(signInVC, animated: true)
    }
}
