//
//  WebAPIInteractor.swift
//  Countries
//
//  Created by Sachendra Singh on 24/12/19.
//  Copyright © 2019 Sachendra Singh. All rights reserved.
//

import Foundation

public protocol WebAPIInteractor
{
    
    var transporter:WebAPITransportor? { get set }
    
    func requestEndPoint() -> String?
    func headers() -> [String: String]?
    func requestType() -> String?
    func body() -> String?
    func parseData(fromData data:Data) -> Any?
    
    func execute(withTransporter transporter:inout WebAPITransportor,
                 onSuccess:((_ response:Any?)->())?,
                 onError:((_ error:Error?)->())?)
}
