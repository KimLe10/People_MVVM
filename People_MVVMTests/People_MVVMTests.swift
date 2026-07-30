//
//  People_MVVMTests.swift
//  People_MVVMTests
//
//  Created by Kim Le on 3/24/26.
//

import XCTest
import Combine
@testable import People_MVVM


final class People_MVVMTests: XCTestCase {

    var viewModel: PeopleViewModel!
    var fakeNetworkManager: FakeNetworkManager!
    
    override func setUpWithError() throws {
        fakeNetworkManager = FakeNetworkManager()
        viewModel = PeopleViewModel(service: fakeNetworkManager)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        fakeNetworkManager = nil
        
        try super.tearDownWithError()
    }
    
    @MainActor
    func testFetchPeopleList_WhenExpectingCorrectResults() async throws {
        fakeNetworkManager.testPath = "PeopleTest"
        await viewModel.getPeople()
    
        XCTAssertNotNil(viewModel)
        
        if case .loaded(let peopleList) = viewModel.state {
            XCTAssertFalse(peopleList.isEmpty, "The JSON loaded, but the list is empty. Check your JSON file content.")
            XCTAssertEqual(peopleList.count, 3)
            let person = peopleList[0]
            XCTAssertEqual(person.firstName, "Maggie")
            XCTAssertEqual(person.lastName, "Brekke")
            XCTAssertEqual(person.jobTitle, "Future Functionality Strategist")
        }else {
            XCTFail("Expected state to be .loaded, but it was \(viewModel.state)")
        }
        switch viewModel.state {
            case .loaded(let peopleList):
                XCTAssertFalse(peopleList.isEmpty)
                let person = peopleList[0]
                XCTAssertEqual(person.firstName, "Maggie")
            case .error(let error):
                XCTFail("Expected success but got error: \(error)")
            case .loading:
                XCTFail("Task finished but state is still \(viewModel.state)")
            }
    }
    
    @MainActor
    func testFetchPeopleList_WhenExpectingEmptyResults() async throws {
        fakeNetworkManager.testPath = "PeopleTestEmpty"
        await viewModel.getPeople()

        XCTAssertNotNil(viewModel)

        if case .loaded(let people) = viewModel.state {
            XCTAssertEqual(people.count, 0)
        } else {
            XCTFail("Expected .loaded([]) for a well-formed but empty response, got \(viewModel.state)")
        }
    }

    @MainActor
    func testFetchPeopleList_WhenExpectingError() async throws {
        fakeNetworkManager.testPath = "ThisFixtureDoesNotExist"
        await viewModel.getPeople()

        XCTAssertNotNil(viewModel)

        if case .error(let message) = viewModel.state {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected .error for a missing/unreadable fixture, got \(viewModel.state)")
        }
    }

}
