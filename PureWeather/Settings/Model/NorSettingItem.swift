//
//  NorSettingItem.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/5.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class NorSettingItem: BaseItem {
    var text:String
    var hasArrow:Bool = false
    var settingType = SettingType.TYPE_NONE
    init(itemType: Int,text:String?,hasArrow:Bool?,settingType:Int?) {
        if let text = text {
            self.text = text
        }else{
            self.text = ""
        }
        if let hasArrow = hasArrow{
            self.hasArrow = hasArrow
        }
        if let settingType = settingType{
            self.settingType = settingType
        }
        super.init(itemType: itemType)
    }
}
