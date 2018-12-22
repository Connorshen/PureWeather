//
//  LifeIndexItem.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/21.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class LifeIndexItem:BaseItem{
    var name:String
    var value:String
    var detail:String
    init(itemType: Int,name:String?,value:String?,detail:String?) {
        if let n=name{
            self.name=n
        }else{
            self.name="--"
        }
        if let v=value{
            self.value=v
        }else{
            self.value="--"
        }
        if let d=detail{
            self.detail=d
        }else{
            self.detail="--"
        }
        super.init(itemType: itemType)
    }
}
