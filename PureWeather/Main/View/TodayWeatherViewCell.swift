//
//  TodayWeatherViewCell.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/20.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import UIKit
class TodayWeatherViewCell:UITableViewCell{
    @IBOutlet weak var updateTimeLb: UILabel!
    @IBOutlet weak var tempRange: UILabel!
    @IBOutlet weak var tempLb: UILabel!
    @IBOutlet weak var weatherDesLb: UILabel!
    func setInfo(todayItem:TodayWeatherItem) -> Void {
        tempRange.text=todayItem.tempRange
        tempLb.text=todayItem.temp
        weatherDesLb.text=todayItem.weatherDes
        updateTimeLb.text=todayItem.updateTime
        self.selectionStyle = .none
    }
}
