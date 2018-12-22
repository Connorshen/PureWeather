//
//  DailyWeatherViewCell.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/21.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import UIKit
class DailyWeatherViewCell:UITableViewCell{
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var tempRangeLb: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    func setInfo(dailyWeatherItem:DailyWeatherItem) -> Void {
        dateLb.text=dailyWeatherItem.date
        tempRangeLb.text=dailyWeatherItem.tempRange
        weatherIcon.image=UIImage(named: "blue_\(dailyWeatherItem.weatherIcon)")
        self.selectionStyle = .none
    }
}
