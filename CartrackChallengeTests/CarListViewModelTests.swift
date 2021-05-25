//
//  CarListViewModelTests.swift
//  CartrackChallengeTests
//
//  Created by Garri Adrian Nablo on 5/26/21.
//

import XCTest
@testable import CartrackChallenge

class CarListViewModelTests: XCTestCase {
    
    private final class MockDelegate: CarListViewModelDelegate {
        var didFetchCars = false
        
        func carListViewModel(_ viewModel: CarListViewModel, didFetchCars cars: [Car]) {
            didFetchCars = true
        }
    }
    
    private final class MockLoader: CarLoader {
        var page = 0
        
        func fetchCars(page: Int, completion: @escaping (Result<[Car], NetworkError>) -> Void) {
            self.page = page
            completion(.success([Car()]))
        }
    }
    
    private var mockLoader = MockLoader()
    private var viewModel = CarListViewModel(loader: MockLoader())
    private var mockDelegate = MockDelegate()

    override func setUpWithError() throws {
        mockLoader = MockLoader()
        viewModel = CarListViewModel(loader: mockLoader)
        mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate
    }

    override func tearDownWithError() throws {
    }
    
    func testFetchingCars() {
        viewModel.fetchCars()
        XCTAssertTrue(mockDelegate.didFetchCars)
        XCTAssertEqual(viewModel.cars.count, 1, "View model did not store cars")
        
        viewModel.fetchCars()
        viewModel.fetchCars()
        XCTAssertEqual(mockLoader.page, 0, "View model incremented page")
    }
    
    func testFetchingMoreCars() {
        viewModel.fetchMoreCars()
        XCTAssertTrue(mockDelegate.didFetchCars)
        XCTAssertEqual(mockLoader.page, 1, "View model did not increment page")
        
        viewModel.fetchMoreCars()
        viewModel.fetchMoreCars()
        XCTAssertEqual(viewModel.cars.count, 3, "View model did not appended fetched cars")
    }
}
