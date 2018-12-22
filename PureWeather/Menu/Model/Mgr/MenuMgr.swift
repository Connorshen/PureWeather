//
//  MenuController.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/24.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import CoreData
import HandyJSON
class MenuMgr: BaseMgr {
    static let shared=MenuMgr()
    static let KEY_WEATHER_CLICK = NSNotification.Name(rawValue:"key_weather_click")
}
