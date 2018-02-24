//
//  DataManager.swift
//  Location Test
//
//  Created by isamalazau on 13.2.18.
//  Copyright © 2018 Ivan Samalazau. All rights reserved.
//

import SwiftyJSON

final class DataManager {
    
    private init() { }
    
    class func setup() {
        RealmManager.setup()
    }
    
    class func getPoints(completion: @escaping ([Point]?, Error?) -> Void) {
        guard let url = URL(string:"http://bit.ly/test-locations") else { return }
        
        let task = self.task(for: url, completion: completion)
        task.resume()
    }
}

// MARK: - Points Accessors

extension DataManager {
    
    class func createPoint(_ point: Point) {
        RealmManager.create(point)
    }
    
    class func updatePoint(_ point: Point, withName name: String, userDescription: String) {
        RealmManager.update(point) {
            $0.name = name
            $0.userDescription = userDescription
        }
    }
    
    class func deletePoint(_ point: Point) {
        RealmManager.delete(point)
    }
    
    class func points() -> [Point] {
        return RealmManager.fetchObjects(ofType: Point.self)
    }

    class func points(_ type: PointType) -> [Point] {
        let predicate = "typeRaw == \(type.rawValue)"
        return RealmManager.fetchObjects(ofType: Point.self, predicate: predicate)
    }
}

// MARK: - Private

private extension DataManager {
    
    class func task(for url: URL, completion: @escaping ([Point]?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data, let json = try? JSON(data: data) else {
                completion(nil, error)
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            guard let updated = formatter.date(from: json["updated"].stringValue) else { return }
            
            if self.isOutdated(newDate: updated) {
                if let locations = json["locations"].arrayObject {
                    // Delete and update points
                    DispatchQueue.main.async {
                        let storedPoints: [Point] = self.points(.predefined)
                        RealmManager.rewrite(storedPoints, with: locations)
                        
                        completion(RealmManager.fetchObjects(ofType: Point.self), nil)
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(RealmManager.fetchObjects(ofType: Point.self), nil)
            }
        }
        return task
    }
    
    class func isOutdated(newDate: Date) -> Bool {
        if let date = UserDefaults.standard.object(forKey: "updated") as? Date {
            return date.compare(newDate) == .orderedAscending
        } else {
            UserDefaults.standard.set(newDate, forKey: "updated")
            return true
        }
    }
}
