//
//  HeatMapDataController.swift
//  AssessmentTest
//
//  Created by Jigar Vaishnav on 30/11/21.
//

import UIKit

enum FilterForStock : String{
    case s
    case l
    case sc
    case lu
    case all
    case searchText
}

class HeatMapDataController: NSObject {
    
    var activeFilter : FilterForStock = .all
    var arrayForStocks : [HeatMap]? = []
    var searchTextFromSearchBar : String = ""
    func getFilteredStocks() -> [HeatMap]? {
        
        if activeFilter == .all {
            return self.arrayForStocks
        } else if !searchTextFromSearchBar.isEmpty && activeFilter == .searchText {
            return arrayForStocks?.filter({($0.symbol ?? "").lowercased().contains(searchTextFromSearchBar.lowercased())})
        }
        else {
            return self.arrayForStocks?.filter{$0.category ?? "" == activeFilter.rawValue}
        }
    }
    
    //API for list
    func httpGETCall(success:@escaping ()->Void , failure:@escaping (_ error: NSError) ->())
    {
        
        let urlStr = "https://qapptemporary.s3.ap-south-1.amazonaws.com/test/synopsis.json"
        let url = URLComponents(string: urlStr)
        var request = URLRequest(url: (url?.url!)!)
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = true
        
        request.timeoutInterval = 5.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if ((error) == nil), let data = data, let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    
                    let jsonDataFromServer : [String : Any]? = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                    
                    do {
                        // 1
                        
                        let allKeys = Array(jsonDataFromServer!.keys)
                        
                        for keyInDict in allKeys {
                            
                            //key => lu,u
                            
                            let allStocksInCurrentCategoryString = jsonDataFromServer?[keyInDict] as? String ?? ""
                            
                            var arrayForAllStocks = allStocksInCurrentCategoryString.split(separator: ";")
                            
                            arrayForAllStocks = arrayForAllStocks.sortedByPriceChange { a, b in
                                let stockDetailsInArrayA = String(a).split(separator: ",")
                                let stockDetailsInArrayB = String(b).split(separator: ",")
                                
                                return Double(String(stockDetailsInArrayA[3]))! > Double(String(stockDetailsInArrayB[3]))!
                            }
                            
                            // for color change Alpha
                            var alpha = 0.0
                            let alphaChange = 0.75/Double(arrayForAllStocks.count)
                            for stock in arrayForAllStocks {
                                
                                //stock => MINDTREE,2705.0,3074800.0,0.0809,0.6092
                                
                                let stockDetailsInArray = String(stock).split(separator: ",")
                                
                                let symbol = String(stockDetailsInArray[0])
                                let price = String(stockDetailsInArray[1])
                                let openInterest = String(stockDetailsInArray[2])
                                let priceChangePercent = String(stockDetailsInArray[3])
                                let openInterestChange = String(stockDetailsInArray[4])
                                
                                let obj = HeatMap(symbol: symbol,price: price,priceChangePercent:priceChangePercent,openInterestChange: openInterestChange, openInterest: openInterest,category: keyInDict, alpha: alpha)
                                
                                self.arrayForStocks?.append(obj)
                                //print(alpha)
                                // print(priceChangePercent)
                                alpha = alpha + alphaChange
                            }
                        }
                        
                        // sort the array by desc
                        self.arrayForStocks = self.arrayForStocks?.sorted(by: {
                            Double($0.priceChangePercent ?? "0") ?? 0.0 > Double($1.priceChangePercent ?? "0") ?? 0.0
                            
                        })
                        
                        success()
                    }
                }
            }
            else{
                let userInfo: [AnyHashable : Any] =
                [
                    NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "Unable to reach server", comment: "") ,
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Unable to reach server", comment: "")
                ]
                let err = NSError(domain: "HttpResponseErrorDomain", code: 500, userInfo: userInfo as? [String : Any])
                
                failure(err);
            }
            
        }.resume()
    }
}


extension Array where Element: Equatable {
    func sortedByPriceChange(_ by: (Element,Element) -> Bool) -> [Element] {
        return self.sorted(by: by)
    }
}

