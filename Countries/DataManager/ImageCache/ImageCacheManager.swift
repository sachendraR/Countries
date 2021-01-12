//
//  ImageCacheManager.swift
//  Countries
//
//  Created by Sachendra Singh on 12/01/21.
//

import Foundation
import UIKit

class ImageCacheManager
{
    private let countryFlagsCache:NSCache = NSCache<NSString, UIImage>()
    
    private init() {
        countryFlagsCache.countLimit = 100
    }
        
    public static let shared = ImageCacheManager()
            
    func image(forCountry country:Country) -> UIImage?
    {
        if let code = country.Code as NSString?
        {
            return countryFlagsCache.object(forKey: code)
        }
        
        return nil
    }
    
    /**
     Method takes care of updating calling implementation in event of image read, it can either be through local cache or from remote source
     */
    func cache(forCountry country:Country, onCached:((UIImage)->Void)?)
    {
        if let code = country.Code as NSString?
        {
            if let image = countryFlagsCache.object(forKey: code)
            {
                onCached?(image)
                return
            }
            
            let urlString = "https://www.countryflags.io/{ID}/flat/64.png".replacingOccurrences(of: "{ID}", with: country.Code)
            if let url = URL(string: urlString)
            {
                URLSession.shared.dataTask(with: url) { (data, resp, error) in
                    if let imageData = data,
                       let image = UIImage(data: imageData) {
                        self.countryFlagsCache.setObject(image, forKey: code)
                        
                        onCached?(image)
                    }
                }.resume()
            }
        }
    }
}
