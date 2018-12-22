//
//  DailyWeatherItem.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/21.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class DailyWeatherItem:BaseItem{
    var date:String
    var tempRange:String
    var weatherIcon:String
    init(itemType: Int,date:String?,week:String?,tempMax:String?,tempMin:String?,weatherIcon:String?) {
        if let d=date,let w=week{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            let date = dateFormat.date(from: d)
            let dateMatt = DateFormatter()
            dateMatt.dateFormat = "MM月dd日"
            let str = dateMatt.string(from: date ?? Date())
            self.date=str+w
        }else{
            self.date="--月--日"
        }
        if let max = tempMax,let min = tempMin{
            self.tempRange=max+"℃/"+min+"℃"
        }else{
            self.tempRange="--℃/--℃"
        }
        if let icon = weatherIcon {
            self.weatherIcon=icon
        }else{
            self.weatherIcon="99"
        }
        super.init(itemType: itemType)
    }
}
