//
//  ProductController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 06/03/24.
//

import UIKit

class ProductController: BaseViewController {

    @IBOutlet weak var tblProducts: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    var didSelectProd:((String) -> ())!
    var isSearch: Bool = false
    var tableFilterData: [ResultModels] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSearch.layer.cornerRadius = 24.0
        self.txtSearch.setupRightImage(imageName: "Search", width: 20.26, height: 20.72)
        self.tblProducts.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        NavigationHelper.helper.contentNavController!.popViewController(animated: true)
    }
}

// MARK: TableViewDelegate, TableViewDataSource
extension ProductController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return tableFilterData.count
        } else {
            return ProductParts.shared.prodModels?.result.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prodCell = self.tblProducts.dequeueReusableCell(withIdentifier: "ProdCell", for: indexPath) as! ProdCell
        if isSearch {
            if tableFilterData[indexPath.row].defaultCode ?? "" != "" {
                prodCell.datasource = tableFilterData[indexPath.row].defaultCode as AnyObject
            } else {
                prodCell.datasource = tableFilterData[indexPath.row].name as AnyObject
            }
        } else {
            if ProductParts.shared.prodModels?.result[indexPath.row].defaultCode ?? "" != "" {
                prodCell.datasource = (ProductParts.shared.prodModels?.result[indexPath.row].defaultCode ?? "") as AnyObject
            } else {
                prodCell.datasource = (ProductParts.shared.prodModels?.result[indexPath.row].name ?? "") as AnyObject
            }
        }
        return prodCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearch {
            if tableFilterData[indexPath.row].defaultCode ?? "" != "" {
                self.didSelectProd!(tableFilterData[indexPath.row].defaultCode ?? "")
            } else {
                self.didSelectProd!(tableFilterData[indexPath.row].name ?? "")
            }
        } else {
            if ProductParts.shared.prodModels?.result[indexPath.row].defaultCode ?? "" != "" {
                self.didSelectProd!(ProductParts.shared.prodModels?.result[indexPath.row].defaultCode ?? "")
            } else {
                self.didSelectProd!(ProductParts.shared.prodModels?.result[indexPath.row].name ?? "")
            }
        }
        NavigationHelper.helper.contentNavController!.popViewController(animated: true)
    }
}

// MARK: ProductCell
class ProdCell: BaseTableViewCell {
    @IBOutlet weak var lblProd: UILabel!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                self.lblProd.text = datasource as? String
            }
        }
    }
}

// MARK: TextFieldDelegate
extension ProductController: UITextFieldDelegate {
    
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
            tblProducts.reloadData()
        } else {
            getSearchArrayContains(searchText)
        }
        return true
    }
    
    func getSearchArrayContains(_ text : String) {
        tableFilterData = ProductParts.shared.prodModels?.result.filter({($0.defaultCode?.lowercased().contains(text.lowercased()))!}) ?? []
        isSearch = true
        tblProducts.reloadData()
    }
}
