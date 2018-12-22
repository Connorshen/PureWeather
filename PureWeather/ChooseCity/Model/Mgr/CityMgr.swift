//
//  CityMgr.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/25.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class CityMgr: BaseMgr {
    private var citys:[City]=[]
    static let shared=CityMgr()
    func getCitys() -> [City] {
        return citys
    }
    override init(){
        let path = Bundle.main.path(forResource:"citys", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do{
            let data = NSData(contentsOf: url)
            let json:String = NSString(data: data! as Data, encoding: String.Encoding.utf8.rawValue)! as String
            let country = Country.deserialize(from: json) ?? Country()
            for province in country.provinces!{
                for city in province.citys!{
                    citys.append(city)
                }
            }
        }
    }
}
extension String{ func transformToPinYin()->String{
    let mutableString = NSMutableString(string: self)
    CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
    CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
    let string = String(mutableString)
    return string.replacingOccurrences(of: " ", with: "")
    }
}



