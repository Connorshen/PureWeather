//
//  CityItem.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/26.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class CityItem: BaseItem {
    @objc var cityName:String?
    @objc var pinyin:String?
    init(itemType: Int,city:City) {
        cityName=city.citysName
        pinyin=cityName!.transformToPinYin()
        super.init(itemType: itemType)
    }
}
