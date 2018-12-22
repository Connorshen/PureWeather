//
//  HourlyWeatherItem.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/21.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class HourlyWeatherItem: BaseItem {
    var hourWeathers:[HourWeather]
    init(itemType: Int,hourWeathers:[HourWeather]?) {
        if let h=hourWeathers{
            self.hourWeathers=h
        }else{
            self.hourWeathers=[]
        }
        super.init(itemType: itemType)
    }
}
