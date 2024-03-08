//
//  PostCheckPartController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 05/03/24.
//

import UIKit

class PostCheckPartController: BaseViewController {

    @IBOutlet weak var tblViewPostPart: UITableView!
    @IBOutlet weak var viewPreCheck: UIView!
    @IBOutlet weak var viewPostCheck: UIView!
    @IBOutlet weak var viewClosure: UIView!
    var didCaptureData: ((_ index: Int, _ unitPosition: UIImage, _ isUnitPositionImg: Bool, _ permConn: UIImage, _ isPermConnImg: Bool, _ earthConn: UIImage, _ isEarthConnImg: Bool, _ ignConn: UIImage, _ isIgnConnImg: Bool, _ serial: UIImage, _ isSerialImg: Bool, _ loom: UIImage, _ isLoomImg: Bool, _ comments: String) -> ())!
    var index: Int!
    var unitPosition = UIImage(named: "ImgCapBg")
    var isUnitPositionImg = false
    var permConn = UIImage(named: "ImgCapBg")
    var isPermConnImg = false
    var earthConn = UIImage(named: "ImgCapBg")
    var isEarthConnImg = false
    var ignConn = UIImage(named: "ImgCapBg")
    var isIgnConnImg = false
    var serial = UIImage(named: "ImgCapBg")
    var isSerialImg = false
    var loom = UIImage(named: "ImgCapBg")
    var isLoomImg = false
    var commnets = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblViewPostPart.reloadData()
        viewPreCheck.layer.cornerRadius = 10.0
        viewPostCheck.layer.cornerRadius = 10.0
        viewClosure.layer.cornerRadius = 10.0
        
        self.viewPreCheck.layer.masksToBounds = false
        self.viewPreCheck.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        self.viewPostCheck.layer.masksToBounds = false
        self.viewPostCheck.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        self.viewClosure.layer.masksToBounds = false
        self.viewClosure.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PostCheckPartController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostCheckPartController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            print("Notification: Keyboard will show")
            tblViewPostPart.setBottomInset(to: keyboardHeight)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        print("Notification: Keyboard will hide")
        tblViewPostPart.setBottomInset(to: 0.0)
    }
    
    @IBAction func back(_ sender: UIButton) {
        NavigationHelper.helper.contentNavController!.popViewController(animated: true)
    }
}


extension PostCheckPartController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 50.0
            default:
                return 197.0
            }
        } else {
            switch indexPath.row {
            case 0:
                return 50.0
            case 1:
                return 112.0
            default:
                return 80.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblViewPostPart.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Add Device"
                headerCell.imgContent.image = UIImage(named: "TestReport")
                return headerCell
            case 1:
                let imgCell = self.tblViewPostPart.dequeueReusableCell(withIdentifier: "DashImageCaptureCell", for: indexPath) as! DashImageCaptureCell
                imgCell.datasource = "" as AnyObject
                imgCell.lblImg1.text = "Unit Position"
                imgCell.imgView1.image = self.unitPosition
                imgCell.lblAddImage1.isHidden = self.isUnitPositionImg ? true : false
                imgCell.imgCamera1.isHidden = self.isUnitPositionImg ? true : false
                imgCell.btnDel1.isHidden = self.isUnitPositionImg ? false : true
                imgCell.lblImg2.text = "Perm Conn"
                imgCell.imgView2.image = self.permConn
                imgCell.lblAddImage2.isHidden = self.isPermConnImg ? true : false
                imgCell.imgCamera2.isHidden = self.isPermConnImg ? true : false
                imgCell.btnDel2.isHidden = self.isPermConnImg ? false : true
                imgCell.didFirstImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        self.unitPosition = image
                        self.isUnitPositionImg = true
                        imgCell.imgView1.image = image
                        imgCell.lblAddImage1.isHidden = true
                        imgCell.imgCamera1.isHidden = true
                        imgCell.btnDel1.isHidden = false
                    }
                }
                imgCell.delImage1 = { check in
                    self.unitPosition = UIImage(named: "ImgCapBg")
                    self.isUnitPositionImg = false
                    imgCell.imgView1.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage1.isHidden = false
                    imgCell.imgCamera1.isHidden = false
                    imgCell.btnDel1.isHidden = true
                }
                imgCell.didSecondImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        self.permConn = image
                        self.isPermConnImg = true
                        imgCell.imgView2.image = image
                        imgCell.lblAddImage2.isHidden = true
                        imgCell.imgCamera2.isHidden = true
                        imgCell.btnDel2.isHidden = false
                    }
                }
                imgCell.delImage2 = { check in
                    self.permConn = UIImage(named: "ImgCapBg")
                    self.isPermConnImg = false
                    imgCell.imgView2.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage2.isHidden = false
                    imgCell.imgCamera2.isHidden = false
                    imgCell.btnDel2.isHidden = true
                }
                return imgCell
            case 2:
                let imgCell = self.tblViewPostPart.dequeueReusableCell(withIdentifier: "FrontImageCaptureCell", for: indexPath) as! FrontImageCaptureCell
                imgCell.datasource = "" as AnyObject
                imgCell.lblImg1.text = "Earth Conn"
                imgCell.imgView1.image = self.earthConn
                imgCell.lblAddImage1.isHidden = self.isEarthConnImg ? true : false
                imgCell.imgCamera1.isHidden = self.isEarthConnImg ? true : false
                imgCell.btnDel1.isHidden = self.isEarthConnImg ? false : true
                imgCell.lblImg2.text = "Ign Conn"
                imgCell.imgView2.image = self.ignConn
                imgCell.lblAddImage2.isHidden = self.isIgnConnImg ? true : false
                imgCell.imgCamera2.isHidden = self.isIgnConnImg ? true : false
                imgCell.btnDel2.isHidden = self.isIgnConnImg ? false : true
                imgCell.didFirstImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        self.earthConn = image
                        self.isEarthConnImg = true
                        imgCell.imgView1.image = image
                        imgCell.lblAddImage1.isHidden = true
                        imgCell.imgCamera1.isHidden = true
                        imgCell.btnDel1.isHidden = false
                    }
                }
                imgCell.delImage1 = { check in
                    self.earthConn = UIImage(named: "ImgCapBg")
                    self.isEarthConnImg = false
                    imgCell.imgView1.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage1.isHidden = false
                    imgCell.imgCamera1.isHidden = false
                    imgCell.btnDel1.isHidden = true
                }
                imgCell.didSecondImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        self.ignConn = image
                        self.isIgnConnImg = true
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
                let imgCell = self.tblViewPostPart.dequeueReusableCell(withIdentifier: "PassengerImageCaptureCell", for: indexPath) as! PassengerImageCaptureCell
                imgCell.datasource = "" as AnyObject
                imgCell.lblImg1.text = "Serial/IMEI"
                imgCell.imgView1.image = self.serial
                imgCell.lblAddImage1.isHidden = self.isSerialImg ? true : false
                imgCell.imgCamera1.isHidden = self.isSerialImg ? true : false
                imgCell.btnDel1.isHidden = self.isSerialImg ? false : true
                imgCell.lblImg2.text = "Loom"
                imgCell.imgView2.image = self.loom
                imgCell.lblAddImage2.isHidden = self.isLoomImg ? true : false
                imgCell.imgCamera2.isHidden = self.isLoomImg ? true : false
                imgCell.btnDel2.isHidden = self.isLoomImg ? false : true
                imgCell.didFirstImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        self.serial = image
                        self.isSerialImg = true
                        imgCell.imgView1.image = image
                        imgCell.lblAddImage1.isHidden = true
                        imgCell.imgCamera1.isHidden = true
                        imgCell.btnDel1.isHidden = false
                    }
                }
                imgCell.delImage1 = { check in
                    self.serial = UIImage(named: "ImgCapBg")
                    self.isSerialImg = false
                    imgCell.imgView1.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage1.isHidden = false
                    imgCell.imgCamera1.isHidden = false
                    imgCell.btnDel1.isHidden = true
                }
                imgCell.didSecondImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        self.loom = image
                        self.isLoomImg = true
                        imgCell.imgView2.image = image
                        imgCell.lblAddImage2.isHidden = true
                        imgCell.imgCamera2.isHidden = true
                        imgCell.btnDel2.isHidden = false
                    }
                }
                imgCell.delImage2 = { check in
                    self.loom = UIImage(named: "ImgCapBg")
                    self.isLoomImg = false
                    imgCell.imgView2.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage2.isHidden = false
                    imgCell.imgCamera2.isHidden = false
                    imgCell.btnDel2.isHidden = true
                }
                return imgCell
            }
        } else {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblViewPostPart.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Engineers Comments"
                headerCell.imgContent.image = UIImage(named: "TestReport")
                return headerCell
            case 1:
                let commentsCell = self.tblViewPostPart.dequeueReusableCell(withIdentifier: "CommentsCell", for: indexPath) as! CommentsCell
                commentsCell.datasource = "" as AnyObject
                commentsCell.txtView.text = self.commnets
                commentsCell.didUpdateText = { val in
                    self.commnets = val
                }
                return commentsCell
            default:
                let saveCell = self.tblViewPostPart.dequeueReusableCell(withIdentifier: "SaveButtonCell", for: indexPath) as! SaveButtonCell
                saveCell.datasource = "" as AnyObject
                saveCell.btnSave.addTarget(self, action: #selector(save), for: .touchUpInside)
                return saveCell
            }
        }
    }
    
    @objc func save(_ sender: UIButton) {
        self.didCaptureData!(index, self.unitPosition ?? UIImage(), self.isUnitPositionImg, self.permConn ?? UIImage(), self.isPermConnImg, self.earthConn ?? UIImage(), self.isEarthConnImg, self.ignConn ?? UIImage(), self.isIgnConnImg, self.serial ?? UIImage(), self.isSerialImg, self.loom ?? UIImage(), self.isLoomImg, self.commnets)
        NavigationHelper.helper.contentNavController!.popViewController(animated: true)
    }
}


// MARK: CommentsCell
class CommentsCell: BaseTableViewCell, UITextViewDelegate {
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var txtView: UITextView!
    var didUpdateText:((String) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                txtView.textColor = .fontColor
                parentView.layer.cornerRadius = 10.0
            }
        }
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
            textView.text = "Comments"
            textView.textColor = UIColor.fontColor
        }
    }
}


// MARK: SaveButtonCell
class SaveButtonCell: BaseTableViewCell {
    @IBOutlet weak var btnSave: UIButton!
    var didSave:((Bool) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
            }
        }
    }
}
