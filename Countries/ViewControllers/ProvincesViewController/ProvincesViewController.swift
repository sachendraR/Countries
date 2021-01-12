//
//  ProvincesViewController.swift
//  Countries
//
//  Created by Sachendra Singh on 11/01/21.
//

import UIKit

class ProvincesViewController: BaseViewController {

    var presenter: ProvincesPresenter?
    typealias ViewModelType = ProvincesViewModel
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var indicatorView:UIView?
    let pullDownToRefresh:UIRefreshControl = UIRefreshControl()
    
    private var dataSource:UICollectionViewDiffableDataSource<Int, Province>!
    let mapController = MapViewController()
    
    private var country:Country!
    convenience init(forCountry country:Country,
                     presenter:ProvincesPresenter) {
        self.init(nibName:"ProvincesViewController", bundle: .main)
        self.country = country
        
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.country.Name
        
        setupMapView()
        setupCollectionView()
        
        pullDownToRefresh.addTarget(self,
                                    action: #selector(refresh(_:)),
                                    for: .valueChanged)
        collectionView.refreshControl = pullDownToRefresh
        
        self.presenter?.setupPresenter(withData: self.country)
        self.presenter?.fetchData()
    }

    @objc func refresh(_ sender:UIRefreshControl)
    {
        if sender.isRefreshing
        {            
            self.presenter?.fetchData()
        }
    }
    
    func setupMapView()
    {
        self.addChild(mapController)
        mapContainerView.addSubview(mapController.view)
        
        mapController.view.translatesAutoresizingMaskIntoConstraints = false
        
        mapController.view.leadingAnchor.constraint(equalTo: self.mapContainerView.leadingAnchor).isActive = true
        mapController.view.trailingAnchor.constraint(equalTo: self.mapContainerView.trailingAnchor).isActive = true
        mapController.view.topAnchor.constraint(equalTo: self.mapContainerView.topAnchor).isActive = true
        mapController.view.bottomAnchor.constraint(equalTo: self.mapContainerView.bottomAnchor).isActive = true
        
        DispatchQueue.main.async {
            self.mapController.country = self.country
        }
    }
    
    func setupCollectionView()
    {
        collectionView.register(UINib(nibName: "ProvinceCollectionViewCell", bundle: .main),
                                forCellWithReuseIdentifier: ProvinceCollectionViewCell.identifier)
        
        dataSource = UICollectionViewDiffableDataSource<Int, Province>(collectionView: collectionView, cellProvider: { (cv, indexPath, item) -> UICollectionViewCell? in
            
            let cell = cv.dequeueReusableCell(withReuseIdentifier: ProvinceCollectionViewCell.identifier, for: indexPath) as? ProvinceCollectionViewCell
            
            cell?.update(withObject: item)
            
            return cell
        })
        
        collectionView.collectionViewLayout = generateLayout()
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

extension ProvincesViewController : View
{
    
    func startedFetchingData() {
        if !pullDownToRefresh.isRefreshing
        {
            self.indicatorView = self.view.showLoadingIndicator()
        }
    }
    
    func updateUI(withViewModel viewModel: ProvincesViewModel) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Province>()
        snapshot.appendSections([0])
        
        let provices = viewModel.provinces
        snapshot.appendItems(provices, toSection: 0)
        
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

extension ProvincesViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let province = self.dataSource.snapshot().itemIdentifiers[indexPath.item]
        
        self.mapController.province = province
    }
}
