//
//  WorkViewController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 05/01/24.
//

import UIKit
import CoreLocation
import SJFluidSegmentedControl
import MapKit

class WorkViewController: BaseViewController {

    @IBOutlet weak var txtSearch: CustomTextField!
    @IBOutlet weak var customSegmentControl: SJFluidSegmentedControl!
    @IBOutlet weak var parentViewSegment: UIView!
    @IBOutlet weak var tblViewWorklist: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @Published var workDataModel: WorkViewDataModel?
    @Published var arrBookingInformation: [(roomBookedName: String, createdAt: String, id: Int, datasheetId: Int, roomConfirmationNumber: String, hotelZip: String, hotelState: String, sessionId: Int, hotelName: String, hotelPhone: String, hotelId: Int, roomCost: Int, hotelCity: String, createdBy: String, hotelAddress: String)] = []
    var currentIndex = 0
    var workStatus = "today"
    var isSearch: Bool = false
    var tableFilterData: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSearch.layer.cornerRadius = 24.0
        self.txtSearch.setupRightImage(imageName: "Search", width: 20.26, height: 20.72)
        self.parentViewSegment.layer.cornerRadius = 30.0
        self.parentViewSegment.layer.masksToBounds = false
        self.parentViewSegment.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        self.tblViewWorklist.estimatedRowHeight = 130.0
        self.tblViewWorklist.rowHeight = UITableView.automaticDimension
        NavigationHelper.helper.tabBarViewController?.isShowBottomBar(isShow: false)
        self.workView()
    }
    
    //  MARK: WorkViewAPI
    @objc func workView() {
        if Reachability.isConnectedToNetwork() {
            self.activity.startAnimating()
            self.tblViewWorklist.isHidden = true
            let baseurl = "\(baseurl)/v1/joborder?filter=\(workStatus)"
            print(baseurl)
            let headers = ["x-api-key" : apiKey, "x-token": Chameleon.token]
            AFWrapper.requestGETURL(baseurl, headers: headers) { [self] jsonVal, data in
                print(jsonVal)
                self.workDataModel = nil
                self.activity.stopAnimating()
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(WorkViewDataModel.self, from: data)
                    workDataModel = data
                    if workDataModel?.result.count ?? 0 > 0 {
                        self.tblViewWorklist.isHidden = false
                        self.lblNoDataFound.isHidden = true
                        self.tblViewWorklist.reloadData()
                    } else {
                        self.tblViewWorklist.isHidden = true
                        self.lblNoDataFound.isHidden = false
                    }
                } catch {
                    self.tblViewWorklist.isHidden = true
                    SharedClass.sharedInstance.alert(view: self, title: "Failure", message: jsonVal["message"].stringValue)
                }
            } failure: { error in
                self.activity.stopAnimating()
                self.tblViewWorklist.isHidden = true
                SharedClass.sharedInstance.alert(view: self, title: "Failure", message: error.localizedDescription)
            }
        } else {
            NoInternetController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!) { contextVal in } didFinish: { txt in }
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
        switch currentIndex {
        case 0:
            workStatus = "today"
        case 1:
            workStatus = "to_be_closed"
        case 2:
            workStatus = ""
        default:
            workStatus = "closed"
        }
        self.lblNoDataFound.isHidden = true
        self.workView()
    }
}

// MARK: TableViewDataSource, TableViewDelegate
extension WorkViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return tableFilterData.count
        } else {
            return self.workDataModel?.result.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: MapOpen
    @objc func cellTappedMethod(_ sender: AnyObject) {
        print(sender.view.tag)
        if isSearch {
            let lat = tableFilterData[sender.view.tag].installationAddress.latitude
            let lon = tableFilterData[sender.view.tag].installationAddress.longitude
            let place = tableFilterData[sender.view.tag].installationAddress.street + tableFilterData[sender.view.tag].installationAddress.street2 + tableFilterData[sender.view.tag].installationAddress.street3
            self.openMapForPlace(lat: Double(lat), lon: Double(lon), place: place)
        } else {
            let lat = self.workDataModel?.result[sender.view.tag].installationAddress.latitude ?? 0
            let lon = self.workDataModel?.result[sender.view.tag].installationAddress.longitude ?? 0
            let street1 = self.workDataModel?.result[sender.view.tag].installationAddress.street ?? "NA"
            let street2 = self.workDataModel?.result[sender.view.tag].installationAddress.street2 ?? "NA"
            let street3 = self.workDataModel?.result[sender.view.tag].installationAddress.street3 ?? "NA"
            let place = street1 + street2 + street3
            self.openMapForPlace(lat: Double(lat), lon: Double(lon), place: place)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentIndex == 0 {
            let workListCell = self.tblViewWorklist.dequeueReusableCell(withIdentifier: "WorkListCell", for: indexPath) as! WorkListCell
            workListCell.datasource = "" as AnyObject
            if isSearch {
                workListCell.lblDesc.text = "\(tableFilterData[indexPath.row].serviceID.name) \(tableFilterData[indexPath.row].productInstallID.name)"
                let time = tableFilterData[indexPath.row].appointment.components(separatedBy: " ")
                let dateAsString = time[1].timeConversion12(time24: time[1])
                workListCell.time.text = dateAsString
                workListCell.personName.text = tableFilterData[indexPath.row].contactName.count > 0 ? tableFilterData[indexPath.row].contactName : "NA"
                workListCell.ncNumber = tableFilterData[indexPath.row].ncBNCNumber.count > 0 ? tableFilterData[indexPath.row].ncBNCNumber : "NA"
                workListCell.contactNo = tableFilterData[indexPath.row].contactNumber.count > 0 ? tableFilterData[indexPath.row].contactNumber : "NA"
                workListCell.carRegNo = tableFilterData[indexPath.row].carRegNo.count > 0 ? tableFilterData[indexPath.row].carRegNo : "NA"
                workListCell.zipCode = tableFilterData[indexPath.row].installationAddress.postcode.count > 0 ? tableFilterData[indexPath.row].installationAddress.postcode : "NA"
                workListCell.jobId = tableFilterData[indexPath.row].id
                workListCell.btnMap.isUserInteractionEnabled = true
                workListCell.btnMap.tag = indexPath.row
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod))
                workListCell.btnMap.addGestureRecognizer(gestureRecognizer)
            } else {
                workListCell.lblDesc.text = "\(self.workDataModel?.result[indexPath.row].serviceID.name ?? "") \(self.workDataModel?.result[indexPath.row].productInstallID.name ?? "")"
                let time = self.workDataModel?.result[indexPath.row].appointment.components(separatedBy: " ")
                let dateAsString = time?[1].timeConversion12(time24: time?[1] ?? "")
                workListCell.time.text = dateAsString ?? ""
                workListCell.personName.text = self.workDataModel?.result[indexPath.row].contactName ?? ""
                workListCell.ncNumber = self.workDataModel?.result[indexPath.row].ncBNCNumber.count ?? 0 > 0 ? self.workDataModel?.result[indexPath.row].ncBNCNumber : "NA"
                workListCell.contactNo = self.workDataModel?.result[indexPath.row].contactNumber.count ?? 0 > 0 ? self.workDataModel?.result[indexPath.row].contactNumber : "NA"
                workListCell.carRegNo = self.workDataModel?.result[indexPath.row].carRegNo.count ?? 0 > 0 ? self.workDataModel?.result[indexPath.row].carRegNo : "NA"
                workListCell.zipCode = self.workDataModel?.result[indexPath.row].installationAddress.postcode.count ?? 0 > 0 ? self.workDataModel?.result[indexPath.row].installationAddress.postcode : "NA"
                workListCell.jobId = self.workDataModel?.result[indexPath.row].id
                workListCell.btnMap.isUserInteractionEnabled = true
                workListCell.btnMap.tag = indexPath.row
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod))
                workListCell.btnMap.addGestureRecognizer(gestureRecognizer)
            }
            workListCell.selectionStyle = .none
            return workListCell
        } else if currentIndex == 1 {
            let closedListCell = self.tblViewWorklist.dequeueReusableCell(withIdentifier: "ToBeClosedListCell", for: indexPath) as! ToBeClosedListCell
            closedListCell.datasource = "" as AnyObject
            if isSearch {
                closedListCell.lblDesc.text = "\(tableFilterData[indexPath.row].serviceID.name) \(self.workDataModel?.result[indexPath.row].productInstallID.name ?? "")"
                closedListCell.taskName.text = tableFilterData[indexPath.row].ncBNCNumber
                if tableFilterData[indexPath.row].contactNumber.count > 3 {
                    closedListCell.contactNo = tableFilterData[indexPath.row].contactNumber
                } else {
                    closedListCell.contactNo = "NA"
                }
                if tableFilterData[indexPath.row].carRegNo.count > 3 {
                    closedListCell.carRegNo = tableFilterData[indexPath.row].carRegNo
                } else {
                    closedListCell.carRegNo = "NA"
                }
                closedListCell.zipCode = tableFilterData[indexPath.row].installationAddress.postcode
            } else {
                closedListCell.lblDesc.text = "\(self.workDataModel?.result[indexPath.row].serviceID.name ?? "") \(self.workDataModel?.result[indexPath.row].productInstallID.name ?? "")"
                closedListCell.taskName.text = self.workDataModel?.result[indexPath.row].ncBNCNumber
                if self.workDataModel?.result[indexPath.row].contactNumber.count ?? 0 > 3 {
                    closedListCell.contactNo = self.workDataModel?.result[indexPath.row].contactNumber
                } else {
                    closedListCell.contactNo = "NA"
                }
                if self.workDataModel?.result[indexPath.row].carRegNo.count ?? 0 > 3 {
                    closedListCell.carRegNo = self.workDataModel?.result[indexPath.row].carRegNo
                } else {
                    closedListCell.carRegNo = "NA"
                }
                closedListCell.zipCode = self.workDataModel?.result[indexPath.row].installationAddress.postcode
            }
            closedListCell.selectionStyle = .none
            return closedListCell
        } else if currentIndex == 2 {
            let assignedListCell = self.tblViewWorklist.dequeueReusableCell(withIdentifier: "AssignedListCell", for: indexPath) as! AssignedListCell
            assignedListCell.datasource = "" as AnyObject
            if isSearch {
                assignedListCell.lblDescAssigned.text = "\(tableFilterData[indexPath.row].serviceID.name) \(tableFilterData[indexPath.row].productInstallID.name)"
                assignedListCell.taskName.text = tableFilterData[indexPath.row].ncBNCNumber
                let time = tableFilterData[indexPath.row].appointment.components(separatedBy: " ")
                let dateAsString = time[1].timeConversion12(time24: time[1])
                assignedListCell.time.text = dateAsString
            } else {
                assignedListCell.lblDescAssigned.text = "\(self.workDataModel?.result[indexPath.row].serviceID.name ?? "") \(self.workDataModel?.result[indexPath.row].productInstallID.name ?? "")"
                assignedListCell.taskName.text = self.workDataModel?.result[indexPath.row].ncBNCNumber
                let time = self.workDataModel?.result[indexPath.row].appointment.components(separatedBy: " ")
                let dateAsString = time?[1].timeConversion12(time24: time?[1] ?? "")
                assignedListCell.time.text = dateAsString ?? ""
            }
            
            assignedListCell.selectionStyle = .none
            return assignedListCell
        } else {
            let closedListCell = self.tblViewWorklist.dequeueReusableCell(withIdentifier: "ClosedListCell", for: indexPath) as! ClosedListCell
            closedListCell.datasource = "" as AnyObject
            if isSearch {
                closedListCell.lblDesc.text = "\(tableFilterData[indexPath.row].serviceID.name) \(tableFilterData[indexPath.row].productInstallID.name)"
                closedListCell.taskName.text = tableFilterData[indexPath.row].ncBNCNumber
                if tableFilterData[indexPath.row].contactNumber.count > 3 {
                    closedListCell.contactNo = tableFilterData[indexPath.row].contactNumber
                } else {
                    closedListCell.contactNo = "NA"
                }
                if tableFilterData[indexPath.row].carRegNo.count > 3 {
                    closedListCell.carRegNo = tableFilterData[indexPath.row].carRegNo
                } else {
                    closedListCell.carRegNo = "NA"
                }
                closedListCell.zipCode = tableFilterData[indexPath.row].installationAddress.postcode
            } else {
                closedListCell.lblDesc.text = "\(self.workDataModel?.result[indexPath.row].serviceID.name ?? "") \(self.workDataModel?.result[indexPath.row].productInstallID.name ?? "")"
                closedListCell.taskName.text = self.workDataModel?.result[indexPath.row].ncBNCNumber
                if self.workDataModel?.result[indexPath.row].contactNumber.count ?? 0 > 3 {
                    closedListCell.contactNo = self.workDataModel?.result[indexPath.row].contactNumber
                } else {
                    closedListCell.contactNo = "NA"
                }
                if self.workDataModel?.result[indexPath.row].carRegNo.count ?? 0 > 3 {
                    closedListCell.carRegNo = self.workDataModel?.result[indexPath.row].carRegNo
                } else {
                    closedListCell.carRegNo = "NA"
                }
                closedListCell.zipCode = self.workDataModel?.result[indexPath.row].installationAddress.postcode
            }
            
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
    @IBOutlet weak var btnStartNow: UIButton!
    var ncNumber: String?
    var contactNo: String?
    var zipCode: String?
    var carRegNo: String?
    var jobId: Int!
    
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                parentView.layer.cornerRadius = 15.0
                collTask.reloadData()
                btnStartNow.addTarget(self, action: #selector(startNow), for: .touchUpInside)
            }
        }
    }
    
    @objc func startNow() {
        let jobSheetVC = mainStoryboard.instantiateViewController(withIdentifier: "JobSheetController") as! JobSheetController
        JobSheetData.jobId = jobId
        JobSheetData.nc_bnc_number = ncNumber ?? ""
        NavigationHelper.helper.contentNavController!.pushViewController(jobSheetVC, animated: true)
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
        if indexPath.item == 0 {
            let precheckVC = mainStoryboard.instantiateViewController(withIdentifier: "ClosureController") as! ClosureController
            NavigationHelper.helper.contentNavController!.pushViewController(precheckVC, animated: true)
        } else if indexPath.item == 1 {
            let contactNumbers = self.contactNo?.count ?? 0 > 0 ? self.contactNo : "NA"
            let conNo = contactNumbers?.components(separatedBy: "/")
            if let url = NSURL(string: "tel://\(conNo?[0] ?? "NA")") {
                UIApplication.shared.open(url as URL)
            }
        } else {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 - 10, height: 24) //160
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let workListCollCell = self.collTask.dequeueReusableCell(withReuseIdentifier: "WorkListCollCell", for: indexPath) as! WorkListCollCell
        switch indexPath.item {
        case 0:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "e5fef5")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "56b880")
            workListCollCell.lblTask.text = zipCode
            workListCollCell.imgIcon.image = UIImage(named: "Loc_Green")
        case 1:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "ede5fd")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "794fcc")
            workListCollCell.lblTask.text = carRegNo
            workListCollCell.imgIcon.image = UIImage(named: "Car_Purple")
        default:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "e3e9fa")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "123293")
            workListCollCell.lblTask.text = contactNo
            workListCollCell.imgIcon.image = UIImage(named: "solar_phone")
        }
        workListCollCell.datasource = "" as AnyObject
        return workListCollCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 2 {
            let contactNumbers = self.contactNo?.count ?? 0 > 0 ? self.contactNo : "NA"
            let conNo = contactNumbers?.components(separatedBy: "/")
            if let url = NSURL(string: "tel://\(conNo?[0] ?? "NA")") {
                UIApplication.shared.open(url as URL)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0:
            return CGSize(width: (zipCode?.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width ?? 0) + 50, height: 24)
        case 1:
            return CGSize(width: (carRegNo?.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width ?? 0) + 50, height: 24)
        default:
            return CGSize(width: (contactNo?.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width ?? 0) + 50, height: 24)
        }
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let workListCollCell = self.collTask.dequeueReusableCell(withReuseIdentifier: "WorkListCollCell", for: indexPath) as! WorkListCollCell
        switch indexPath.item {
        case 0:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "e5fef5")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "56b880")
            workListCollCell.lblTask.text = zipCode
            workListCollCell.imgIcon.image = UIImage(named: "Loc_Green")
        case 1:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "ede5fd")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "794fcc")
            workListCollCell.lblTask.text = carRegNo
            workListCollCell.imgIcon.image = UIImage(named: "Car_Purple")
        default:
            workListCollCell.parentCollView.backgroundColor = UIColor.init(hexString: "e3e9fa")
            workListCollCell.lblTask.textColor = UIColor.init(hexString: "123293")
            workListCollCell.lblTask.text = contactNo
            workListCollCell.imgIcon.image = UIImage(named: "solar_phone")
        }
        workListCollCell.datasource = "" as AnyObject
        return workListCollCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 2 {
            let contactNumbers = self.contactNo?.count ?? 0 > 0 ? self.contactNo : "NA"
            let conNo = contactNumbers?.components(separatedBy: "/")
            if let url = NSURL(string: "tel://\(conNo?[0] ?? "NA")") {
                UIApplication.shared.open(url as URL)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0:
            return CGSize(width: (zipCode?.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width ?? 0) + 50, height: 24)
        case 1:
            return CGSize(width: (carRegNo?.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width ?? 0) + 50, height: 24)
        default:
            return CGSize(width: (contactNo?.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width ?? 0) + 50, height: 24)
        }
    }
}


extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}


// MARK: TextFieldDelegate
extension WorkViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var searchText  = textField.text! + string
        if string  == "" {
            searchText = (searchText as String).substring(to: searchText.index(before: searchText.endIndex))
        }
        if searchText == "" {
            isSearch = false
            tblViewWorklist.reloadData()
        } else {
            getSearchArrayContains(searchText)
        }
        return true
    }

    func getSearchArrayContains(_ text : String) {
        tableFilterData = self.workDataModel?.result.filter({($0.contactName.lowercased().contains(text.lowercased())) || ($0.ncBNCNumber.lowercased().contains(text.lowercased())) || ($0.carRegNo.lowercased().contains(text.lowercased())) || ($0.installationAddress.postcode.lowercased().contains(text.lowercased())) || ($0.contactNumber.lowercased().contains(text.lowercased()))}) ?? []
        isSearch = true
        tblViewWorklist.reloadData()
    }
}


extension WorkViewController {
    func openMapForPlace(lat: Double, lon: Double, place: String) {
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = lon
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = place
        mapItem.openInMaps(launchOptions: options)
    }
}
