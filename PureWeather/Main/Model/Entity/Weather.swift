//
//  WeatherModel.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/20.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

/// 天气数据模型
import Foundation
import HandyJSON
class Weather: HandyJSON{
    /// 城市
    var city: String?
    /// 城市id
    var cityid:String?
    /// 日期
    var date: String?
    /// 星期
    var week: String?
    /// 天气
    var weather: String?
    /// 温度
    var temp: String?
    var temphigh: String?
    var templow: String?
    /// 湿度
    var humidity: String?
    /// 气压
    var pressure: String?
    /// 风速
    var windspeed: String?
    /// 风向
    var winddirect: String?
    /// 风力
    var windpower: String?
    /// 更新时间
    var updatetime: String?
    /// 指数
    var aqi: Aqi?
    var img:String?
    /// 生活指数
    var index: [Index]?
    /// 未来天气预报
    var daily: [Forecast]?
    
    var hourly:[HourWeather]?
    required init(){}
    func toString() -> String {
        return self.toJSONString()!
    }
}
class HourWeather: HandyJSON{
    var time:String?
    var weather:String?
    var temp:String?
    var img:String?
    required init(){}
}
class Index: HandyJSON {
    var iname:String?
    var ivalue:String?
    var detail:String?
    required init(){}
}
class Aqi: HandyJSON {
    var ipm10:String?
    var ipm2_5: String?
    var ino2:String?
    var iso2:String?
    var io3:String?
    var co:String?
    var quality: String?
    required init(){}
}

/// 未来天气预报
class Forecast: HandyJSON {
    var date: String?
    var week: String?
    var sunrise: String?
    var sunset: String?
    var day: Day?
    var night: Night?
    required init(){}
}

/// 白天
class Day: HandyJSON {
    var temphigh: String?
    var weather: String?
    var img:String?
    var winddirect:String?
    var windpower:String?
    required init(){}
}

/// 夜间
class Night: HandyJSON {
    var templow: String?
    var weather: String?
    var img:String?
    var winddirect:String?
    var windpower:String?
    required init(){}
}
