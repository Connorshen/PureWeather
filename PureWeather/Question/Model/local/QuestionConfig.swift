//
//  QuestionConfig.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/7.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class QuestionConfig{
    var mode:String?
    var password:String?
    init() {
        mode = QuestionMode.MODE_NONE
        password = QuestionMode.DEFAULT_PASSWORD
    }
}
