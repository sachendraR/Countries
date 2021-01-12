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
        // Keeping thumb empty for now
        ivThumb.image = nil
        
        lblCaption.text = object.Name
    }
    
}

