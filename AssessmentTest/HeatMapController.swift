//
//  ViewController.swift
//  AssessmentTest
//
//  Created by Jigar Vaishnav on 30/11/21.
//

import UIKit

class HeatMapController: UIViewController {
    
    @IBOutlet weak var collectionViewForHeatMap: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var dataCtlr : HeatMapDataController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if dataCtlr == nil {
            self.dataCtlr = HeatMapDataController()
        }
        searchBar.delegate = self
        self.collectionViewForHeatMap.delegate = self
        self.collectionViewForHeatMap.dataSource = self
        
        callHeatMapService()
    }
    
    @IBAction func actionForAllFilter(_ sender: Any) {
        self.dataCtlr?.activeFilter = .all
        DispatchQueue.main.async {
            self.collectionViewForHeatMap.reloadData()
        }
    }
    
    @IBAction func actionForLFilter(_ sender: Any) {
        self.dataCtlr?.activeFilter = .l
        
        
        DispatchQueue.main.async {
            self.collectionViewForHeatMap.reloadData()
        }
    }
    
    @IBAction func actionForScFilter(_ sender: Any) {
        self.dataCtlr?.activeFilter = .sc
        
        DispatchQueue.main.async {
            self.collectionViewForHeatMap.reloadData()
        }
    }
    
    @IBAction func actionForSFilter(_ sender: Any) {
        self.dataCtlr?.activeFilter = .s
        
        DispatchQueue.main.async {
            self.collectionViewForHeatMap.reloadData()
        }
    }
    
    @IBAction func actionFoLuFilter(_ sender: Any) {
        self.dataCtlr?.activeFilter = .lu
        
        DispatchQueue.main.async {
            self.collectionViewForHeatMap.reloadData()
        }
    }
    
    //api call for heatmap
    func callHeatMapService(){
        
        // TODO Reachability  for check for internet isConnectedToNetwork
        
        self.dataCtlr?.httpGETCall(success: {
            
            DispatchQueue.main.async {
                self.collectionViewForHeatMap.reloadData()
            }
        }, failure: { error in
            
        })
    }
}


// collectionView
extension HeatMapController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCtlr?.getFilteredStocks()?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "heatMapCell", for: indexPath) as? HeatMapCollectionViewCell
        cell?.loadCell(data: dataCtlr?.getFilteredStocks()?[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

// searchDelegate
extension HeatMapController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchText = searchBar.text ?? ""
        if searchText.isEmpty {
            self.dataCtlr?.activeFilter = .all
        } else {
            self.dataCtlr?.searchTextFromSearchBar = searchText
            self.dataCtlr?.activeFilter = .searchText
        }
        
        DispatchQueue.main.async {
            self.collectionViewForHeatMap.reloadData()
        }
    }
}

// not create new file for extension for sake of time I put in same class
extension UIView {
    
    // Provides functionality in Inspector to set corner radius of a view
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
