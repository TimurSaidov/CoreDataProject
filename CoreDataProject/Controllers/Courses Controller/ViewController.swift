//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Timur Saidov on 02/06/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    
    // MARK: Public Structures
    
    enum Strings {
        static let name = "name"
        static let courses = "Courses"
        static let reset = "Reset"
        static let cellID = "cellID"
    }
    
    
    // MARK: Public Properties
    
    lazy var fetchedResultController: NSFetchedResultsController<Course> = {
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: Strings.name, ascending: true)
        ]
        let context = coreDataManager.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try frc.performFetch()
        } catch let error {
            print(error)
        }
        
        frc.delegate = self
        
        return frc
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .black
        return refreshControl
    }()
    var isReset = false
    
    
    // MARK: Private Properties
    
    private let coreDataManager = CoreDataManager.shared
    private let networkManager = NetworkManager.shared
    

    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
    }
    
    
    // MARK: Private
    
    @objc private func handleRefresh() {
        setupUI(isLoading: true, isReset: isReset)
        
        networkManager.downloadCourses(completion: { [weak self] in
            guard let self = self else { return }
            self.tableView.refreshControl?.endRefreshing()
            self.setupUI(isLoading: false, isReset: self.isReset)
        }) {
            let alerController = UIAlertController(title: "Невозможно получить данные", message: "Проверьте соединение с Интернетом", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alerController.addAction(cancel)
            
            self.tableView.refreshControl?.endRefreshing()
            self.setupUI(isLoading: false, isReset: self.isReset)
            self.present(alerController, animated: true, completion: nil)
        }
    }
    
    private func setupNavBar() {
        navigationItem.title = Strings.courses
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.reset, style: .plain, target: self, action: #selector(handleReset))
    }
    
    @objc private func handleReset() {
        isReset = true
        setupUI(isLoading: true, isReset: isReset)
        
        coreDataManager.deleteCourses { [weak self] in
            guard let self = self else { return }
            self.isReset = false
            self.setupUI(isLoading: false, isReset: self.isReset)
        }
    }
    
    private func setupTableView() {
        activityIndicator.isHidden = true
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Strings.cellID)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func setupUI(isLoading: Bool, isReset: Bool) {
        navigationItem.leftBarButtonItem?.isEnabled = !isLoading
        if isReset {
            activityIndicator.isHidden = !isReset
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = !isReset
        }
    }
    
    
    // MARK: Fetched Results Controller Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
