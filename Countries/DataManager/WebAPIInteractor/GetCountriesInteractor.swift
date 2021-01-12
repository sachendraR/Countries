//
//  GetCountriesInteractor.swift
//  Countries
//
//  Created by Sachendra Singh on 11/01/21.
//

import Foundation

public class GetCountriesInteractor : BaseWebAPIInteractor
{
    
    static func getCountries( onSuccess:@escaping BaseWebAPIInteractor.SuccessCallback,
                              onError:@escaping BaseWebAPIInteractor.ErrorCallback )
    {
        var transporter = WebAPITransporterFactory.getTransporter()
                        
        let interactor = GetCountriesInteractor()
        
        interactor.execute(withTransporter: &transporter,
                           onSuccess: onSuccess,
                           onError: onError)
    }
    
    private let endPoint:String = {
        return "https://connect.mindbodyonline.com/rest/worldregions/country"
    }()
            
    public override func requestEndPoint() -> String? {
        return endPoint
    }
    
    public override func headers() -> [String : String]? {
        return ["Accept" : "application/json",
                "Content-Type" : "application/json"]
    }
    
    public override func requestType() -> String? {
        return "GET"
    }
    
    public override func body() -> String? {
        return nil
    }
        
    public override func parseData(fromData data: Data) -> Any? {
        let parsedData = try? JSONDecoder().decode([Country].self,
                                              from: data)
        return parsedData
    }
}
