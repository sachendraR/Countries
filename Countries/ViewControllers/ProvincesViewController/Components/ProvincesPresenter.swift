//
//  ProvincesPresenter.swift
//  Countries
//
//  Created by Sachendra Singh on 12/01/21.
//

import Foundation

class ProvincesPresenter : Presenter
{
    var viewModel: ProvincesViewModel!
    weak var view: ProvincesViewController?
    
    private let dataQueue = OperationQueue()
    
    var country:Country?
    
    func setupPresenter(withData data: Any?) {
        country = data as? Country
        
        dataQueue.maxConcurrentOperationCount = 1
    }
    
    func fetchData() {
        
        // If there is already an operation is in progress to fetch data, subsequent requests are ignored.
        if dataQueue.operations.count == 0
        {
            dataQueue.addOperation(ProvincesFetcher(withPresenter: self))
        }
    }
    

}

/**
 Operation implementation to take case of fetching data from API and propogating events to view
 
 Due to very specific usecase, events are directly propogated from opertaion to View, which is not to be followed in general
 */
class ProvincesFetcher : AsyncOperation
{
    weak var presenter:ProvincesPresenter?
    init(withPresenter presenter:ProvincesPresenter) {
        self.presenter = presenter
    }
    
    override func start() {
        if self.isCancelled {
            self.isFinished = true
            
            return
        }
        
        fetchData()
    }
    
    func fetchData()
    {
        guard let countryId = presenter?.country?.ID
        else { self.isFinished = true; return }
        
        DispatchQueue.main.async {
            self.presenter?.view?.startedFetchingData()
        }
        
        GetProvincesInteractor.getProvinces(forCountry: countryId) {
            
            self.isFinished = true
            self.isExecuting = false
            
            let provinces = $0 as? [Province]
            self.presenter?.viewModel = ProvincesViewModel()
            self.presenter?.viewModel.provinces = provinces ?? []
            
            if let viewModel = self.presenter?.viewModel
            {
                DispatchQueue.main.async {
                    self.presenter?.view?.updateUI(withViewModel: viewModel)
                }
            }
            
        } error: {
            
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
