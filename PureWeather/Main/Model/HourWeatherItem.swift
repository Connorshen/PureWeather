//
//  HourWeatherItem.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/21.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class HourWeatherItem: BaseItem {
    var time:String
    var temp:String
    var img:String
    init(itemType: Int,time:String?,temp:String?,img:String?) {
        if let i=img{
            self.img=i
        }else{
            self.img="99"
        }
        if let t=temp{
            self.temp=t+"℃"
        }else{
            self.temp="--℃"
        }
        if let t=time{
            self.time=t
        }else{
            self.time="--:--"
        } 
        super.init(itemType: itemType)
    }
    
}
