//
//  LaureatesTableViewController.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/29/21.
//

import UIKit
import Combine

class LaureatesTableViewController: UITableViewController {

    private let model = LaureatesViewModel.shared
    
    private var subscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subscriber = model.$laureates.sink { [weak self] _ in
            self?.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(20, model.laureates.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LaureateTableViewCell.cellIdentifier, for: indexPath)
        if let laureateCell = cell as? LaureateTableViewCell {
            let laureate = model.laureates[indexPath.row]
            laureateCell.laureate = laureate
        }
        return cell
    }
}
