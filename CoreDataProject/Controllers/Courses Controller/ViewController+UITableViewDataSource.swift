//
//  ViewController+UITableViewDataSource.swift
//  CoreDataProject
//
//  Created by Timur Saidov on 02/06/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDataSource {
    
    
    // MARK: Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isReset {
            return fetchedResultController.fetchedObjects?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cellID, for: indexPath)
        
        cell.textLabel?.text = fetchedResultController.object(at: indexPath).name
        
        return cell
    }
}
