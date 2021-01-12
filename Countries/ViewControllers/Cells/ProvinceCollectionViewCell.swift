//
//  ProvinceCollectionViewCell.swift
//  Countries
//
//  Created by Sachendra Singh on 11/01/21.
//

import UIKit

class ProvinceCollectionViewCell: UICollectionViewCell, CollectionViewCell {

    static var identifier: String! = "ProvinceCollectionViewCell"
    typealias ObjectType = Province
    
    @IBOutlet weak var lblCaption: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(withObject object: Province) {
        lblCaption.text = object.Name
    }
    
}
