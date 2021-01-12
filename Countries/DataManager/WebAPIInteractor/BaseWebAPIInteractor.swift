//
//  BaseWebAPIInteractor.swift
//  Countries
//
//  Created by Sachendra Singh on 26/12/19.
//  Copyright © 2019 Sachendra Singh. All rights reserved.
//

import Foundation

/**
 Class to supply required details to transporter so that transporter can go ahead and communicate based on supplied details
 
 Also, having specific interactor gives granular control over each communication
 */
public class BaseWebAPIInteractor: WebAPIInteractor {
    
    public typealias SuccessCallback = ((Any?) -> ())
    public typealias ErrorCallback = ((Error?) -> ())
    
    public var transporter: WebAPITransportor?
    
    public func requestEndPoint() -> String? {
        return nil
    }
    
    public func headers() -> [String : String]? {
        return nil
    }
    
    public func requestType() -> String? {
        return nil
    }
    
    public func body() -> String? {
        return nil
    }
    
    public func parseData(fromData data: Data) -> Any? {
        return nil
    }
        
    public func execute(withTransporter transporter: inout WebAPITransportor,
                        onSuccess: SuccessCallback?,
                        onError: ErrorCallback?) {
        transporter.interactor = self
        transporter.onResponse = { data in
            if let respData = data,
                let response = self.parseData(fromData: respData)
            {
                onSuccess?(response)
            }
            else
            {
                let responseError = ResponseError.inconsistentResponseError()
                onError?(responseError)                                    
            }
                        
        }
        transporter.onError = onError
        
        self.transporter = transporter
        
        transporter.makeAPICall()
    }
    
}
