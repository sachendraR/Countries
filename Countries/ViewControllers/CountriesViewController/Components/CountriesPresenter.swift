//
//  CountriesPresenter.swift
//  Countries
//
//  Created by Sachendra Singh on 12/01/21.
//

import Foundation

class CountriesPresenter : NSObject, Presenter
{
    var viewModel: CountriesViewModel!
    weak var view: CountriesViewController?
    
    private let dataQueue = OperationQueue()
    
    func setupPresenter(withData data: Any? = nil) {
        dataQueue.maxConcurrentOperationCount = 1
    }
    
    func fetchData() {
                
        // If there is already an operation is in progress to fetch data, subsequent requests are ignored.
        if dataQueue.operations.count == 0
        {
            dataQueue.addOperation(CountriesFetcher(withPresenter: self))
        }

    }
    
}
/**
 Operation implementation to take case of fetching data from API and propogating events to view
 
 Due to very specific usecase, events are directly propogated from opertaion to View, which is not to be followed in general
 */
class CountriesFetcher: AsyncOperation
{
    /**
     Weak reference of presenter ensures that if presenter is released, events won't be propogated from here.
     */
    weak var presenter:CountriesPresenter?
    init(withPresenter presenter:CountriesPresenter) {
        self.presenter = presenter
    }
    
    override func start() {
        if self.isCancelled {
            self.isFinished = true
            
            return
        }
        
        fetchData()
    }
    
    func fetchData() {
                
        DispatchQueue.main.async {
            self.presenter?.view?.startedFetchingData()
        }
        
        GetCountriesInteractor.getCountries {
            
            self.isFinished = true
            self.isExecuting = false
            
            let countries = $0 as? [Country]
            self.presenter?.viewModel = CountriesViewModel()
            self.presenter?.viewModel.countries = countries ?? []
            
            if let viewModel = self.presenter?.viewModel
            {
                DispatchQueue.main.async {
                    self.presenter?.view?.updateUI(withViewModel: viewModel)
                }
            }
            
        } onError: {
            
            self.isFinished = true
            self.isExecuting = false
            
            if let err = $0
            {
                DispatchQueue.main.async {
                    self.presenter?.view?.showError(error: err)
                }
            }
        }

    }
}
