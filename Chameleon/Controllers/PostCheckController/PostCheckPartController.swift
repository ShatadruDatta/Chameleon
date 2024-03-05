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
    var didCaptureData: ((_ unitPosition: UIImage, _ permConn: UIImage, _ earthConn: UIImage, _ ignConn: UIImage, _ serial: UIImage, _ loom: UIImage, _ comments: String) -> ())!
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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func menu(_ sender: UIButton) {
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
                imgCell.lblImg2.text = "Perm Conn"
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
            case 2:
                let imgCell = self.tblViewPostPart.dequeueReusableCell(withIdentifier: "FrontImageCaptureCell", for: indexPath) as! FrontImageCaptureCell
                imgCell.datasource = "" as AnyObject
                imgCell.lblImg1.text = "Earth Conn"
                imgCell.lblImg2.text = "Ign Conn"
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
                let imgCell = self.tblViewPostPart.dequeueReusableCell(withIdentifier: "PassengerImageCaptureCell", for: indexPath) as! PassengerImageCaptureCell
                imgCell.datasource = "" as AnyObject
                imgCell.lblImg1.text = "Earth Conn"
                imgCell.lblImg2.text = "Ign Conn"
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
                return commentsCell
            default:
                let saveCell = self.tblViewPostPart.dequeueReusableCell(withIdentifier: "SaveButtonCell", for: indexPath) as! SaveButtonCell
                saveCell.datasource = "" as AnyObject
                return saveCell
            }
        }
    }
}


// MARK: CommentsCell
class CommentsCell: BaseTableViewCell, UITextViewDelegate {
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var txtView: UITextView!
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
                btnSave.addTarget(self, action: #selector(save), for: .touchUpInside)
            }
        }
    }
    @objc func save(_ sender: UIButton) {
        print("Save")
        self.didSave!(true)
    }
}
