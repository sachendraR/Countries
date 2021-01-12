//
//  GetProvincesInteractor.swift
//  Countries
//
//  Created by Sachendra Singh on 11/01/21.
//

import Foundation

class GetProvincesInteractor : BaseWebAPIInteractor
{
    static func getProvinces(forCountry countryId:Int,
                             succes:@escaping SuccessCallback,
                              error:@escaping ErrorCallback )
    {
        var transporter = WebAPITransporterFactory.getTransporter()
                        
        let interactor = GetProvincesInteractor(withCountryId: countryId)
        
        interactor.execute(withTransporter: &transporter,
                           onSuccess: succes,
                           onError: error)
    }
    
    private let endPoint:String = {
        return "https://connect.mindbodyonline.com/rest/worldregions/country/{ID}/province"
    }()
    
    private var countryId:Int
    init(withCountryId countryId:Int) {
        self.countryId = countryId
    }
            
    override func requestEndPoint() -> String? {
        return endPoint.replacingOccurrences(of: "{ID}",
                                             with: "\(self.countryId)")
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
        let parsedData = try? JSONDecoder().decode([Province].self,
                                              from: data)
        return parsedData
    }
}
