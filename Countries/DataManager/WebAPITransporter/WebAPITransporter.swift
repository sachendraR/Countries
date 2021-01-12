//
//  WebAPITransporter.swift
//  Countries
//
//  Created by Sachendra Singh on 24/12/19.
//  Copyright © 2019 Sachendra Singh. All rights reserved.
//

import Foundation

public protocol WebAPITransporterDelegate
{
    func onResponseReceived(response:Data?)
    func onErrorReceived(error:Error)
}

/**
 Transporter is supposed to be agent to communicate with Web APIs. Any kind of library, URLSession etc can be wrapped inside it to keep client implementation unaffected
 */
public protocol WebAPITransportor
{
    var onResponse:((_ response:Data?)->())? { get set }
    var onError:((_ error:Error?)->())? { get set }
    
    var interactor:WebAPIInteractor?
    {
        get set
    }
    
    func makeAPICall()
}


/**
 Factory to provide active object of transporter, allowing centralized control over the kind of object to be supplied
 */
public class WebAPITransporterFactory
{
    private init(){}
    
    public static func getTransporter() -> WebAPITransportor
    {
        return NSURLBasedWebAPITransporter.transporter()
    }
}
