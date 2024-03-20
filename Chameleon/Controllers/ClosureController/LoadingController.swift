//
//  LoadingController.swift
//  Chameleon
//
//  Created by Shatadru Datta on 20/03/24.
//

import UIKit

class LoadingController: BaseViewController {

    @IBOutlet weak var viewChooseMode: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblContext: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var didRemove:((_ txt: String) -> ())?
    var didSubmitVal:((_ contextVal: String) -> ())?
   
   override func viewDidLoad() {
       super.viewDidLoad()
       NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
       // Do any additional setup after loading the view.
       loadingView.layer.cornerRadius = 20.0
       loadingView.layer.masksToBounds = true
   }
   
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       self.activity.startAnimating()
   }
       
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.activity.stopAnimating()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier"), object: nil)
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.didSubmitValue(contextVal: "Dismiss")
    }
    
    
    
    // MARK: Convert lines drawable to image
    func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return img
    }
    
 
    internal class func showAddOrClearPopUp(sourceViewController: UIViewController, text: String, didSubmit: @escaping ((_ contextVal: String) -> ()), didFinish: @escaping ((_ txt: String) -> ())) {
        let commentPopVC = mainStoryboard.instantiateViewController(withIdentifier: "LoadingController") as! LoadingController
        commentPopVC.didSubmitVal = didSubmit
        commentPopVC.didRemove = didFinish
        commentPopVC.presentAddOrClearPopUpWith(sourceController: sourceViewController, text: text)
    }
    
    func presentAddOrClearPopUpWith(sourceController: UIViewController, text: String) {
        self.view.frame = sourceController.view.bounds
        sourceController.view.addSubview(self.view)
        sourceController.addChild(self)
        sourceController.view.bringSubviewToFront(self.view)
        presentAnimationToView(text: text)
    }
    
    // MARK: - Animation
    func presentAnimationToView(text: String) {
        self.imgView.alpha = 0
        self.lblContext.text = text
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
