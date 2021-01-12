//
//  SingleTitleAndThumbCell.swift
//  Countries
//
//  Created by Sachendra Singh on 11/01/21.
//

import UIKit

protocol CollectionViewCell {
    static var identifier:String! { get }
    
    associatedtype ObjectType : Hashable
    
    func update(withObject object:ObjectType)
}

class CountryCollectionViewCell: UICollectionViewCell,CollectionViewCell {

    static var identifier: String! = "SingleTitleAndThumbCell"
    
    typealias ObjectType = Country
    
    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var lblCaption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(withObject object: Country) {
        
        lblCaption.text = object.Name
        
        // Before setting new image, clearing so that while the new image is being fetched wrong image is not shown due to recycling of cell
        ivThumb.image = nil
        ImageCacheManager.shared.cache(forCountry: object) { [weak self](image) in
            DispatchQueue.main.async {
                self?.ivThumb.image = ImageCacheManager.shared.image(forCountry: object)
            }
        }
    }
    
}

