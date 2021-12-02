//
//  HeatMap.swift
//  AssessmentTest
//
//  Created by Jigar Vaishnav on 30/11/21.
//

import UIKit

struct HeatMap: Codable, Equatable {
    let symbol: String?
    var price: String?
    var priceChangePercent: String?
    var openInterestChange: String?
    var openInterest: String?
    var category: String?
    var alpha: Double?
}
