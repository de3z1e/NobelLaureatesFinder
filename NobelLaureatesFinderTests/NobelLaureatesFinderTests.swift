//
//  NobelLaureatesFinderTests.swift
//  NobelLaureatesFinderTests
//
//  Created by Dimitry Zadorozny on 7/27/21.
//

import XCTest
import Combine
import CoreLocation
import MapKit
@testable import NobelLaureatesFinder

class NobelLaureatesFinderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

    func testModelFetch() throws {
        let expectation = XCTestExpectation(description: "Fetch laureates data from S3")
        Model<Laureate>.fetch { result in
            XCTAssert(Thread.isMainThread, "Is not returned on main thread")
            switch result {
            case .success(let laureates):
                XCTAssert(laureates.count > 0, "No data was fetched")
            case .failure(let modelError):
                XCTAssert(false, "Model Error: \(modelError.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    private var laureatesSubscriber: AnyCancellable?
    private var isLoadingSubscriber: AnyCancellable?
    
    func testModelSort() throws {
        // Expected `id` results for given location and year
        let location = MKMapItem(placemark: MKPlacemark(coordinate: .init(latitude: 52.204266599999997, longitude: 0.1149085)))
        let year: Int32 = 1954
        let expectedResults: [UInt32] = [
            356, 369, 374, 36, 166, 211, 375, 382, 691, 321,
            331, 34, 37, 50, 56, 61, 694, 712, 192, 200
        ]
        
        let expectation = XCTestExpectation(description: "Model sort")
        let model = LaureatesViewModel.shared
        model.selectedLocation = location
        model.selectedYear = year
        laureatesSubscriber = model.$laureates.sink { laureates in
            if !laureates.isEmpty {
                let result = laureates[0..<(min(20, laureates.count))].map{ $0.id }
                XCTAssertEqual(result, expectedResults)
                expectation.fulfill()
            }
        }
        isLoadingSubscriber = model.$isLoading.sink { isLoading in
            if isLoading == false {
                model.sortLaureates()
            }
        }
        wait(for: [expectation], timeout: 10)
    }
}
