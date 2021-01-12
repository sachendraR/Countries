//
//  Error+Utils.swift
//  Countries
//
//  Created by Sachendra Singh on 12/01/21.
//

import Foundation

extension Error
{
    /**
     Method is responsible to take business decisions around error. e.g. if an error is retryable or not.
     As of now, all errors are considered to be retryable.
     Also, it gives flexibility to handle different future requirements around error at a central place
     */
    func handle(retryable:((String)->Void)?)
    {
        retryable?(localizedDescription)
    }
}
