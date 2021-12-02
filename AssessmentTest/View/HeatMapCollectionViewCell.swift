//
//  HeatMapCollectionViewCell.swift
//  AssessmentTest
//
//  Created by Jigar Vaishnav on 30/11/21.
//

import UIKit

class HeatMapCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewForAlpha: UIView!
    @IBOutlet weak var viewForBackground: UIView!
    @IBOutlet weak var imageViewForPrice: UIImageView!
    @IBOutlet weak var labelForPriceChange: UILabel!
    @IBOutlet weak var labelForSymbol: UILabel!
    
    func loadCell(data : HeatMap?) {
        labelForSymbol.text = data?.symbol ?? ""
        let perchange = (Double(data?.priceChangePercent ?? "0") ?? 0.0)
        let percentage =  (perchange) * 100
        labelForPriceChange.text = String(percentage) + "%"
        self.viewForAlpha.alpha = data?.alpha ?? 0.0
        if data?.category == "s" {
            viewForBackground.backgroundColor = UIColor(hexString: "#ff0000")
        } else if data?.category == "l"  {
            viewForBackground.backgroundColor = UIColor(hexString: "#00ff00")
        } else if data?.category == "sc" {
            viewForBackground.backgroundColor = UIColor(hexString: "#ffff00")
        } else if data?.category == "lu" {
            viewForBackground.backgroundColor = UIColor(hexString: "#00d0f9")
        }
        else{
            print("Invalid Category")
        }
        
    }
}
