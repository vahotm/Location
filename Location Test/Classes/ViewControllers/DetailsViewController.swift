//
//  DetailsViewController.swift
//  Location Test
//
//  Created by isamalazau on 14.2.18.
//  Copyright © 2018 Ivan Samalazau. All rights reserved.
//

import UIKit


class DetailsViewController: UITableViewController {
    
    private enum Const {
        static let titleCellIdentifier = "Title"
        static let deleteCellIdentifier = "Delete"
        static let descriptionCellIdentifier = "Description"
    }
    
    var point: Point? {
        didSet {
            name = point?.name ?? ""
            userDescription = point?.userDescription ?? ""
        }
    }
    var name: String = ""
    var userDescription: String = ""
    
    var onSave: ((Point) -> Void)?
    var onDelete: ((Point) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Point"
        
        let saveButton = UIBarButtonItem(title: "Save", 
                                         style: .done,
                                         target: self,
                                         action: #selector(onSaveAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton
    }
}

// MARK: - UITableViewDataSource

extension DetailsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == IndexPath(row:0, section:0),
            let cell = tableView.dequeueReusableCell(withIdentifier: Const.titleCellIdentifier, for: indexPath) as? TitleCell {
            cell.setup(with: .init(title: name, isEnabled: point?.type == .user) { [weak self] text in
                self?.name = text
                })
            return cell
        } else if indexPath == IndexPath(row:0, section:1),
            let cell = tableView.dequeueReusableCell(withIdentifier: Const.descriptionCellIdentifier, for: indexPath) as? DescriptionCell {
            cell.setup(with: .init(description: userDescription) { [weak self] text in
                self?.userDescription = text
                })
            return cell
        } else if indexPath == IndexPath(row:0, section:2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Const.deleteCellIdentifier, for: indexPath)
            return cell
        }
        preconditionFailure("cell type cannot be determined")
    }
}

// MARK: - UITableViewDelegate

extension DetailsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == IndexPath(row: 0, section: 2) {
            onDeleteAction()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "User Description"
        default:
            return nil
        }
    }
}

// MARK: - Private

private extension DetailsViewController {
    
    // MARK: Actions
    
    @objc func onSaveAction(sender: UIBarButtonItem) {
        if let point = point {
            onSave?(point)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func onDeleteAction() {
        let alertController = UIAlertController(title: "Do you want to delete this point?", message: nil, preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] action in
            guard let `self` = self else { return }
            self.delete()
        }
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func delete() {
        if let point = point {
            onDelete?(point)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
