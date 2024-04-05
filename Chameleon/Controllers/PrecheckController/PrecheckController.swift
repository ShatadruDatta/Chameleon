//
//  PrecheckController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 03/02/24.
//

import UIKit
import Photos

struct PreCheckData {
    static var miles = "Miles"
    static var make = ""
    static var model = ""
    static var reg = ""
    static var odometer = ""
    static var dash_img = UIImage()
    static var dash_img_base64 = ""
    static var reg_vin_img = UIImage()
    static var reg_vin_img_base64 = ""
    static var front_img = UIImage()
    static var front_img_base64 = ""
    static var rear_img = UIImage()
    static var rear_img_base64 = ""
    static var passengerSide_img = UIImage()
    static var passengerSide_img_base64 = ""
    static var driverSide_img = UIImage()
    static var driverSide_img_base64 = ""
    static var isElectricalIssue = false
    static var electricalIssueTxt = ""
    static var arrImgElectricalIssue: [UIImage] = []
    static var arrImgElectricalIssueBase64: [String] = []
    static var isExteriorIssue = false
    static var exteriorIssueTxt = ""
    static var arrImgExteriorIssue: [UIImage] = []
    static var arrImageExteriorIssueBase64: [String] = []
    static var isInteriorIssue = false
    static var interiorIssueTxt = ""
    static var arrImgInteriorIssue: [UIImage] = []
    static var arrImgInteriorIssueBase64: [String] = []
    static var customerSignature = UIImage()
    static var customerSignature_base64 = ""
    static var customerName = JobSheetData.customerName
}

class PrecheckController: BaseViewController {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var lblNcNumber: UILabel!
    @IBOutlet weak var tblPreCheck: UITableView!
    @IBOutlet weak var viewPreCheck: UIView!
    @IBOutlet weak var viewPostCheck: UIView!
    @IBOutlet weak var viewClosure: UIView!
    @IBOutlet weak var imgPreCheck: UIImageView!
    var isReset: Bool = false
    var isSave: Bool = false
    var issueIndex: Int = -1
    
    var milesArray = ["Miles", "Kilometer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblPreCheck.reloadData()
        viewPreCheck.layer.cornerRadius = 10.0
        viewPostCheck.layer.cornerRadius = 10.0
        viewClosure.layer.cornerRadius = 10.0
        
        self.viewPreCheck.layer.masksToBounds = false
        self.viewPreCheck.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        self.imgPreCheck.setImageColor(color: .white)
        
        self.viewPostCheck.layer.masksToBounds = false
        self.viewPostCheck.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        self.viewClosure.layer.masksToBounds = false
        self.viewClosure.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        self.lblNcNumber.text = JobSheetData.nc_bnc_number
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(PrecheckController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PrecheckController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if JobSheetData.service.first == "D" {
            PreCheckData.model = JobSheetData.deins_vehicle_det_vehicle_model
            PreCheckData.make = JobSheetData.deins_vehicle_det_vehicle_make
            PreCheckData.reg = JobSheetData.deins_vehicle_det_reg
        } else {
            PreCheckData.model = JobSheetData.ins_vehicle_det_vehicle_model
            PreCheckData.make = JobSheetData.ins_vehicle_det_vehicle_make
            PreCheckData.reg = JobSheetData.deins_vehicle_det_reg
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func postcheck(_ sender: UIButton) {
        //self.save2()
    }
    
    @IBAction func menu(_ sender: UIButton) {
        NavigationHelper.helper.reloadMenu()
        NavigationHelper.helper.openSidePanel(open: true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            print("Notification: Keyboard will show")
            tblPreCheck.setBottomInset(to: keyboardHeight)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        print("Notification: Keyboard will hide")
        tblPreCheck.setBottomInset(to: 0.0)
    }
}

// MARK: TableViewDelegate, TableViewDataSource
extension PrecheckController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        } else if section == 1 {
            return 6
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 75.0
            case 1,2,3:
                return 63.0
            case 4,5,6:
                return 197.0
            default:
                return 20.0
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 50.0
            } else if indexPath.row == 1 {
                return 20.0
            } else if indexPath.row == 5 {
                return 20.0
            } else {
                if indexPath.row == 2 {
                    if PreCheckData.isElectricalIssue {
                        if PreCheckData.arrImgElectricalIssue.count > 0 {
                            return 245.0
                        } else {
                            return 180.0
                        }
                    } else {
                        return 50.0
                    }
                } else if indexPath.row == 3 {
                    if PreCheckData.isExteriorIssue {
                        if PreCheckData.arrImgExteriorIssue.count > 0 {
                            return 245.0
                        } else {
                            return 180.0
                        }
                    } else {
                        return 50.0
                    }
                } else {
                    if PreCheckData.isInteriorIssue {
                        if PreCheckData.arrImgInteriorIssue.count > 0 {
                            return 245.0
                        } else {
                            return 180.0
                        }
                    } else {
                        return 50.0
                    }
                }
            }
        } else {
            if indexPath.row == 0 {
                return 50.0
            } else if indexPath.row == 1 {
                return 240.0
            } else {
                return 80.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let serviceCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "ServicePrecheckCell", for: indexPath) as! ServicePrecheckCell
                serviceCell.datasource = "" as AnyObject
                serviceCell.txtService.text = JobSheetData.service
                serviceCell.txtService.isEnabled = false
                return serviceCell
            case 1:
                let modelCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "ModelCell", for: indexPath) as! ModelCell
                modelCell.datasource = "" as AnyObject
                modelCell.txtModel.text = PreCheckData.model
                modelCell.didEndWriteTextModel = { val in
                    PreCheckData.model = val
                }
                modelCell.txtMake.text = PreCheckData.make
                modelCell.didEndWriteTextMake = { val in
                    PreCheckData.make = val
                }
                return modelCell
            case 2:
                let regCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "RegPrecheckCell", for: indexPath) as! RegPrecheckCell
                regCell.datasource = "" as AnyObject
                regCell.txtReg.text = PreCheckData.reg
                regCell.didEndWriteText = { val in
                    PreCheckData.reg = val
                }
                return regCell
            case 3:
                let odometerCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "OdometerCell", for: indexPath) as! OdometerCell
                odometerCell.datasource = "" as AnyObject
                odometerCell.txtMiles.text = PreCheckData.miles
                odometerCell.txtOdometer.text = PreCheckData.odometer
                odometerCell.didSendSignal = { chk  in
                    PickerViewController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, arrPickerVal: self.milesArray) { val in
                        PreCheckData.miles = val
                        self.tblPreCheck.reloadData() } didFinish: { txt in }}
                odometerCell.didEndWriteText = { val in
                    PreCheckData.odometer = val
                }
                return odometerCell
            case 4:
                let imgCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "DashImageCaptureCell", for: indexPath) as! DashImageCaptureCell
                imgCell.datasource = "" as AnyObject
                if isReset {
                    imgCell.imgView1.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage1.isHidden = false
                    imgCell.imgCamera1.isHidden = false
                    imgCell.btnDel1.isHidden = true
                    imgCell.imgView2.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage2.isHidden = false
                    imgCell.imgCamera2.isHidden = false
                    imgCell.btnDel2.isHidden = true
                }
                imgCell.lblImg1.text = "Dash\n(powered on)*"
                imgCell.lblImg2.text = "Reg/VIN*"
                imgCell.didFirstImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PreCheckData.dash_img = image
                        DispatchQueue.background(background: {
                            PreCheckData.dash_img_base64 = image.toBase64() ?? ""
                        }, completion:{
                        })
                        imgCell.imgView1.image = image
                        imgCell.lblAddImage1.isHidden = true
                        imgCell.imgCamera1.isHidden = true
                        imgCell.btnDel1.isHidden = false
                    }
                }
                imgCell.delImage1 = { check in
                    imgCell.imgView1.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage1.isHidden = false
                    imgCell.imgCamera1.isHidden = false
                    imgCell.btnDel1.isHidden = true
                }
                imgCell.didSecondImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PreCheckData.reg_vin_img = image
                        DispatchQueue.background(background: {
                            PreCheckData.reg_vin_img_base64 = image.toBase64() ?? ""
                        }, completion:{
                        })
                        imgCell.imgView2.image = image
                        imgCell.lblAddImage2.isHidden = true
                        imgCell.imgCamera2.isHidden = true
                        imgCell.btnDel2.isHidden = false
                    }
                }
                imgCell.delImage2 = { check in
                    imgCell.imgView2.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage2.isHidden = false
                    imgCell.imgCamera2.isHidden = false
                    imgCell.btnDel2.isHidden = true
                }
                return imgCell
            case 5:
                let imgCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "FrontImageCaptureCell", for: indexPath) as! FrontImageCaptureCell
                imgCell.datasource = "" as AnyObject
                if isReset {
                    imgCell.imgView1.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage1.isHidden = false
                    imgCell.imgCamera1.isHidden = false
                    imgCell.btnDel1.isHidden = true
                    imgCell.imgView2.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage2.isHidden = false
                    imgCell.imgCamera2.isHidden = false
                    imgCell.btnDel2.isHidden = true
                }
                imgCell.lblImg1.text = "Front*"
                imgCell.lblImg2.text = "Rear*"
                imgCell.didFirstImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PreCheckData.front_img = image
                        DispatchQueue.background(background: {
                            PreCheckData.front_img_base64 = image.toBase64() ?? ""
                        }, completion:{
                        })
                        imgCell.imgView1.image = image
                        imgCell.lblAddImage1.isHidden = true
                        imgCell.imgCamera1.isHidden = true
                        imgCell.btnDel1.isHidden = false
                    }
                }
                imgCell.delImage1 = { check in
                    PreCheckData.front_img = UIImage()
                    imgCell.imgView1.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage1.isHidden = false
                    imgCell.imgCamera1.isHidden = false
                    imgCell.btnDel1.isHidden = true
                }
                imgCell.didSecondImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PreCheckData.rear_img = image
                        DispatchQueue.background(background: {
                            PreCheckData.rear_img_base64 = image.toBase64() ?? ""
                        }, completion:{
                        })
                        imgCell.imgView2.image = image
                        imgCell.lblAddImage2.isHidden = true
                        imgCell.imgCamera2.isHidden = true
                        imgCell.btnDel2.isHidden = false
                    }
                }
                imgCell.delImage2 = { check in
                    PreCheckData.rear_img = UIImage()
                    imgCell.imgView2.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage2.isHidden = false
                    imgCell.imgCamera2.isHidden = false
                    imgCell.btnDel2.isHidden = true
                }
                return imgCell
            case 6:
                let imgCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "PassengerImageCaptureCell", for: indexPath) as! PassengerImageCaptureCell
                imgCell.datasource = "" as AnyObject
                if isReset {
                    imgCell.imgView1.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage1.isHidden = false
                    imgCell.imgCamera1.isHidden = false
                    imgCell.btnDel1.isHidden = true
                    imgCell.imgView2.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage2.isHidden = false
                    imgCell.imgCamera2.isHidden = false
                    imgCell.btnDel2.isHidden = true
                }
                imgCell.lblImg1.text = "Passenger Side*"
                imgCell.lblImg2.text = "Driver Side*"
                imgCell.didFirstImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PreCheckData.passengerSide_img = image
                        DispatchQueue.background(background: {
                            PreCheckData.passengerSide_img_base64 = image.toBase64() ?? ""
                        }, completion:{
                        })
                        imgCell.imgView1.image = image
                        imgCell.lblAddImage1.isHidden = true
                        imgCell.imgCamera1.isHidden = true
                        imgCell.btnDel1.isHidden = false
                    }
                }
                imgCell.delImage1 = { check in
                    PreCheckData.passengerSide_img = UIImage()
                    imgCell.imgView1.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage1.isHidden = false
                    imgCell.imgCamera1.isHidden = false
                    imgCell.btnDel1.isHidden = true
                }
                imgCell.didSecondImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PreCheckData.driverSide_img = image
                        DispatchQueue.background(background: {
                            PreCheckData.driverSide_img_base64 = image.toBase64() ?? ""
                        }, completion:{
                        })
                        imgCell.imgView2.image = image
                        imgCell.lblAddImage2.isHidden = true
                        imgCell.imgCamera2.isHidden = true
                        imgCell.btnDel2.isHidden = false
                    }
                }
                imgCell.delImage2 = { check in
                    PreCheckData.driverSide_img = UIImage()
                    imgCell.imgView2.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage2.isHidden = false
                    imgCell.imgCamera2.isHidden = false
                    imgCell.btnDel2.isHidden = true
                }
                return imgCell
            default:
                let whiteBottomCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "WhiteBottomCell", for: indexPath) as! WhiteBottomCell
                whiteBottomCell.datasource = "" as AnyObject
                return whiteBottomCell
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let headerCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Issues"
                headerCell.imgContent.image = UIImage(named: "TestReport")
                return headerCell
            } else if indexPath.row == 1 || indexPath.row == 5 {
                let whiteTopCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "WhiteTopCell", for: indexPath) as! WhiteTopCell
                whiteTopCell.datasource = "" as AnyObject
                return whiteTopCell
            } else if indexPath.row == 5 {
                let whiteBottomCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "WhiteBottomCell", for: indexPath) as! WhiteBottomCell
                whiteBottomCell.datasource = "" as AnyObject
                return whiteBottomCell
            } else if indexPath.row == 2 {
                let issueCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "ElectricalIssueCell", for: indexPath) as! ElectricalIssueCell
                issueCell.datasource = "Electrical*" as AnyObject
                if isReset {
                    issueCell.txtView.text = "Text Message"
                    issueCell.txtView.textColor = UIColor.fontColor
                }
                issueCell.didSendYes = { check in
                    PreCheckData.isElectricalIssue = check
                    self.tblPreCheck.reloadData()
                }
                issueCell.arrImg = PreCheckData.arrImgElectricalIssue
                issueCell.didUpdateText = { val in
                    PreCheckData.electricalIssueTxt = val
                }
                issueCell.didcaptureCamera = { capture in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PreCheckData.arrImgElectricalIssue.append(image)
                        self.tblPreCheck.reloadData()
                    }
                }
                issueCell.didDelImage = { index in
                    PreCheckData.arrImgElectricalIssue.remove(at: index)
                    self.tblPreCheck.reloadData()
                }
                return issueCell
            } else if indexPath.row == 3 {
                let issueCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "ExteriorIssueCell", for: indexPath) as! ExteriorIssueCell
                issueCell.datasource = "Exterior*" as AnyObject
                if isReset {
                    issueCell.txtView.text = "Text Message"
                    issueCell.txtView.textColor = UIColor.fontColor
                }
                issueCell.didSendYes = { check in
                    PreCheckData.isExteriorIssue = check
                    self.tblPreCheck.reloadData()
                }
                issueCell.arrImg = PreCheckData.arrImgExteriorIssue
                issueCell.didUpdateText = { val in
                    PreCheckData.exteriorIssueTxt = val
                }
                issueCell.didcaptureCamera = { capture in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PreCheckData.arrImgExteriorIssue.append(image)
                        self.tblPreCheck.reloadData()
                    }
                }
                issueCell.didDelImage = { index in
                    PreCheckData.arrImgExteriorIssue.remove(at: index)
                    self.tblPreCheck.reloadData()
                }
                return issueCell
            } else {
                let issueCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "InteriorIssueCell", for: indexPath) as! InteriorIssueCell
                issueCell.datasource = "Interior*" as AnyObject
                if isReset {
                    issueCell.txtView.text = "Text Message"
                    issueCell.txtView.textColor = UIColor.fontColor
                }
                issueCell.didSendYes = { check in
                    PreCheckData.isInteriorIssue = check
                    self.tblPreCheck.reloadData()
                }
                issueCell.arrImg = PreCheckData.arrImgInteriorIssue
                issueCell.didUpdateText = { val in
                    PreCheckData.interiorIssueTxt = val
                }
                issueCell.didcaptureCamera = { capture in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PreCheckData.arrImgInteriorIssue.append(image)
                        self.tblPreCheck.reloadData()
                    }
                }
                issueCell.didDelImage = { index in
                    PreCheckData.arrImgInteriorIssue.remove(at: index)
                    self.tblPreCheck.reloadData()
                }
                return issueCell
            }
        } else {
            if indexPath.row == 0 {
                let headerCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Customer Signature"
                headerCell.imgContent.image = UIImage(named: "Signature")
                return headerCell
            } else if indexPath.row == 1 {
                let custSignCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "CustSignCell", for: indexPath) as! CustSignCell
                custSignCell.datasource = "" as AnyObject
                if isReset {
                    custSignCell.showSignature = false
                    custSignCell.imgSign.isHidden = true
                    custSignCell.signatureView.isHidden = false
                    custSignCell.txtName.text = ""
                }
                custSignCell.didExpand = { chk  in
                    if chk {
                        SignatureViewController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!) { imgSign, lines, view in
                            PreCheckData.customerSignature = imgSign
                            DispatchQueue.background(background: {
                                PreCheckData.customerSignature_base64 = imgSign.toBase64() ?? ""
                            }, completion:{
                            })
                            custSignCell.showSignature = true
                            custSignCell.imgSign.image = imgSign
                            custSignCell.imgSign.contentMode = .scaleAspectFit
                            self.tblPreCheck.reloadData()
                        } didFinish: { txt in }}}
                custSignCell.txtName.text = PreCheckData.customerName
                custSignCell.didEndWriteText = { val in
                    PreCheckData.customerName = val
                }
                return custSignCell
            } else {
                let saveCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "SaveCell", for: indexPath) as! SaveCell
                saveCell.datasource = "" as AnyObject
                saveCell.didSave = { save in
                    self.isSave = save
                    //self.generalImageUpload()
                    self.saveData()
                }
                saveCell.didReset = { reset in
                    self.isReset = reset
                    self.tblPreCheck.reloadData()
                    self.resetData()
                }
                return saveCell
            }
        }
    }
}

// MARK: ServicePrecheckCell
class ServicePrecheckCell: BaseTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var txtService: CustomTextField!
    @IBOutlet weak var viewBG: UIView!
    var didSendSignal:((Bool) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
                viewBG.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                txtService.layer.cornerRadius = 25.0
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.didSendSignal!(true)
        return false
    }
    
}


// MARK: ModelCell
class ModelCell: BaseTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var txtModel: CustomTextField!
    @IBOutlet weak var txtMake: CustomTextField!
    var didEndWriteTextModel:((String) -> ())!
    var didEndWriteTextMake:((String) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                txtModel.layer.cornerRadius = 25.0
                txtMake.layer.cornerRadius = 25.0
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtModel {
            let textFieldText: NSString = (txtModel.text ?? "") as NSString
                let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
            self.didEndWriteTextModel!(txtAfterUpdate)
        } else {
            let textFieldText: NSString = (txtMake.text ?? "") as NSString
                let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
            self.didEndWriteTextMake!(txtAfterUpdate)
        }
        return true
    }
}

// MARK: OdometerCell
class OdometerCell: BaseTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var txtOdometer: CustomTextField!
    @IBOutlet weak var txtSelect: CustomTextField!
    @IBOutlet weak var txtMiles: CustomTextField!
    var didSendSignal:((Bool) -> ())!
    var didEndWriteText:((String) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                txtOdometer.layer.cornerRadius = 25.0
                txtSelect.layer.cornerRadius = 25.0
                txtSelect.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
                txtMiles.layer.cornerRadius = 25.0
                txtMiles.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtOdometer {
            return true
        } else {
            self.didSendSignal!(true)
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (txtOdometer.text ?? "") as NSString
            let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        self.didEndWriteText!(txtAfterUpdate)
        return true
    }
    
    
}


// MARK: RegCell
class RegPrecheckCell: BaseTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var txtReg: CustomTextField!
    var didEndWriteText:((String) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                txtReg.layer.cornerRadius = 25.0
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (txtReg.text ?? "") as NSString
            let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        self.didEndWriteText!(txtAfterUpdate)
        return true
    }
}


// MARK: DashImageCaptureCell
class DashImageCaptureCell: BaseTableViewCell {
    @IBOutlet weak var lblImg1: UILabel!
    @IBOutlet weak var lblImg2: UILabel!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var lblAddImage1: UILabel!
    @IBOutlet weak var lblAddImage2: UILabel!
    @IBOutlet weak var imgCamera1: UIImageView!
    @IBOutlet weak var imgCamera2: UIImageView!
    @IBOutlet weak var btnDel1: UIButton!
    @IBOutlet weak var btnDel2: UIButton!
    var file: UIImage?
    var didFirstImg:((String) -> ())!
    var didSecondImg:((String) -> ())!
    var delImage1:((Bool) -> ())!
    var delImage2:((Bool) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                imgView1.layer.cornerRadius = 10.0
                imgView2.layer.cornerRadius = 10.0
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
                imgView1.addGestureRecognizer(tapGestureRecognizer1)
                let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
                imgView2.addGestureRecognizer(tapGestureRecognizer2)
                btnDel1.addTarget(self, action: #selector(delImg1), for: .touchUpInside)
                btnDel2.addTarget(self, action: #selector(delImg2), for: .touchUpInside)
            }
        }
    }
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer) {
        print("Test")
        self.didFirstImg!("Img1")
    }
    
    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer) {
        self.didSecondImg!("Img2")
    }
    
    @objc func delImg1(_ sender: UIButton) {
        self.delImage1!(true)
    }
    
    @objc func delImg2(_ sender: UIButton) {
        self.delImage2!(true)
    }
}

// MARK: FrontImageCaptureCell
class FrontImageCaptureCell: BaseTableViewCell {
    @IBOutlet weak var lblImg1: UILabel!
    @IBOutlet weak var lblImg2: UILabel!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var lblAddImage1: UILabel!
    @IBOutlet weak var lblAddImage2: UILabel!
    @IBOutlet weak var imgCamera1: UIImageView!
    @IBOutlet weak var imgCamera2: UIImageView!
    @IBOutlet weak var btnDel1: UIButton!
    @IBOutlet weak var btnDel2: UIButton!
    var file: UIImage?
    var didFirstImg:((String) -> ())!
    var didSecondImg:((String) -> ())!
    var delImage1:((Bool) -> ())!
    var delImage2:((Bool) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                imgView1.layer.cornerRadius = 10.0
                imgView2.layer.cornerRadius = 10.0
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
                imgView1.addGestureRecognizer(tapGestureRecognizer1)
                let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
                imgView2.addGestureRecognizer(tapGestureRecognizer2)
                btnDel1.addTarget(self, action: #selector(delImg1), for: .touchUpInside)
                btnDel2.addTarget(self, action: #selector(delImg2), for: .touchUpInside)
            }
        }
    }
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer) {
        print("Test")
        self.didFirstImg!("Img1")
    }
    
    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer) {
        self.didSecondImg!("Img2")
    }
    
    @objc func delImg1(_ sender: UIButton) {
        self.delImage1!(true)
    }
    
    @objc func delImg2(_ sender: UIButton) {
        self.delImage2!(true)
    }
}

// MARK: PassengerImageCaptureCell
class PassengerImageCaptureCell: BaseTableViewCell {
    @IBOutlet weak var lblImg1: UILabel!
    @IBOutlet weak var lblImg2: UILabel!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var lblAddImage1: UILabel!
    @IBOutlet weak var lblAddImage2: UILabel!
    @IBOutlet weak var imgCamera1: UIImageView!
    @IBOutlet weak var imgCamera2: UIImageView!
    @IBOutlet weak var btnDel1: UIButton!
    @IBOutlet weak var btnDel2: UIButton!
    var file: UIImage?
    var didFirstImg:((String) -> ())!
    var didSecondImg:((String) -> ())!
    var delImage1:((Bool) -> ())!
    var delImage2:((Bool) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                imgView1.layer.cornerRadius = 10.0
                imgView2.layer.cornerRadius = 10.0
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
                imgView1.addGestureRecognizer(tapGestureRecognizer1)
                let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
                imgView2.addGestureRecognizer(tapGestureRecognizer2)
                btnDel1.addTarget(self, action: #selector(delImg1), for: .touchUpInside)
                btnDel2.addTarget(self, action: #selector(delImg2), for: .touchUpInside)
            }
        }
    }
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer) {
        print("Test")
        self.didFirstImg!("Img1")
    }
    
    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer) {
        self.didSecondImg!("Img2")
    }
    
    @objc func delImg1(_ sender: UIButton) {
        self.delImage1!(true)
    }
    
    @objc func delImg2(_ sender: UIButton) {
        self.delImage2!(true)
    }
}


// MARK: WhiteBackgroundCell
class WhiteBottomCell: BaseTableViewCell {
    @IBOutlet weak var viewBG: UIView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
                viewBG.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
}

// MARK: WhiteBackgroundCell
class WhiteTopCell: BaseTableViewCell {
    @IBOutlet weak var viewBG: UIView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
                viewBG.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
            }
        }
    }
}


// MARK: HeaderCell
class HeaderCell: BaseTableViewCell {
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var imgContent: UIImageView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                
            }
        }
    }
}


// MARK: ElectricalIssuesCell
class ElectricalIssueCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var switchIssue: UISwitch!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var btnClip: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var collImg: UICollectionView!
    @IBOutlet weak var parentTxtView: UIView!
    var didSendYes:((Bool) -> ())!
    var didcaptureCamera:((Bool) -> ())!
    var arrImg: [UIImage] = []
    var didDelImage:((Int) -> ())!
    var didUpdateText:((String) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                self.lblContent.text = datasource as? String
                parentTxtView.layer.cornerRadius = 10.0
                collImg.reloadData()
                btnCamera.addTarget(self, action: #selector(cameraCapture), for: .touchUpInside)
                switchIssue.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
            }
        }
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if sender.isSelected {
            sender.isSelected = false
            sender.thumbTintColor = UIColor.white
            self.didSendYes!(false)
        } else {
            sender.isSelected = true
            sender.thumbTintColor = UIColor.blueColor
            self.didSendYes!(true)
        }
    }
    
    @objc func cameraCapture(_ sender: UIButton) {
        self.didcaptureCamera!(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollImgCell", for: indexPath)
        let imageview: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageview.image = arrImg[indexPath.item]
        imageview.contentMode = .scaleAspectFill
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.masksToBounds = true
        cell.contentView.addSubview(imageview)
        let btnDel: UIButton = UIButton(frame: CGRect(x: 36, y: 0, width: 24, height: 24))
        btnDel.setImage(UIImage(named: "trash"), for: .normal)
        btnDel.tag = indexPath.item
        btnDel.addTarget(self, action: #selector(delImg), for: .touchUpInside)
        cell.contentView.addSubview(btnDel)
        return cell
    }
    
    @objc func delImg(_ sender: UIButton) {
       self.didDelImage!(sender.tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60.0, height: 60.0)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        } else {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            self.didUpdateText!(newText)
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

// MARK: ExteriorIssuesCell
class ExteriorIssueCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var switchIssue: UISwitch!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var btnClip: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var collImg: UICollectionView!
    @IBOutlet weak var parentTxtView: UIView!
    var didDelImage:((Int) -> ())!
    var didSendYes:((Bool) -> ())!
    var didcaptureCamera:((Bool) -> ())!
    var arrImg: [UIImage] = []
    var didUpdateText:((String) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                self.lblContent.text = datasource as? String
                parentTxtView.layer.cornerRadius = 10.0
                collImg.reloadData()
                btnCamera.addTarget(self, action: #selector(cameraCapture), for: .touchUpInside)
                switchIssue.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
            }
        }
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if sender.isSelected {
            sender.isSelected = false
            sender.thumbTintColor = UIColor.white
            self.didSendYes!(false)
        } else {
            sender.isSelected = true
            sender.thumbTintColor = UIColor.blueColor
            self.didSendYes!(true)
        }
    }
    
    @objc func cameraCapture(_ sender: UIButton) {
        self.didcaptureCamera!(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollImgCell", for: indexPath)
        let imageview: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageview.image = arrImg[indexPath.item]
        imageview.contentMode = .scaleAspectFill
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.masksToBounds = true
        cell.contentView.addSubview(imageview)
        let btnDel: UIButton = UIButton(frame: CGRect(x: 36, y: 0, width: 24, height: 24))
        btnDel.setImage(UIImage(named: "trash"), for: .normal)
        btnDel.tag = indexPath.item
        btnDel.addTarget(self, action: #selector(delImg), for: .touchUpInside)
        cell.contentView.addSubview(btnDel)
        return cell
    }
    
    @objc func delImg(_ sender: UIButton) {
        self.didDelImage!(sender.tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60.0, height: 60.0)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        } else {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            self.didUpdateText!(newText)
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

// MARK: InteriorIssuesCell
class InteriorIssueCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var switchIssue: UISwitch!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var btnClip: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var collImg: UICollectionView!
    @IBOutlet weak var parentTxtView: UIView!
    var didDelImage:((Int) -> ())!
    var didSendYes:((Bool) -> ())!
    var didcaptureCamera:((Bool) -> ())!
    var arrImg: [UIImage] = []
    var didUpdateText:((String) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                self.lblContent.text = datasource as? String
                parentTxtView.layer.cornerRadius = 10.0
                collImg.reloadData()
                btnCamera.addTarget(self, action: #selector(cameraCapture), for: .touchUpInside)
                switchIssue.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
            }
        }
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if sender.isSelected {
            sender.isSelected = false
            sender.thumbTintColor = UIColor.white
            self.didSendYes!(false)
        } else {
            sender.isSelected = true
            sender.thumbTintColor = UIColor.blueColor
            self.didSendYes!(true)
        }
    }
    
    @objc func cameraCapture(_ sender: UIButton) {
        self.didcaptureCamera!(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollImgCell", for: indexPath)
        let imageview: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageview.image = arrImg[indexPath.item]
        imageview.contentMode = .scaleAspectFill
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.masksToBounds = true
        cell.contentView.addSubview(imageview)
        let btnDel: UIButton = UIButton(frame: CGRect(x: 36, y: 0, width: 24, height: 24))
        btnDel.setImage(UIImage(named: "trash"), for: .normal)
        btnDel.tag = indexPath.item
        btnDel.addTarget(self, action: #selector(delImg), for: .touchUpInside)
        cell.contentView.addSubview(btnDel)
        return cell
    }
    
    @objc func delImg(_ sender: UIButton) {
        self.didDelImage!(sender.tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60.0, height: 60.0)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        } else {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            self.didUpdateText!(newText)
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

//MARK: CollImgCell
class CollImgCell: BaseCollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnDel: UIButton!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                self.layer.cornerRadius = 5.0
            }
        }
    }
}


// MARK: CustSignCell
class CustSignCell: BaseTableViewCell, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var signatureView: SignatureView!
    @IBOutlet weak var imgSign: UIImageView!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var viewBG: UIView!
    var didExpand:((Bool) -> ())!
    var didEndWriteText:((String) -> ())!
    var showSignature: Bool = false
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                if showSignature {
                    imgSign.isHidden = false
                    signatureView.isHidden = true
                } else {
                    imgSign.isHidden = true
                    signatureView.isHidden = false
                }
                viewBG.layer.cornerRadius = 10.0
                txtName.layer.cornerRadius = 25.0
                setupViews()
                signatureView.setStrokeColor(color: .black)
                btnExpand.addTarget(self, action: #selector(expand), for: .touchUpInside)
            }
        }
    }
    
    @objc func expand(_ sender: UIButton) {
        signatureView.clear()
        self.didExpand!(true)
    }
    
    func setupViews() {
        imgSign.layer.borderWidth = 0.5
        imgSign.layer.borderColor = UIColor.black.cgColor
        imgSign.layer.cornerRadius = 10.0
        signatureView.layer.borderWidth = 0.5
        signatureView.layer.borderColor = UIColor.black.cgColor
        signatureView.layer.cornerRadius = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
            let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        self.didEndWriteText!(txtAfterUpdate)
        return true
    }
}


// MARK: SaveCell
class SaveCell: BaseTableViewCell {
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    var didSave:((Bool) -> ())!
    var didReset:((Bool) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                btnSave.addTarget(self, action: #selector(save), for: .touchUpInside)
                btnReset.addTarget(self, action: #selector(resetData), for: .touchUpInside)
            }
        }
    }
    
    @objc func save(_ sender: UIButton) {
        self.didSave!(true)
    }
    
    @objc func resetData(_ sender: UIButton) {
        self.didReset!(true)
    }
}


// MARK: ResetData
extension PrecheckController {
    @objc func resetData() {
        PreCheckData.odometer = ""
        PreCheckData.dash_img = UIImage()
        PreCheckData.dash_img_base64 = ""
        PreCheckData.reg_vin_img = UIImage()
        PreCheckData.rear_img_base64 = ""
        PreCheckData.front_img = UIImage()
        PreCheckData.front_img_base64 = ""
        PreCheckData.rear_img = UIImage()
        PreCheckData.rear_img_base64 = ""
        PreCheckData.passengerSide_img = UIImage()
        PreCheckData.passengerSide_img_base64 = ""
        PreCheckData.driverSide_img = UIImage()
        PreCheckData.driverSide_img_base64 = ""
        PreCheckData.electricalIssueTxt = ""
        PreCheckData.arrImgElectricalIssue.removeAll()
        PreCheckData.arrImgElectricalIssueBase64.removeAll()
        PreCheckData.exteriorIssueTxt = ""
        PreCheckData.arrImgExteriorIssue.removeAll()
        PreCheckData.arrImageExteriorIssueBase64.removeAll()
        PreCheckData.interiorIssueTxt = ""
        PreCheckData.arrImgInteriorIssue.removeAll()
        PreCheckData.arrImgInteriorIssueBase64.removeAll()
        PreCheckData.customerSignature = UIImage()
        PreCheckData.customerName = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isReset = false
        }
    }
    
    @objc func saveData() {
        if PreCheckData.make != "" {
            if PreCheckData.model != "" {
                if PreCheckData.reg != "" {
                    if PreCheckData.odometer != "" {
                        if PreCheckData.dash_img_base64 != "" {
                            if PreCheckData.reg_vin_img_base64 != "" {
                                if PreCheckData.front_img_base64 != "" {
                                    if PreCheckData.rear_img_base64 != "" {
                                        if PreCheckData.passengerSide_img_base64 != "" {
                                            if PreCheckData.driverSide_img_base64 != "" {
                                                if PreCheckData.isElectricalIssue {
                                                    if PreCheckData.electricalIssueTxt != "" {
                                                        if PreCheckData.isExteriorIssue {
                                                            if PreCheckData.exteriorIssueTxt != "" {
                                                                if PreCheckData.isInteriorIssue {
                                                                    if PreCheckData.interiorIssueTxt != "" {
                                                                        self.save2()
                                                                    } else {
                                                                        self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter comments on interior issue!")
                                                                    }
                                                                } else {
                                                                    self.save2()
                                                                }
                                                            } else {
                                                                self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter comments on exterior issue!")
                                                            }
                                                        } else {
                                                            self.save2()
                                                        }
                                                    } else {
                                                        self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter comments on electrical issue!")
                                                    }
                                                } else {
                                                    self.save2()
                                                }
                                            } else {
                                                self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter driver side image!")
                                            }
                                        } else {
                                            self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter passenger side image!")
                                        }
                                    } else {
                                        self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter rear image!")
                                    }
                                } else {
                                    self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter front image!")
                                }
                            } else {
                                self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter reg/vin image!")
                            }
                        } else {
                            self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter dash image!")
                        }
                    } else {
                        self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter odometer!")
                    }
                } else {
                    self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter registration!")
                }
            } else {
                self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter vehicle model!")
            }
        } else {
            self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter vehicle make!")
        }
    }
    
    @objc func save2() {
        self.activity.startAnimating()
        if PreCheckData.customerSignature_base64 != "" {
            if PreCheckData.customerName != "" {
                self.createBase64StringForIssues(electrical: PreCheckData.arrImgElectricalIssue, exterior: PreCheckData.arrImgExteriorIssue, interior: PreCheckData.arrImgInteriorIssue)
            } else {
                self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter customer name!")
            }
        } else {
            self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter customer signature!")
        }
    }
    
    @objc func createBase64StringForIssues(electrical: [UIImage], exterior: [UIImage], interior: [UIImage]) {
        if electrical.count > 0 {
            PreCheckData.arrImgElectricalIssueBase64.removeAll()
            for image in electrical {
                DispatchQueue.background(background: {
                    PreCheckData.arrImgElectricalIssueBase64.append(image.toBase64() ?? "")
                }, completion:{
                    
                })
            }
        }
        
        if exterior.count > 0 {
            PreCheckData.arrImageExteriorIssueBase64.removeAll()
            for image in exterior {
                DispatchQueue.background(background: {
                    PreCheckData.arrImageExteriorIssueBase64.append(image.toBase64() ?? "")
                }, completion:{
                    
                })
            }
        }
        
        if interior.count > 0 {
            PreCheckData.arrImgInteriorIssueBase64.removeAll()
            for image in exterior {
                DispatchQueue.background(background: {
                    PreCheckData.arrImgInteriorIssueBase64.append(image.toBase64() ?? "")
                }, completion:{
                    
                })
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.activity.stopAnimating()
            let postcheckVC = mainStoryboard.instantiateViewController(withIdentifier: "PostCheckController") as! PostCheckController
            NavigationHelper.helper.contentNavController!.pushViewController(postcheckVC, animated: true)
        }
    }
}
