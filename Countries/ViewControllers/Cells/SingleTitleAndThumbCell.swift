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
    
    typealias ObjectType = <#T##Type###>
    
    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var lblCaption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
