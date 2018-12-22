//
//  QuestionCfg.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/7.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import LeanCloud
class QuestionCfg:LCObject{
    @objc dynamic var mode:LCString?
    @objc dynamic var password:LCString?
    override static func objectClassName() -> String {
        return "QuestionCfg"
    }
    required init() {
        mode = LCString(QuestionMode.MODE_NONE)
        password = LCString(QuestionMode.DEFAULT_PASSWORD)
    }
    func setMode(mode:String?){
        if let mode = mode{
            self.mode = LCString(mode)
        }
    }
    func setPassword(password:String?) {
        if let password = password{
            self.password = LCString(password)
        }
    }
}
