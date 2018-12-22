//
//  AirQualityItem.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/21.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class AirQualityItem: BaseItem {
    var airQuality:String?
    var pm10:String?
    var pm2_5:String?
    var no2:String?
    var so2:String?
    var o3:String?
    var co:String?
    init(itemType: Int,aqi:Aqi) {
        if let aq=aqi.quality{
            airQuality=aq
        }else{
            airQuality="--"
        }
        if let pm10=aqi.ipm10{
            self.pm10=pm10
        }else{
            self.pm10="--"
        }
        if let pm2_5=aqi.ipm2_5{
            self.pm2_5=pm2_5
        }else{
            self.pm2_5="--"
        }
        if let no2=aqi.ino2{
            self.no2=no2
        }else{
            self.no2="--"
        }
        if let so2=aqi.iso2{
            self.so2=so2
        }else{
            self.so2="--"
        }
        if let o3=aqi.io3 {
            self.o3=o3
        }else{
            self.o3="--"
        }
        if let co=aqi.co{
            self.co=co
        }else{
            self.co="--"
        }
        super.init(itemType: itemType)
    }
}
