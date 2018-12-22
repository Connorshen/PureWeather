//
//  CityWeatherItem.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/28.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class CityWeatherItem: BaseItem {
    var cityName:String
    var cityId:String
    var canDelete:Bool
    var temp:String
    var range:String
    var weather:String
    var weatherIcon:String
    init(itemType: Int,cityWeather:Weather?,canDelete:Bool) {
        if let cityWeather = cityWeather {
            if let city = cityWeather.city{
                cityName=city
            }else{
                cityName="无数据"
            }
            if let cityId = cityWeather.cityid{
                self.cityId=cityId
            }
            else {
                cityId="0"
            }
            if let temp = cityWeather.temp{
                self.temp="\(temp)°"
            }else{
                temp="--℃"
            }
            if let low = cityWeather.templow,let high = cityWeather.temphigh{
                range="\(low)℃-\(high)℃"
            }else{
                range="--℃"
            }
            if let w = cityWeather.weather{
                weather = w
            }
            else{
                weather="无数据"
            }
            if let icon = cityWeather.img{
                weatherIcon=icon
            }else{
                weatherIcon="99"
            }
            self.canDelete=canDelete
        }else{
            cityName="无数据"
            cityId="0"
            temp="--℃"
            range="--℃"
            weather="无数据"
            weatherIcon="99"
            self.canDelete=false
        }
        super.init(itemType: itemType)
    }
}
