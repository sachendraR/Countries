//
//  Province.swift
//  Countries
//
//  Created by Sachendra Singh on 11/01/21.
//

import Foundation

public class Province : Codable, Hashable
{
    public static func == (lhs: Province, rhs: Province) -> Bool {
        return lhs.ID == rhs.ID
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ID)
    }
    
    var ID:Int!
    var CountryCode:String!
    var Code:String!
    var Name:String!
}
