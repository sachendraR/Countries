//
//  CountriesViewController.swift
//  Countries
//
//  Created by Sachendra Singh on 11/01/21.
//

import UIKit

class CountriesViewController: BaseViewController {

    var presenter: CountriesPresenter?
    typealias ViewModelType = CountriesViewModel
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource:UICollectionViewDiffableDataSource<Int, Country>!
    
    var indicatorView:UIView?
    let pullDownToRefresh:UIRefreshControl = UIRefreshControl()
    
    convenience init(withPresenter presenter:CountriesPresenter)
    {
        self.init(nibName:"CountriesViewController", bundle: .main)
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
        self.title = "Countries"
        
        setupCollectionView()
        
        pullDownToRefresh.addTarget(self,
                                    action: #selector(refresh(_:)),
                                    for: .valueChanged)
        collectionView.refreshControl = pullDownToRefresh
        
        presenter?.setupPresenter(withData: nil)
        presenter?.fetchData()
    }
    
    @objc func refresh(_ sender:UIRefreshControl)
    {
        if sender.isRefreshing
        {
            presenter?.fetchData()
        }
    }
    
    func setupCollectionView()
    {
        collectionView.register(UINib(nibName: "CountryCollectionViewCell",
                                      bundle: .main),
                               forCellWithReuseIdentifier: CountryCollectionViewCell.identifier)
        
        dataSource = UICollectionViewDiffableDataSource<Int, Country>(collectionView: collectionView, cellProvider: { (cv, indexPath, item) -> UICollectionViewCell? in
            
            let cell = cv.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.identifier,
                                              for: indexPath) as? CountryCollectionViewCell
            
            cell?.update(withObject: item)
            
            return cell
        })
        
        collectionView.collectionViewLayout = self.generateLayout()
        collectionView.delegate = self
    }
    
    func generateLayout() -> UICollectionViewLayout
    {
        return UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return self.generateSectionLayout()
        }
    }
    
    func generateSectionLayout() -> NSCollectionLayoutSection
    {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(50))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }

}

extension CountriesViewController : View
{
    func startedFetchingData() {
        if !pullDownToRefresh.isRefreshing
        {
            self.indicatorView = self.view.showLoadingIndicator()
        }
    }
    
    func updateUI(withViewModel viewModel: CountriesViewModel) {
            
        let countries = viewModel.countries
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Country>()
        snapshot.appendSections([0])
        
        snapshot.appendItems(countries, toSection: 0)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
        
        self.pullDownToRefresh.endRefreshing()
        self.indicatorView?.removeFromSuperview()
    }
    
    func showError(error: Error) {
        self.pullDownToRefresh.endRefreshing()
        self.indicatorView?.removeFromSuperview()
        
        super.showError(error) {
            self.presenter?.fetchData()
        }
    }
}

extension CountriesViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let country = self.dataSource.snapshot().itemIdentifiers[indexPath.item]
        
        let controller = ProvincesViewController(forCountry: country,
                                                 presenter: ProvincesPresenter())
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}
