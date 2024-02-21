//
//  PrecheckController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 03/02/24.
//

import UIKit

class PrecheckController: BaseViewController {

    @IBOutlet weak var tblPreCheck: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

// MARK: TableViewDelegate, TableViewDataSource
extension PrecheckController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
