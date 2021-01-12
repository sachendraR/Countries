//
//  CountriesControllerTests.swift
//  CountriesTests
//
//  Created by Sachendra Singh on 12/01/21.
//

import XCTest
@testable import Countries

class ContriesControllerTests : XCTestCase
{
    func testControllerShowsCorrectNumberOfCells()
    {
        let presenter = CountriesPresenter()
        let sut = CountriesViewController(withPresenter: presenter)
        _ = sut.view
        
        let predicate = NSPredicate(format: "self.viewModel != nil")
        let exp = expectation(for: predicate,
                              evaluatedWith: presenter,
                              handler: nil)
        
        _ = XCTWaiter.wait(for: [exp],
                                    timeout: 3)
        
        XCTAssertTrue(presenter.viewModel.countries.count == sut.collectionView.numberOfItems(inSection: 0))
    }
}
