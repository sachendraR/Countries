//
//  CBWebAPITransporter.swift
//  Countries
//
//  Created by Sachendra Singh on 24/12/19.
//  Copyright © 2019 Sachendra Singh. All rights reserved.
//
import Foundation

public class NSURLBasedWebAPITransporter: WebAPITransportor {
            
    internal static func transporter() -> NSURLBasedWebAPITransporter
    {
        return NSURLBasedWebAPITransporter()
    }
    
    public var interactor: WebAPIInteractor?
    
    public var onResponse: ((Data?) -> ())?
    
    public var onError: ((Error?) -> ())?
    
    private init()
    {
        
    }
    
    public func makeAPICall() {
        if let request = self.prepareRequest()
        {
            let connection = ConnectionManager.shared.urlSession
            connection.dataTask(with: request) { [weak self] (data, response, error) in
                if let error = error
                {
                    self?.onError?(error)
                    return
                }
                      
                let responseCode = (response as? HTTPURLResponse)?.statusCode ?? 200
                if responseCode == 200
                {
                    self?.onResponse?(data)
                }
                else
                {
                                                            
                    let error = ResponseError()
                    error.errorCode = (response as? HTTPURLResponse)?.statusCode
                    error.errorData = data
                    
                    self?.onError?(error)
                    
                    var responseString = ""
                    if let respData = data
                    {
                        responseString = String(data: respData, encoding: .utf8) ?? ""
                    }

                }
                
                self?.interactor?.transporter = nil
                
            }.resume()
        }
    }
    
    
    // MARK : Helper methods
    func prepareRequest() -> URLRequest?
    {
        var request:URLRequest?
        let url = interactor?.requestEndPoint() ?? ""
        if let reqUrl = URL(string: url)
        {
            request = URLRequest(url: reqUrl)
            if let method = interactor?.requestType()
            {
                request?.httpMethod = method
            }
            
            if let strBody = interactor?.body()
            {
                request?.httpBody = strBody.data(using: .utf8)
            }
            
            if let headers = interactor?.headers()
            {
                for (key, value) in headers
                {
                    request?.setValue(value,
                                      forHTTPHeaderField: key)
                }
            }
        }
        
        return request
    }

}

public class ConnectionManager
{
    private init() {
        let sessionConfig = URLSessionConfiguration.default
        
        sessionConfig.timeoutIntervalForRequest = 60.0
        sessionConfig.timeoutIntervalForResource = 60.0
        
        urlSession = URLSession(configuration: sessionConfig)
    }
    
    public static let shared = ConnectionManager()
    
    public var urlSession:URLSession
}

public class ResponseError : Error
{
 
    public static let INCONSISTENT_RESPONSE = 81
    public static let INCONSISTENT_RESPONSE_DESC = "Received response is not consistent, please contact administrator"
    
    public static func inconsistentResponseError() -> ResponseError
    {
        let error = ResponseError(code: INCONSISTENT_RESPONSE,
                                  desc: INCONSISTENT_RESPONSE_DESC,
                                  data: nil)
        
        return error
    }
    
    public var errorCode:Int?
    public var errorDescription:String?
    public var errorData:Data?
    
    public init() {}
    
    public init(code:Int, desc:String?, data:Data?) {
        self.errorCode = code
        self.errorDescription = desc
        self.errorData = data
    }

}
