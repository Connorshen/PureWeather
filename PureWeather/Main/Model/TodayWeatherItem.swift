//
//  TodayWeatherItem.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/20.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class TodayWeatherItem: BaseItem {
    var temp:String
    var tempRange:String
    var weatherDes:String
    var updateTime:String
    
    init(itemType:Int,temp:String?,weatherDes:String?,tempMax:String?,tempMin:String?,updateTime:String?) {
        if let t = temp{
            self.temp=t
        }else{
            self.temp="--"
        }
        if let max = tempMax,let min = tempMin{
            self.tempRange=max+"℃/"+min+"℃"
        }else{
            self.tempRange="--℃/--℃"
        }
        if let des=weatherDes{
            self.weatherDes=des
        }else{
            self.weatherDes="无数据"
        }
        if let ut=updateTime{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormat.date(from: ut)
            let dateMatt = DateFormatter()
            dateMatt.dateFormat = "HH:mm发布"
            let str = dateMatt.string(from: date ?? Date())
            self.updateTime=str
        }else{
            self.updateTime="--:--发布"
        }
        super.init(itemType: itemType)
    }
}
