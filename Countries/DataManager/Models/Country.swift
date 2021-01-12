//
//  Country.swift
//  Countries
//
//  Created by Sachendra Singh on 11/01/21.
//

import Foundation

public class Country : Codable, Hashable
{
    public static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.ID == rhs.ID        
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ID)
    }
    
    var ID:Int!
    var Name:String!
    var Code:String!
    var PhoneCode:String?
}
