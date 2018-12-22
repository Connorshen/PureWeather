//
//  AirQualityViewCell.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/21.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import UIKit
class AirQualityViewCell:UITableViewCell{
    @IBOutlet weak var airQualityLb: UILabel!
    @IBOutlet weak var coLb: UILabel!
    @IBOutlet weak var o3Lb: UILabel!
    @IBOutlet weak var so2Lb: UILabel!
    @IBOutlet weak var no2Lb: UILabel!
    @IBOutlet weak var pm2_5Lb: UILabel!
    @IBOutlet weak var pm10Pb: UILabel!
    func setInfo(airQualityItem:AirQualityItem) -> Void {
        airQualityLb.text=airQualityItem.airQuality
        coLb.text=airQualityItem.co
        o3Lb.text=airQualityItem.o3
        so2Lb.text=airQualityItem.so2
        no2Lb.text=airQualityItem.no2
        pm2_5Lb.text=airQualityItem.pm2_5
        pm10Pb.text=airQualityItem.pm10
        self.selectionStyle = .none
    }
}
