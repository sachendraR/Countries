//
//  Presenter.swift
//  Countries
//
//  Created by Sachendra Singh on 12/01/21.
//

import Foundation

protocol Presenter {
    // MARK : Defining associated types will help handling things at compile time
    associatedtype ViewModelType = ViewModel
    associatedtype ViewType = View
    
    var viewModel:ViewModelType! { get set }
    var view:ViewType? { get set }
        
    // MARK : General expected behavior from a presenter
    func setupPresenter(withData data:Any?)
    func fetchData()
    
}

