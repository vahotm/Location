//
//  Location_TestTests.swift
//  Location TestTests
//
//  Created by Ivan Samalazau on 12.2.18.
//  Copyright © 2018 Ivan Samalazau. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Location_Test

class Location_TestTests: XCTestCase {

    // MARK: - Setup once

    override class func setUp() {
        // Called once before all tests are run
        super.setUp()
        RealmManager.testSetup()
    }

    override class func tearDown() {
        // Called once after all tests are run
        super.tearDown()
    }

    // MARK: - Setup for each case

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - Test cases

    func testCreateDefaultPoint() {
        let point = Point(
            name: "New Point",
            userDescription: "Test description",
            latitude: -62.75271,
            longitude: -86.20665
        )
        DataManager.createPoint(point)

        let pointFromDatabase = DataManager.points().last

        XCTAssertEqual(pointFromDatabase?.name, point.name)
        XCTAssertEqual(pointFromDatabase?.userDescription, point.userDescription)
        XCTAssertEqual(pointFromDatabase?.lat, point.lat)
        XCTAssertEqual(pointFromDatabase?.lng, point.lng)
        XCTAssertEqual(pointFromDatabase?.type, point.type)
        XCTAssertTrue(pointFromDatabase?.type == .predefined)
    }

    func testCreateUserPoint() {
        let point = Point(
            name: "New Point",
            userDescription: "Test description",
            latitude: -62.75271,
            longitude: -86.20665,
            type: .user
        )
        DataManager.createPoint(point)

        let pointFromDatabase = DataManager.points().last

        XCTAssertEqual(pointFromDatabase?.name, point.name)
        XCTAssertEqual(pointFromDatabase?.userDescription, point.userDescription)
        XCTAssertEqual(pointFromDatabase?.lat, point.lat)
        XCTAssertEqual(pointFromDatabase?.lng, point.lng)
        XCTAssertEqual(pointFromDatabase?.type, point.type)
    }

    func testReadPoints() {
        createDummyPoints(count: 3)
        let points = DataManager.points()

        XCTAssertTrue(points.count == 3)
        XCTAssertEqual(points[0].name, "Dummy point 0")
        XCTAssertEqual(points[1].name, "Dummy point 1")
        XCTAssertEqual(points[2].name, "Dummy point 2")
    }

    func testFilterPoints() {
        createDummyPoints(count: 2, type: .predefined)
        createDummyPoints(count: 3, type: .user)

        let predefinedPoints = DataManager.points(.predefined)
        let userPoints = DataManager.points(.user)

        XCTAssertTrue(predefinedPoints.count == 2)
        XCTAssertTrue(userPoints.count == 3)
    }

    func testUpdatePoint() {
        let point = Point(
            name: "New Point",
            userDescription: "Test description",
            latitude: -62.75271,
            longitude: -86.20665
        )
        DataManager.createPoint(point)

        let newName = "New Point updated"
        let newDescription = "Test description updated"
        DataManager.updatePoint(point, withName: newName, userDescription: newDescription)

        let pointFromDatabase = DataManager.points().last

        XCTAssertEqual(pointFromDatabase?.name, newName)
        XCTAssertEqual(pointFromDatabase?.userDescription, newDescription)
    }

    func testDeletePoint() {
        createDummyPoints(count: 3)

        let point = DataManager.points().filter{ $0.name == "Dummy point 1" }.last!
        DataManager.deletePoint(point)

        let points = DataManager.points()

        XCTAssertTrue(points.count == 2)
        XCTAssertEqual(points[0].name, "Dummy point 0")
        XCTAssertEqual(points[1].name, "Dummy point 2")
    }

    // MARK: - Helpers

    func createDummyPoints(count: Int, type: PointType = .predefined) {
        for i in 0..<count {
            let point = Point()
            point.name = "Dummy point \(i)"
            point.type = type
            DataManager.createPoint(point)
        }
    }
}
