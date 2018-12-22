//
//  Music.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/12/22.
//  Copyright © 2018 沈正圆. All rights reserved.
//


import Foundation
import LeanCloud
class Music:LCObject{
    @objc dynamic var file:LCData?
    override static func objectClassName() -> String {
        return "Music"
    }
    required init() {
    }
}
