//
//  ClosureController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 23/01/24.
//

import UIKit

class ClosureController: BaseTableViewController {

    var checkController: Bool = false
    @IBOutlet weak var viewPreCheck: UIView!
    @IBOutlet weak var viewPostCheck: UIView!
    @IBOutlet weak var viewClosure: UIView!
    @IBOutlet weak var btnPreCheck: UIButton!
    @IBOutlet weak var btnPostCheck: UIButton!
    @IBOutlet weak var btnClosure: UIButton!
    @IBOutlet weak var imgPreCheck: UIImageView!
    @IBOutlet weak var imgPostCheck: UIImageView!
    @IBOutlet weak var imgClosure: UIImageView!
    
    //UIView
    @IBOutlet weak var viewJobNo: UIView!
    
    //TextField
    @IBOutlet weak var txtJobNo:UITextField!
    @IBOutlet weak var txtSerialNo: UITextField!
    @IBOutlet weak var txtSimNo: UITextField!
    @IBOutlet weak var txtMobNo: UITextField!
    @IBOutlet weak var txtIMEINo: UITextField!
    @IBOutlet weak var txtCommNo: UITextField!
    @IBOutlet weak var txtGNo: UITextField!
    @IBOutlet weak var txtSupplyColor: UITextField!
    @IBOutlet weak var txtSupplyCircuit: UITextField!
    @IBOutlet weak var txtIGNCircuit: UITextField!
    @IBOutlet weak var txtVLU: UITextField!
    @IBOutlet weak var txtGSM: UITextField!
    @IBOutlet weak var txtGPS: UITextField!
    @IBOutlet weak var txtVHF: UITextField!
    
    //TextView
    @IBOutlet weak var imgClosingNotes: UIImageView!
    @IBOutlet weak var viewClosingNote: UIView!
    @IBOutlet weak var txtViewClosingNotes: UITextView!
    
    //Button
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    //CheckBox
    @IBOutlet weak var imgFMS: UIImageView!
    @IBOutlet weak var imgDigitalTacho: UIImageView!
    @IBOutlet weak var imgPrivacySwitch: UIImageView!
    @IBOutlet weak var imgPTO: UIImageView!
    @IBOutlet weak var imgLightbar: UIImageView!
    @IBOutlet weak var imgBP: UIImageView!
    @IBOutlet weak var imgDriverID: UIImageView!
    @IBOutlet weak var imgCanBus: UIImageView!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var imgProNavDev: UIImageView!
    @IBOutlet weak var imgODB: UIImageView!
    @IBOutlet weak var viewBlueTooth: UIView!
    
    // CheckBox - TextField SerialNo
    @IBOutlet weak var txtCameraSerialNo: UITextField!
    @IBOutlet weak var txtProNavDevSerialNo: UITextField!
    @IBOutlet weak var txtODBSerialNo: UITextField!
    @IBOutlet weak var txtBluetoothSerialNo: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: ClosingNotes
        imgClosure.setImageColor(color: UIColor.blueColor)
        txtViewClosingNotes.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        txtViewClosingNotes.text = "Text Message"
        txtViewClosingNotes.font = UIFont.Poppins(.regular, size: 15.0)
        txtViewClosingNotes.textColor = UIColor.fontColor
        
        // MARK: PreCheck
        viewPreCheck.layer.cornerRadius = 10.0
        viewPreCheck.layer.borderWidth = 1.0
        viewPreCheck.layer.borderColor = UIColor.greenBorderColor.cgColor
        imgPreCheck.setImageColor(color: .white)
        
        // MARK: PostCheck
        viewPostCheck.layer.cornerRadius = 10.0
        viewPostCheck.layer.borderWidth = 1.0
        viewPostCheck.layer.borderColor = UIColor.greenBorderColor.cgColor
        imgPostCheck.setImageColor(color: .white)
        
        // MARK: Closure
        viewClosure.layer.cornerRadius = 10.0
        viewClosure.layer.borderWidth = 1.0
        viewClosure.layer.borderColor = UIColor.yellowBorderColor.cgColor
        imgClosure.setImageColor(color: .white)
        
        // MARK: TextField - JobNo
        txtJobNo.layer.cornerRadius = 25
        
        // MARK: ViewCornerRadius
        viewJobNo.layer.cornerRadius = 25
        viewJobNo.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewBlueTooth.layer.cornerRadius = 25
        viewBlueTooth.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        // MARK: TextField - All Other Fields
        txtSerialNo.layer.cornerRadius = 25.0
        txtSimNo.layer.cornerRadius = 25.0
        txtMobNo.layer.cornerRadius = 25.0
        txtIMEINo.layer.cornerRadius = 25.0
        txtCommNo.layer.cornerRadius = 25.0
        txtGNo.layer.cornerRadius = 25.0
        txtSupplyColor.layer.cornerRadius = 25.0
        txtSupplyCircuit.layer.cornerRadius = 25.0
        txtIGNCircuit.layer.cornerRadius = 25.0
        txtVLU.layer.cornerRadius = 25.0
        txtGSM.layer.cornerRadius = 25.0
        txtGPS.layer.cornerRadius = 25.0
        txtVHF.layer.cornerRadius = 25.0
        
        txtCameraSerialNo.layer.cornerRadius = 25.0
        txtProNavDevSerialNo.layer.cornerRadius = 25.0
        txtODBSerialNo.layer.cornerRadius = 25.0
        txtBluetoothSerialNo.layer.cornerRadius = 25.0
        
        // MARK: TextView - ClosingNotes
        viewClosingNote.layer.cornerRadius = 25
        txtViewClosingNotes.layer.cornerRadius = 20
        
        // MARK: Button
        btnReset.layer.borderWidth = 1.0
        btnReset.layer.cornerRadius = 22.5
        btnReset.layer.borderColor = UIColor.blueColor.cgColor
        btnSave.layer.cornerRadius = 22.5
    }
    
    @IBAction func precheck(_ sender: UIButton) {
        let allViewController: [UIViewController] =  NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
        for aviewcontroller: UIViewController in allViewController {
            if aviewcontroller.isKind(of: PrecheckController.classForCoder()) {
                NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                self.checkController = true
                break
            }
        }
        if self.checkController == false {
            let precheckVC = mainStoryboard.instantiateViewController(withIdentifier: "PrecheckController") as! PrecheckController
            NavigationHelper.helper.contentNavController!.pushViewController(precheckVC, animated: true)
        }
        self.checkController = false
    }
    
    @IBAction func postcheck(_ sender: UIButton) {
        let allViewController: [UIViewController] =  NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
        for aviewcontroller: UIViewController in allViewController {
            if aviewcontroller.isKind(of: PostCheckController.classForCoder()) {
                NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                self.checkController = true
                break
            }
        }
        if self.checkController == false {
            let postcheckVC = mainStoryboard.instantiateViewController(withIdentifier: "PostCheckController") as! PostCheckController
            NavigationHelper.helper.contentNavController!.pushViewController(postcheckVC, animated: true)
        }
        self.checkController = false
    }
    
    @objc func menu(_ sender: UIButton) {
        NavigationHelper.helper.openSidePanel(open: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 26
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 67.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 67))
        let btnHam = UIButton()
        btnHam.frame = CGRect.init(x: 20, y: 10, width: 48, height: 48)
        btnHam.setBackgroundImage(UIImage(named: "Hamburger_btn"), for: .normal)
        btnHam.addTarget(self, action: #selector(menu), for: .touchUpInside)
        let label = UILabel()
        label.frame = CGRect.init(x: 83, y: 0, width: headerView.frame.width-98, height: 67)
        label.text = "NC1234567"
        label.textColor = UIColor.blueColor
        label.textAlignment = .center
        label.font = UIFont.Poppins(.semibold, size: 17.0)
        headerView.addSubview(btnHam)
        headerView.addSubview(label)
        headerView.backgroundColor = UIColor.init(hexString: "#F8F9FF")
        return headerView
    }
}

// MARK: TextFieldDelegate
extension ClosureController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: TextViewDelegate
extension ClosureController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.fontColor {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Text Message"
            textView.textColor = UIColor.fontColor
        }
    }
}

// MARK: CheckBox Button Function
extension ClosureController {
    @IBAction func fms(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgFMS.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgFMS.image = UIImage(named: "check")
        }
    }
    
    @IBAction func digitalTacho(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgDigitalTacho.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgDigitalTacho.image = UIImage(named: "check")
        }
    }
    
    @IBAction func privacySwitch(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgPrivacySwitch.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgPrivacySwitch.image = UIImage(named: "check")
        }
    }
    
    @IBAction func pto(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgPTO.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgPTO.image = UIImage(named: "check")
        }
    }
    
    @IBAction func lightbar(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgLightbar.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgLightbar.image = UIImage(named: "check")
        }
    }
    
    @IBAction func bp(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgBP.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgBP.image = UIImage(named: "check")
        }
    }
    
    @IBAction func driverID(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgDriverID.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgDriverID.image = UIImage(named: "check")
        }
    }
    
    @IBAction func canBus(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgCanBus.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgCanBus.image = UIImage(named: "check")
        }
    }
    
    @IBAction func camera(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgCamera.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgCamera.image = UIImage(named: "check")
        }
    }
    
    @IBAction func proNavDev(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgProNavDev.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgProNavDev.image = UIImage(named: "check")
        }
    }
    
    @IBAction func odb(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgODB.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgODB.image = UIImage(named: "check")
        }
    }
    
    // MARK: Reset
    @IBAction func reset(_ sender: UIButton) {
    }
    
    // MARK: Save
    @IBAction func save(_ sender: UIButton) {
    }
}
