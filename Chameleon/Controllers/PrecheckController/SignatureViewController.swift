//
//  SignatureViewController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 05/03/24.
//

import UIKit

class SignatureViewController: BaseViewController {

    @IBOutlet weak var viewChooseMode: UIView!
    @IBOutlet weak var signatureView: SignatureView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var didRemove:((_ txt: String) -> ())?
    var didSubmitVal:((_ imageSign: UIImage, _ lines: [Line], _ signView: UIView) -> ())?
   
   override func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view.
       btnDone.backgroundColor = UIColor.blueColor
       btnDone.setTitleColor(.white, for: .normal)
       btnDone.setTitleColor(.white, for: .normal)
       btnDone.layer.borderWidth = 1.0
       btnDone.layer.borderColor = UIColor.white.cgColor
       btnDone.layer.cornerRadius = 17.5
       btnCancel.layer.borderWidth = 1.0
       btnCancel.layer.borderColor = UIColor.white.cgColor
       btnCancel.layer.cornerRadius = 17.5
       signatureView.layer.cornerRadius = 15.0
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
    
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismissAnimate(val: "Cancel")
    }
    
    @IBAction func done(_ sender: UIButton) {
        if signatureView.lines.count > 0 {
            self.didSubmitValue(imageSign: self.imageWithView(view: signatureView), lines: signatureView.lines, signView: signatureView)
        } else {
            self.presentAlertWithTitle(title: APP_TITLE, message: "Please sign the document properly!")
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        signatureView.clear()
    }
    
    // MARK: Convert lines drawable to image
    func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return img
    }
    
 
    internal class func showAddOrClearPopUp(sourceViewController: UIViewController, didSubmit: @escaping ((_ imageSign: UIImage, _ lines: [Line], _ signView: UIView) -> ()), didFinish: @escaping ((_ txt: String) -> ())) {
        
        let commentPopVC = mainStoryboard.instantiateViewController(withIdentifier: "SignatureViewController") as! SignatureViewController
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
    
    func didSubmitValue(imageSign: UIImage, lines: [Line], signView: UIView) {
        if didSubmitVal != nil {
            didSubmitVal!(imageSign, lines, signView)
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.viewChooseMode.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        }) { (true) in
            self.view.removeFromSuperview();
            self.removeFromParent()
        }
    }
}
