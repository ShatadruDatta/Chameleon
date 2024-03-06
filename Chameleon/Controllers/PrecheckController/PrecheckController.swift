//
//  PrecheckController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 03/02/24.
//

import UIKit
import Photos

class PrecheckController: BaseViewController {

    @IBOutlet weak var lblNcNumber: UILabel!
    @IBOutlet weak var tblPreCheck: UITableView!
    @IBOutlet weak var viewPreCheck: UIView!
    @IBOutlet weak var viewPostCheck: UIView!
    @IBOutlet weak var viewClosure: UIView!
    var arrImgElectricalIssue: [UIImage] = []
    var arrImgExteriorIssue: [UIImage] = []
    var arrImgInteriorIssue: [UIImage] = []
    var isReset: Bool = false
    var isSave: Bool = false
    var issueIndex: Int = -1
    var service = ""
    var miles = ""
    var nc_bnc_number: String!
    var isIssueElectrical: Bool = false
    var isIssueExterior: Bool = false
    var isIssueInterior: Bool = false
    var serviceArray = ["Electrician", "Exteriors", "Interiour", "Outside", "Inside"]
    var milesArray = ["Miles", "Kilometer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblPreCheck.reloadData()
        viewPreCheck.layer.cornerRadius = 10.0
        viewPostCheck.layer.cornerRadius = 10.0
        viewClosure.layer.cornerRadius = 10.0
        
        self.viewPreCheck.layer.masksToBounds = false
        self.viewPreCheck.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        self.viewPostCheck.layer.masksToBounds = false
        self.viewPostCheck.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        self.viewClosure.layer.masksToBounds = false
        self.viewClosure.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        self.lblNcNumber.text = self.nc_bnc_number
    }
    
    @IBAction func postcheck(_ sender: UIButton) {
        let postcheckVC = mainStoryboard.instantiateViewController(withIdentifier: "PostCheckController") as! PostCheckController
        postcheckVC.nc_bnc_number = self.nc_bnc_number
        NavigationHelper.helper.contentNavController!.pushViewController(postcheckVC, animated: true)
    }
    
    @IBAction func menu(_ sender: UIButton) {
        NavigationHelper.helper.openSidePanel(open: true)
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
                    if isIssueElectrical {
                        if arrImgElectricalIssue.count > 0 {
                            return 245.0
                        } else {
                            return 180.0
                        }
                    } else {
                        return 50.0
                    }
                } else if indexPath.row == 3 {
                    if isIssueExterior {
                        if arrImgExteriorIssue.count > 0 {
                            return 245.0
                        } else {
                            return 180.0
                        }
                    } else {
                        return 50.0
                    }
                } else {
                    if isIssueInterior {
                        if arrImgInteriorIssue.count > 0 {
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
                serviceCell.txtService.text = service
                serviceCell.didSendSignal = { chk  in
                    PickerViewController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, arrPickerVal: self.serviceArray) { val in
                        self.service = val
                        self.tblPreCheck.reloadData()
                    } didFinish: { txt in
                        
                    }
                }
                return serviceCell
            case 1:
                let modelCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "ModelCell", for: indexPath) as! ModelCell
                modelCell.datasource = "" as AnyObject
                return modelCell
            case 2:
                let regCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "RegPrecheckCell", for: indexPath) as! RegPrecheckCell
                regCell.datasource = "" as AnyObject
                return regCell
            case 3:
                let odometerCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "OdometerCell", for: indexPath) as! OdometerCell
                odometerCell.datasource = "" as AnyObject
                odometerCell.txtMiles.text = self.miles
                odometerCell.didSendSignal = { chk  in
                    PickerViewController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, arrPickerVal: self.milesArray) { val in
                        self.miles = val
                        self.tblPreCheck.reloadData()
                    } didFinish: { txt in
                        
                    }
                }
                return odometerCell
            case 4:
                let imgCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "DashImageCaptureCell", for: indexPath) as! DashImageCaptureCell
                imgCell.datasource = "" as AnyObject
                imgCell.lblImg1.text = "Dash\n(powered on)"
                imgCell.lblImg2.text = "Reg/VIN"
                imgCell.didFirstImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
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
                imgCell.lblImg1.text = "Front"
                imgCell.lblImg2.text = "Rear"
                imgCell.didFirstImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
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
            case 6:
                let imgCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "PassengerImageCaptureCell", for: indexPath) as! PassengerImageCaptureCell
                imgCell.datasource = "" as AnyObject
                imgCell.lblImg1.text = "Passenger Side"
                imgCell.lblImg2.text = "Driver Side"
                imgCell.didFirstImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
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
                issueCell.datasource = "Electrical" as AnyObject
                issueCell.didSendYes = { check in
                    self.isIssueElectrical = check
                    self.tblPreCheck.reloadData()
                }
                issueCell.arrImg = self.arrImgElectricalIssue
                issueCell.didcaptureCamera = { capture in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        self.arrImgElectricalIssue.append(image)
                        self.tblPreCheck.reloadData()
                    }
                }
                return issueCell
            } else if indexPath.row == 3 {
                let issueCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "ExteriorIssueCell", for: indexPath) as! ExteriorIssueCell
                issueCell.datasource = "Exterior" as AnyObject
                issueCell.didSendYes = { check in
                    self.isIssueExterior = check
                    self.tblPreCheck.reloadData()
                }
                issueCell.arrImg = self.arrImgExteriorIssue
                issueCell.didcaptureCamera = { capture in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        self.arrImgExteriorIssue.append(image)
                        self.tblPreCheck.reloadData()
                    }
                }
                return issueCell
            } else {
                let issueCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "InteriorIssueCell", for: indexPath) as! InteriorIssueCell
                issueCell.datasource = "Interior" as AnyObject
                issueCell.didSendYes = { check in
                    self.isIssueInterior = check
                    self.tblPreCheck.reloadData()
                }
                issueCell.arrImg = self.arrImgInteriorIssue
                issueCell.didcaptureCamera = { capture in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        self.arrImgInteriorIssue.append(image)
                        self.tblPreCheck.reloadData()
                    }
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
                custSignCell.didExpand = { chk  in
                    if chk {
                        SignatureViewController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!) { val in
                
                        } didFinish: { txt in
                
                        }
                    }
                }
                return custSignCell
            } else {
                let saveCell = self.tblPreCheck.dequeueReusableCell(withIdentifier: "SaveCell", for: indexPath) as! SaveCell
                saveCell.datasource = "" as AnyObject
                saveCell.didSave = { save in
                    self.isSave = save
                }
                saveCell.didReset = { reset in
                    self.isReset = reset
                    self.tblPreCheck.reloadData()
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
}

// MARK: OdometerCell
class OdometerCell: BaseTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var txtOdometer: CustomTextField!
    @IBOutlet weak var txtSelect: CustomTextField!
    @IBOutlet weak var txtMiles: CustomTextField!
    var didSendSignal:((Bool) -> ())!
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
    
}


// MARK: RegCell
class RegPrecheckCell: BaseTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var txtReg: CustomTextField!
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
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                self.lblContent.text = datasource as? String
                txtView.textColor = .fontColor
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
        btnDel.addTarget(self, action: #selector(delImg), for: .touchUpInside)
        cell.contentView.addSubview(btnDel)
        return cell
    }
    
    @objc func delImg(_ sender: UIButton) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60.0, height: 60.0)
    }
    
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

// MARK: ExteriorIssuesCell
class ExteriorIssueCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
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
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                self.lblContent.text = datasource as? String
                txtView.textColor = .fontColor
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
        btnDel.addTarget(self, action: #selector(delImg), for: .touchUpInside)
        cell.contentView.addSubview(btnDel)
        return cell
    }
    
    @objc func delImg(_ sender: UIButton) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60.0, height: 60.0)
    }
    
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

// MARK: InteriorIssuesCell
class InteriorIssueCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
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
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                self.lblContent.text = datasource as? String
                txtView.textColor = .fontColor
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
        btnDel.addTarget(self, action: #selector(delImg), for: .touchUpInside)
        cell.contentView.addSubview(btnDel)
        return cell
    }
    
    @objc func delImg(_ sender: UIButton) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60.0, height: 60.0)
    }
    
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
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var viewBG: UIView!
    var didExpand:((Bool) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
                txtName.layer.cornerRadius = 25.0
                signatureView.layer.cornerRadius = 10.0
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
        signatureView.layer.borderWidth = 0.5
        signatureView.layer.borderColor = UIColor.black.cgColor
        signatureView.layer.cornerRadius = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        print("Save")
        self.didSave!(true)
    }
    
    @objc func resetData(_ sender: UIButton) {
        self.didReset!(true)
    }
}
