//
//  WorkViewController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 05/01/24.
//

import UIKit
import SJFluidSegmentedControl

class WorkViewController: BaseViewController {

    @IBOutlet weak var txtSearch: CustomTextField!
    @IBOutlet weak var customSegmentControl: SJFluidSegmentedControl!
    @IBOutlet weak var parentViewSegment: UIView!
    @IBOutlet weak var tblViewWorklist: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @Published var workDataModel: WorkViewDataModel?
    var currentIndex = 0
    var workStatus = "today"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSearch.layer.cornerRadius = 24.0
        self.txtSearch.setupRightImage(imageName: "Search", width: 20.26, height: 20.72)
        self.parentViewSegment.layer.cornerRadius = 30.0
        self.parentViewSegment.layer.masksToBounds = false
        self.parentViewSegment.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        self.tblViewWorklist.estimatedRowHeight = 130.0
        self.tblViewWorklist.rowHeight = UITableView.automaticDimension
        NavigationHelper.helper.tabBarViewController?.isShowBottomBar(isShow: true)
        self.workView()
    }
    
    //  MARK: WorkViewAPI
    @objc func workView() {
        self.activity.startAnimating()
        let baseurl = "\(baseurl)/v1/joborder?filter=\(workStatus)"
        print(baseurl)
        let headers = ["x-api-key" : apiKey, "X-Token": Chameleon.token]
        AFWrapper.requestGETURL(baseurl, headers: headers) { [self] jsonVal, data in
            print(jsonVal)
            self.workDataModel = nil
            self.activity.stopAnimating()
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(WorkViewDataModel.self, from: data)
                workDataModel = data
                self.tblViewWorklist.reloadData()
            } catch {
                SharedClass.sharedInstance.alert(view: self, title: "Failure", message: error.localizedDescription)
            }
        } failure: { error in
            self.activity.stopAnimating()
            SharedClass.sharedInstance.alert(view: self, title: "Failure", message: error.localizedDescription)
        }
    }
    
    @IBAction func menu(_ sender: UIButton) {
        NavigationHelper.helper.openSidePanel(open: true)
    }
}

// MARK: CustomSegmentedControl
extension WorkViewController: SJFluidSegmentedControlDataSource, SJFluidSegmentedControlDelegate {
    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {
        return 4
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          titleForSegmentAtIndex index: Int) -> String? {
        if index == 0 {
            return "Todays Work"
        } else if index == 1 {
            return "To be closed"
        } else if index == 2 {
            return "Assigned"
        } else {
            return "Closed"
        }
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                                         didChangeFromSegmentAtIndex fromIndex: Int,
                          toSegmentAtIndex toIndex:Int) {
        currentIndex = toIndex
        self.tblViewWorklist.reloadData()
    }
}

// MARK: TableViewDataSource, TableViewDelegate
extension WorkViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workDataModel?.result.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentIndex == 0 {
            let workListCell = self.tblViewWorklist.dequeueReusableCell(withIdentifier: "WorkListCell", for: indexPath) as! WorkListCell
            workListCell.datasource = "" as AnyObject
            workListCell.lblDesc.text = "\(self.workDataModel?.result[indexPath.row].serviceID.name ?? "") \(self.workDataModel?.result[indexPath.row].productInstallID.name ?? "")"
            let time = self.workDataModel?.result[indexPath.row].appointment.components(separatedBy: " ")
            let dateAsString = time?[1].timeConversion12(time24: time?[1] ?? "")
            workListCell.time.text = dateAsString ?? ""
            workListCell.personName.text = self.workDataModel?.result[indexPath.row].contactName ?? ""
            workListCell.ncNumber = self.workDataModel?.result[indexPath.row].ncBNCNumber
            workListCell.contactNo = self.workDataModel?.result[indexPath.row].contactNumber
            workListCell.carRegNo = self.workDataModel?.result[indexPath.row].carRegNo
            workListCell.zipCode = self.workDataModel?.result[indexPath.row].installationAddress.postcode
            workListCell.selectionStyle = .none
            return workListCell
        } else if currentIndex == 1 {
            let closedListCell = self.tblViewWorklist.dequeueReusableCell(withIdentifier: "ToBeClosedListCell", for: indexPath) as! ToBeClosedListCell
            closedListCell.datasource = "" as AnyObject
            closedListCell.selectionStyle = .none
            return closedListCell
        } else if currentIndex == 2 {
            let assignedListCell = self.tblViewWorklist.dequeueReusableCell(withIdentifier: "AssignedListCell", for: indexPath) as! AssignedListCell
            assignedListCell.datasource = "" as AnyObject
            assignedListCell.selectionStyle = .none
            return assignedListCell
        } else {
            let closedListCell = self.tblViewWorklist.dequeueReusableCell(withIdentifier: "ClosedListCell", for: indexPath) as! ClosedListCell
            closedListCell.datasource = "" as AnyObject
            closedListCell.selectionStyle = .none
            return closedListCell
        }
    }
}


//MARK: CustomWorkCell
class WorkListCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var btnMap: UIImageView!
    @IBOutlet weak var collTask: UICollectionView!
    @IBOutlet weak var lblDesc: UILabel!
    var ncNumber: String?
    var contactNo: String?
    var zipCode: String?
    var carRegNo: String?
    
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                parentView.layer.cornerRadius = 15.0
                collTask.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let workListCollCell = self.collTask.dequeueReusableCell(withReuseIdentifier: "WorkListCollCell", for: indexPath) as! WorkListCollCell
        switch indexPath.item {
        case 0:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "f8eede")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "f19e38")
            workListCollCell.lblTask.text = ncNumber
            workListCollCell.imgIcon.image = UIImage(named: "Doc_yellow")
        case 1:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "e3e9fa")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "123293")
            workListCollCell.lblTask.text = contactNo
            workListCollCell.imgIcon.image = UIImage(named: "solar_phone")
        case 2:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "e5fef5")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "56b880")
            workListCollCell.lblTask.text = zipCode
            workListCollCell.imgIcon.image = UIImage(named: "Loc_Green")
        default:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "ede5fd")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "794fcc")
            workListCollCell.lblTask.text = carRegNo
            workListCollCell.imgIcon.image = UIImage(named: "Car_Purple")
        }
        workListCollCell.datasource = "" as AnyObject
        return workListCollCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let precheckVC = mainStoryboard.instantiateViewController(withIdentifier: "ClosureController") as! ClosureController
        NavigationHelper.helper.contentNavController!.pushViewController(precheckVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 24)
    }

}


//MARK: WorkListCollBtnCell
class WorkListCollCell: BaseCollectionViewCell {
    @IBOutlet weak var parentCollView: UIView!
    @IBOutlet weak var lblTask: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                parentCollView.layer.cornerRadius = 5.0
            }
        }
    }
}


//MARK: CustomToBeClosedCell
class ToBeClosedListCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var collTask: UICollectionView!
    @IBOutlet weak var lblDesc: UILabel!
    
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                parentView.layer.cornerRadius = 15.0
                self.lblDesc.text = "khadgfhdagfhafghakdfgakhfgadfkadgh"
                collTask.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let workListCollCell = self.collTask.dequeueReusableCell(withReuseIdentifier: "WorkListCollCell", for: indexPath) as! WorkListCollCell
        switch indexPath.item {
        case 0:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "f8eede")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "f19e38")
        case 1:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "e3e9fa")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "123293")
        case 2:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "e5fef5")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "56b880")
        default:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "ede5fd")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "794fcc")
        }
        workListCollCell.datasource = "" as AnyObject
        return workListCollCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: "NC123456".size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width + 25, height: 24)
    }
}


//MARK: AssignedListCell
class AssignedListCell: BaseTableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var lblDescAssigned: UILabel!
    
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                parentView.layer.cornerRadius = 15.0
                self.lblDescAssigned.text = "khadgfhdagfhafghakdfgakhfgadfkadgh"
            }
        }
    }
}

//MARK: CustomClosedCell
class ClosedListCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var collTask: UICollectionView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnRedCar: UIButton!
    @IBOutlet weak var btnYellowCar: UIButton!
    @IBOutlet weak var btnGreenCar: UIButton!
    
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                parentView.layer.cornerRadius = 15.0
                self.lblDesc.text = "khadgfhdagfhafghakdfgakhfgadfkadgh"
                collTask.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let workListCollCell = self.collTask.dequeueReusableCell(withReuseIdentifier: "WorkListCollCell", for: indexPath) as! WorkListCollCell
        switch indexPath.item {
        case 0:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "f8eede")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "f19e38")
        case 1:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "e3e9fa")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "123293")
        case 2:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "e5fef5")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "56b880")
        default:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "ede5fd")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "794fcc")
        }
        workListCollCell.datasource = "" as AnyObject
        return workListCollCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: "NC123456".size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width + 25, height: 24)
    }

}
