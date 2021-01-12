//
//  View.swift
//  Countries
//
//  Created by Sachendra Singh on 12/01/21.
//

import Foundation

protocol View : class {
    
    // MARK : Defining associated types will help handling things at compile time
    associatedtype PresenterType = Presenter
    associatedtype ViewModelType = ViewModel
            
    var presenter:PresenterType? { get set }
 
    // MARK : General expected behavior from a view
    func startedFetchingData()
    func updateUI(withViewModel viewModel:ViewModelType)
    func showError(error:Error)
}
