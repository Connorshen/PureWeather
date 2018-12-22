//
//  Country.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/25.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import HandyJSON
class Country :HandyJSON{
    var provinces:[Province]?
    required init(){}}
class Province:HandyJSON{
    var provinceName:String?
    var citys:[City]?
    required init(){}
}
class City :HandyJSON{
    var citysName:String?
    required init(){}
}
