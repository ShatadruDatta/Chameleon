//
//  ClosureController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 23/01/24.
//

import UIKit

class ClosureController: BaseTableViewController {

    var imageUploadCounter = 0
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
    var isFms: Bool = false
    @IBOutlet weak var imgDigitalTacho: UIImageView!
    var isDigitalTacho: Bool = false
    @IBOutlet weak var imgPrivacySwitch: UIImageView!
    var isPrivacySwitch: Bool = false
    @IBOutlet weak var imgPTO: UIImageView!
    var isPTO: Bool = false
    @IBOutlet weak var imgLightbar: UIImageView!
    var isLightBar: Bool = false
    @IBOutlet weak var imgBP: UIImageView!
    var isBP: Bool = false
    @IBOutlet weak var imgDriverID: UIImageView!
    var isDriverId: Bool = false
    @IBOutlet weak var imgCanBus: UIImageView!
    var isCanBus: Bool = false
    @IBOutlet weak var imgCamera: UIImageView!
    var isCamera: Bool = false
    @IBOutlet weak var imgProNavDev: UIImageView!
    var isProvNavDev: Bool = false
    @IBOutlet weak var imgODB: UIImageView!
    var isODB: Bool = false
    @IBOutlet weak var viewBlueTooth: UIView!
    var isBlueTooth: Bool = false
    
    // CheckBox - TextField SerialNo
    @IBOutlet weak var txtCameraSerialNo: UITextField!
    @IBOutlet weak var txtProNavDevSerialNo: UITextField!
    @IBOutlet weak var txtODBSerialNo: UITextField!
    @IBOutlet weak var txtBluetoothSerialNo: UITextField!
    
    var sentPartsParameterArray: [Any] = []
    var bufferPartsParameterArray: [Any] = []
    var returnPartsParameterArray: [Any] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtJobNo.text = String(JobSheetData.jobId)
        self.txtJobNo.isUserInteractionEnabled = false
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
        label.text = JobSheetData.nc_bnc_number
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
        isFms = sender.isSelected
    }
    
    @IBAction func digitalTacho(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgDigitalTacho.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgDigitalTacho.image = UIImage(named: "check")
        }
        isDigitalTacho = sender.isSelected
    }
    
    @IBAction func privacySwitch(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgPrivacySwitch.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgPrivacySwitch.image = UIImage(named: "check")
        }
        isPrivacySwitch = sender.isSelected
    }
    
    @IBAction func pto(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgPTO.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgPTO.image = UIImage(named: "check")
        }
        isPTO = sender.isSelected
    }
    
    @IBAction func lightbar(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgLightbar.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgLightbar.image = UIImage(named: "check")
        }
        isLightBar = sender.isSelected
    }
    
    @IBAction func bp(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgBP.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgBP.image = UIImage(named: "check")
        }
        isBP = sender.isSelected
    }
    
    @IBAction func driverID(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgDriverID.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgDriverID.image = UIImage(named: "check")
        }
        isDriverId = sender.isSelected
    }
    
    @IBAction func canBus(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgCanBus.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgCanBus.image = UIImage(named: "check")
        }
        isCanBus = sender.isSelected
    }
    
    @IBAction func camera(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgCamera.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgCamera.image = UIImage(named: "check")
        }
        isCamera = sender.isSelected
    }
    
    @IBAction func proNavDev(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgProNavDev.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgProNavDev.image = UIImage(named: "check")
        }
        isProvNavDev = sender.isSelected
    }
    
    @IBAction func odb(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgODB.image = UIImage(named: "uncheck")
        } else {
            sender.isSelected = true
            imgODB.image = UIImage(named: "check")
        }
        isODB = sender.isSelected
    }
    
    // MARK: Reset
    @IBAction func reset(_ sender: UIButton) {
        txtJobNo.text = ""
        txtSerialNo.text = ""
        txtSimNo.text = ""
        txtMobNo.text = ""
        txtIMEINo.text = ""
        txtCommNo.text = ""
        txtGNo.text = ""
        txtSupplyColor.text = ""
        txtSupplyCircuit.text = ""
        txtIGNCircuit.text = ""
        txtVLU.text = ""
        txtGSM.text = ""
        txtGPS.text = ""
        txtVHF.text = ""
        txtCameraSerialNo.text = ""
        txtProNavDevSerialNo.text = ""
        txtODBSerialNo.text = ""
        txtBluetoothSerialNo.text = ""
        txtViewClosingNotes.text = ""
    }
    
    // MARK: Save
    @IBAction func save(_ sender: UIButton) {
        self.createSentPartsJsonParam()
    }
    
    @objc func createSentPartsJsonParam() {
        LoadingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, text: "Job closure data submission starts!!!") { contextVal in } didFinish: { txt in }
        //NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        if PostCheckData.sentParts_base64.count > 0 {
            sentPartsParameterArray.removeAll()
            for val in PostCheckData.sentParts_base64 {
                let parameters: [String : Any] = ["id": val.id, "part": val.partsName, "serial": val.serial1, "used": val.used, "returned_by": val.returnedBy]
                sentPartsParameterArray.append(parameters)
            }
        }
        self.createBufferPartsJsonParam()
    }
    
    @objc func createBufferPartsJsonParam() {
        if PostCheckData.bufferParts_base64.count > 0 {
            bufferPartsParameterArray.removeAll()
            for val in PostCheckData.bufferParts_base64 {
                let parameters: [String: Any] = ["id": val.id, "part": val.partsName, "serial": val.serialNo, "used": val.consumed]
                bufferPartsParameterArray.append(parameters)
            }
        }
        self.createReturnPartsJsonParam()
    }
    
    @objc func createReturnPartsJsonParam() {
        if PostCheckData.partsReturn_base64.count > 0 {
            returnPartsParameterArray.removeAll()
            for val in PostCheckData.partsReturn_base64 {
                let paramaters: [String: Any] = ["id": val.id, "part": val.partsName, "serial": val.serialNo, "returned_by": val.returnedBy]
                returnPartsParameterArray.append(paramaters)
            }
        }
        // CallClosureAPI
        self.closureAPI()
    }
    
    //  MARK: ClosureAPI
    @objc func closureAPI() {
        let baseurl = "\(baseurl)/v1/joborder/\(JobSheetData.jobId)/closure"
        print(baseurl)
        let headers = ["x-api-key" : apiKey, "X-Token": Chameleon.token]
        // PreCheckParamater Create
        let preCheckParamater: [String: Any] = ["vehicle": ["make": PreCheckData.make, "model": PreCheckData.model, "reg": PreCheckData.reg, "odometer": PreCheckData.odometer, "odometer_unit": PreCheckData.miles, "reg_or_vin": ""], "issues": ["electrical": ["reasons": PreCheckData.electricalIssueTxt], "exterior": ["reasons": PreCheckData.exteriorIssueTxt], "interior": ["reasons": PreCheckData.interiorIssueTxt]]]
        // PostCheckParameter Create
        let postCheckParameter: [String: Any] = ["sent_parts": sentPartsParameterArray, "buffer_parts": bufferPartsParameterArray, "return_parts": returnPartsParameterArray, "issues": ["electrical": ["reasons": PostCheckData.electricalIssueTxt], "exterior": ["reasons": PostCheckData.exteriorIssueTxt], "interior": ["reasons": PostCheckData.interiorIssueTxt]], "engineer_comments": PostCheckData.declaration, "copy_cusomter": ["email": PostCheckData.isSendCopy ? PostCheckData.emailAddress : ""]]
        // ClosureParameter Create
        let closureParamater: [String: Any] = ["telematic": ["serial_no": self.txtSerialNo.text, "sim_no": self.txtSimNo.text, "mobile_no": self.txtMobNo.text, "imei_no": self.txtIMEINo.text, "commissioning_no": self.txtCommNo.text, "g_no": self.txtGNo.text, "supply_color": self.txtSupplyColor.text, "supply_circuit": self.txtSupplyCircuit.text, "ign_circuit": self.txtIGNCircuit.text, "vlu_unit_location": self.txtVLU.text, "GSM_Ant_Location": self.txtGSM.text, "GPS_Ant_Location": self.txtGPS.text, "VHF_Ant_Location": self.txtVHF.text], "fms": self.isFms, "digital_tacho": self.isDigitalTacho, "privacy_switch": self.isPrivacySwitch, "can_bus": self.isCanBus, "lightbar": self.isLightBar, "pto": self.isPTO, "camera": ["tested": self.isCamera, "serial_no": self.txtCameraSerialNo.text ?? ""], "Pro_Navigation_Device": ["tested": self.isProvNavDev, "serial_no": self.txtProNavDevSerialNo.text ?? ""], "odb": ["tested": self.isODB, "serial_no": self.txtODBSerialNo.text ?? ""]]
        let parameters = ["job_order_id": JobSheetData.jobId, "pre_check": preCheckParamater, "post_check": postCheckParameter, "test_report": closureParamater, "engineer_closing_note": self.txtViewClosingNotes.text ?? ""] as [String : Any]
        AFWrapper.requestPOSTURL(baseurl, params: parameters, headers: headers) { jsonVal in
            print(jsonVal)
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
            if jsonVal["row_id"].stringValue != "" {
//                LoadingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, text: "Image upload submission starts!!!") { contextVal in } didFinish: { txt in }
            } else {
                SharedClass.sharedInstance.alert(view: self, title: "Failure", message: jsonVal["row_id"].stringValue)
            }
        } failure: { error in
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
            SharedClass.sharedInstance.alert(view: self, title: "Failure", message: error)
        }
    }
    
    @objc func callImageUploadAPI(counter: Int) {
        switch counter {
        case 0:
            if PreCheckData.dash_img_base64.count > 10 {
                self.imageUploadPrecheckAPI(tag: "pre_check/vehicle/dash_board", base64: PreCheckData.dash_img_base64, identify: "PreCheck Dashboard")
            }
        case 1:
            if PreCheckData.front_img_base64.count > 10 {
                self.imageUploadPrecheckAPI(tag: "pre_check/vehicle/dash_board", base64: PreCheckData.front_img_base64, identify: "PreCheck Frontside")
            }
        case 2:
            if PreCheckData.rear_img_base64.count > 10 {
                self.imageUploadPrecheckAPI(tag: "pre_check/vehicle/rear_side", base64: PreCheckData.rear_img_base64, identify: "PreCheck Rearside")
            }
        case 3:
            if PreCheckData.passengerSide_img_base64.count > 10 {
                self.imageUploadPrecheckAPI(tag: "pre_check/vehicle/passenger_side", base64: PreCheckData.passengerSide_img_base64, identify: "PreCheck Passengerside")
            }
        case 4:
            if PreCheckData.driverSide_img_base64.count > 10 {
                self.imageUploadPrecheckAPI(tag: "pre_check/vehicle/driver_side", base64: PreCheckData.driverSide_img_base64, identify: "PreCheck Driverside")
            }
        default:
            if PreCheckData.driverSide_img_base64.count > 10 {
                self.imageUploadPrecheckAPI(tag: "pre_check/vehicle/driver_side", base64: PreCheckData.driverSide_img_base64, identify: "PreCheck Driverside")
            }
        }
    }
    
    @objc func imageUploadPrecheckAPI(tag: String, base64: String, identify: String) {
        let baseurl = "\(baseurl)/v1/joborder/\(JobSheetData.jobId)/closure//image"
        print(baseurl)
        let headers = ["x-api-key" : apiKey, "X-Token": Chameleon.token]
        let parameters = ["tag": tag, "image": base64] as [String : Any]
        AFWrapper.requestPOSTURL(baseurl, params: parameters, headers: headers) { jsonVal in
            print(jsonVal)
            if jsonVal["row_id"].stringValue != "" {
                if self.imageUploadCounter == 4 {
                    
                } else {
                    self.imageUploadCounter += 1
                    self.callImageUploadAPI(counter: self.imageUploadCounter)
                }
            } else {
                self.imageUploadCounter = 0
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                SharedClass.sharedInstance.alert(view: self, title: "Failure", message: jsonVal["row_id"].stringValue)
            }
        } failure: { error in
            self.imageUploadCounter = 0
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
            SharedClass.sharedInstance.alert(view: self, title: "Failure", message: error)
        }
    }
}
