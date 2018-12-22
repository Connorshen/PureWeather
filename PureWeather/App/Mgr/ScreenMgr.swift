//
//  ScreenMgr.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/4.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class ScreenMgr: BaseMgr {
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
    static var shared = ScreenMgr()
}
