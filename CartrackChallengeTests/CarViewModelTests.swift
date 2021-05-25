//
//  CarViewModelTests.swift
//  CartrackChallengeTests
//
//  Created by Garri Adrian Nablo on 5/26/21.
//

import XCTest
@testable import CartrackChallenge

class CarViewModelTests: XCTestCase {
    
    private final class MockListener {
        var didLogout = false
        
        init() {
            NotificationCenter.default.addObserver(self, selector: #selector(logout), name: .loggedOut, object: nil)
        }
        
        @objc private func logout() {
            didLogout = true
        }
    }

    private var viewModel = CarViewModel()
    private var listener = MockListener()
    
    override func setUpWithError() throws {
        viewModel = CarViewModel()
        listener = MockListener()
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.setValue(true, forKey: hasLoggedInKey)
    }
    
    func testLogout() {
        viewModel.logout()
        XCTAssertFalse(UserDefaults.standard.bool(forKey: hasLoggedInKey))
        XCTAssertTrue(listener.didLogout)
    }
}
