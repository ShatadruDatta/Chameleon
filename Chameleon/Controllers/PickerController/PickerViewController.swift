//
//  PickerViewController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 01/03/24.
//

import UIKit

class PickerViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var viewChooseMode: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var arrPickerVal: [String] = []
    var didRemove:((_ txt: String) -> ())?
    var didSubmitVal:((_ val: String) -> ())?
    var selectedVal: String = ""
   
   override func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view.
       btnDone.backgroundColor = UIColor.blueColor
       btnDone.setTitleColor(.white, for: .normal)
       btnDone.setTitleColor(.white, for: .normal)
       btnDone.layer.cornerRadius = 17.5
       btnCancel.setTitleColor(.blueColor, for: .normal)
       btnCancel.layer.borderWidth = 1.0
       btnCancel.layer.borderColor = UIColor.blueColor.cgColor
       btnCancel.layer.cornerRadius = 17.5
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
        self.didSubmitValue(val: selectedVal)
    }
    
 
    internal class func showAddOrClearPopUp(sourceViewController: UIViewController, arrPickerVal: [String], didSubmit: @escaping ((_ val: String) -> ()), didFinish: @escaping ((_ txt: String) -> ())) {
        
        let commentPopVC = mainStoryboard.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        commentPopVC.didSubmitVal = didSubmit
        commentPopVC.didRemove = didFinish
        commentPopVC.presentAddOrClearPopUpWith(sourceController: sourceViewController, arrPickerVal: arrPickerVal)
    }
    
    func presentAddOrClearPopUpWith(sourceController: UIViewController, arrPickerVal: [String]) {
        self.view.frame = sourceController.view.bounds
        sourceController.view.addSubview(self.view)
        sourceController.addChild(self)
        sourceController.view.bringSubviewToFront(self.view)
        presentAnimationToView(arrPickerVal: arrPickerVal)
    }
    
    // MARK: - Animation
    func presentAnimationToView(arrPickerVal: [String]) {
        self.imgView.alpha = 0
        selectedVal = arrPickerVal[0]
        self.arrPickerVal = arrPickerVal
        self.viewChooseMode.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.25) {
            self.viewChooseMode.transform = .identity
            self.imgView.alpha = 0.3
        }
    }
    
    func dismissAnimate(val: String) {
        
        if didRemove != nil {
            self.imgView.alpha = 0.3
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
    
    func didSubmitValue(val: String) {
        if didSubmitVal != nil {
            didSubmitVal!(val)
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.viewChooseMode.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        }) { (true) in
            self.view.removeFromSuperview();
            self.removeFromParent()
        }
    }
}

// MARK: PickerViewExtension
extension PickerViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPickerVal[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return arrPickerVal.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedVal = arrPickerVal[row]
    }
}
