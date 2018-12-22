//
//  HourWeatherViewCell.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/21.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import UIKit
class HourWeatherViewCell: UICollectionViewCell {
    @IBOutlet weak var tempLb: UILabel!
    @IBOutlet weak var weatherIconIv: UIImageView!
    @IBOutlet weak var timeLb: UILabel!
    func setInfo(hourWeatherItem:HourWeatherItem) -> Void {
        tempLb.text=hourWeatherItem.temp
        timeLb.text=hourWeatherItem.time
        weatherIconIv.image=UIImage(named:"blue_\(hourWeatherItem.img)" )
    }
}
