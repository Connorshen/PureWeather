//
//  SettingItem.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/5.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class NorSettingItem: BaseItem {
    let text:String
    init(itemType: Int,text:String?) {
        if let text = text{
            self.text = text
        }else {
            self.text = ""
        }
        super.init(itemType: itemType)
    }
}
