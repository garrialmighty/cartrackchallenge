//
//  CartrackChallengeTests.swift
//  CartrackChallengeTests
//
//  Created by Garri Adrian Nablo on 5/20/21.
//

import XCTest
@testable import CartrackChallenge

class LoginViewModelTests: XCTestCase {
    
    private final class MockDelegate: LoginViewModelDelegate {
        var didLogin = false
        var didEncounterError = false
        
        func viewModel(_ viewModel: LoginViewModel, didLogin isAuthenticated: Bool) {
            didLogin = isAuthenticated
        }
        
        func viewModel(_ viewModel: LoginViewModel, didEncounterError error: Error) {
            didEncounterError = true
        }
    }
    
    private final class MockAuthenticator: Authenticator {
        func authenticate(username: String, password: String) throws -> Bool {
            return true
        }
    }
    
    private var viewModel = LoginViewModel(authenticator: MockAuthenticator())
    private var mockDelegate = MockDelegate()

    override func setUpWithError() throws {
        viewModel = LoginViewModel(authenticator: MockAuthenticator())
        mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.setValue(false, forKey: hasLoggedInKey)
    }
    
    func testFieldValidation() {
        XCTAssertFalse(viewModel.hasValidFields)
        
        viewModel.username = "mockUsername"
        viewModel.password = "mockPassword"
        XCTAssertTrue(viewModel.hasValidFields)
    }
    
    func testRememberMe() {
        viewModel.authenticate()
        
        // do not remember
        let defaults = UserDefaults.standard
        XCTAssertFalse(defaults.bool(forKey: hasLoggedInKey))
        
        // remember
        viewModel.willRemember = true
        viewModel.authenticate()
        XCTAssertTrue(defaults.bool(forKey: hasLoggedInKey))
    }
    
    func testDelegateDidLogin() {
        viewModel.authenticate()
        XCTAssertTrue(mockDelegate.didLogin)
        
        // setup unhappy path
        final class MockFalseAuthenticator: Authenticator {
            func authenticate(username: String, password: String) throws -> Bool {
                throw AuthenticationError.invalidCredentials
            }
        }
        viewModel = LoginViewModel(authenticator: MockFalseAuthenticator())
        mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate
        viewModel.authenticate()
        XCTAssertFalse(mockDelegate.didLogin)
    }
    
    func testDelegateDidEncounterError() {
        final class MockErrorAuthenticator: Authenticator {
            func authenticate(username: String, password: String) throws -> Bool {
                throw NSError()
            }
        }
        
        viewModel = LoginViewModel(authenticator: MockErrorAuthenticator())
        mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate
        viewModel.authenticate()
        XCTAssertTrue(mockDelegate.didEncounterError)
    }
}
