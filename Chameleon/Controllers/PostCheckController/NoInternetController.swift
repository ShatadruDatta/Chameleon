//
//  NoInternetController.swift
//  Chameleon
//
//  Created by Shatadru Datta on 26/03/24.
//

import UIKit

class NoInternetController: BaseViewController {

    @IBOutlet weak var viewChooseMode: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnTryAgain: UIButton!
    var didRemove:((_ txt: String) -> ())?
    var didSubmitVal:((_ contextVal: String) -> ())?
   
   override func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view.
       loadingView.layer.cornerRadius = 20.0
       loadingView.layer.masksToBounds = true
       btnTryAgain.layer.cornerRadius = 10.0
       btnTryAgain.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
   }
   
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
   }
       
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func tryAgain(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() {
            self.didSubmitValue(contextVal: "Dismiss")
        } else {
            self.presentAlertWithTitle(title: "No Internet Connection", message: "Network still no available!")
        }
    }
    
    // MARK: Convert lines drawable to image
    func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return img
    }
    
 
    internal class func showAddOrClearPopUp(sourceViewController: UIViewController, didSubmit: @escaping ((_ contextVal: String) -> ()), didFinish: @escaping ((_ txt: String) -> ())) {
        let commentPopVC = mainStoryboard.instantiateViewController(withIdentifier: "NoInternetController") as! NoInternetController
        commentPopVC.didSubmitVal = didSubmit
        commentPopVC.didRemove = didFinish
        commentPopVC.presentAddOrClearPopUpWith(sourceController: sourceViewController)
    }
    
    func presentAddOrClearPopUpWith(sourceController: UIViewController) {
        self.view.frame = sourceController.view.bounds
        sourceController.view.addSubview(self.view)
        sourceController.addChild(self)
        sourceController.view.bringSubviewToFront(self.view)
        presentAnimationToView()
    }
    
    // MARK: - Animation
    func presentAnimationToView() {
        self.imgView.alpha = 0
        self.viewChooseMode.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.25) {
            self.viewChooseMode.transform = .identity
            self.imgView.alpha = 0.8
        }
    }
    
    func dismissAnimate(val: String) {
        
        if didRemove != nil {
            self.imgView.alpha = 0.8
            UIView.animate(withDuration: 0.25) {
                self.didRemove!(val)
                self.imgView.alpha = 0
            }
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.viewChooseMode.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        }) { (true) in
            self.view.removeFromSuperview();
            self.removeFromParent()
        }
    }
    
    func didSubmitValue(contextVal: String) {
        if didSubmitVal != nil {
            didSubmitVal!(contextVal)
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.viewChooseMode.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        }) { (true) in
            self.view.removeFromSuperview();
            self.removeFromParent()
        }
    }
}
