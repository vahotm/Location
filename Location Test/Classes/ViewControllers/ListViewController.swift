//
//  ListViewController.swift
//  Location Test
//
//  Created by Ivan Samalazau on 14.2.18.
//  Copyright © 2018 Ivan Samalazau. All rights reserved.
//

import UIKit
import MapKit


extension ListViewController {
    
    class Data {
        var points = [Point]()
        var coordinate = CLLocationCoordinate2DMake(0.0, 0.0)
        private(set) var distances = [Point: Double]()
        
        func calculateDistances() {
            let user = MKMapPointForCoordinate(coordinate)
            for point in points {
                let mapPoint = MKMapPointForCoordinate(CLLocationCoordinate2DMake(point.lat, point.lng))
                let distance = MKMetersBetweenMapPoints(user, mapPoint)
                distances[point] = distance
            }
        }
        
        func sortPoints() {
            points = points.sorted(by: {
                let distance1 = distances[$0] ?? 0.0
                let distance2 = distances[$1] ?? 0.0
                return distance2 > distance1
            })
        }
    }
}

class ListViewController: UITableViewController {
    
    private enum Const {
        static let cellIdentifier = "Point"
    }
    
    let data = Data()
    var onSave: ((Point) -> Void)?
    var onDelete: ((Point) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Points"
        data.calculateDistances()
        data.sortPoints()
    }
}

// MARK: - UITableViewDataSource

extension ListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.points.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let point = data.points[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellIdentifier, for: indexPath)
        cell.textLabel?.text = point.name
        if let distance = data.distances[point] {
            cell.detailTextLabel?.text = String(format: "%.1f km", distance / 1000)
        } else {
            cell.detailTextLabel?.text = "- km"
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailsViewController = storyboard
            .instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else {
                return
        }
        
        detailsViewController.point = data.points[indexPath.row]
        detailsViewController.onSave = { [weak self] point in
            guard let `self` = self else { return }
            DataManager.updatePoint(point,
                                    withName: detailsViewController.name,
                                    userDescription: detailsViewController.userDescription)
            self.tableView.reloadData()
            self.onSave?(point)
        }
        detailsViewController.onDelete = { [weak self] point in
            guard let `self` = self else { return }
            let removedPoint = self.data.points.remove(at: indexPath.row)
            self.tableView.reloadData()
            DataManager.deletePoint(point)
            self.onDelete?(removedPoint)
        }
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
