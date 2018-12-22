//
//  BaseRemoteEntity.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/4.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import LeanCloud
class BaseRemoteEntity: LCObject {
    @objc dynamic var identifierNumber:LCString?
    required init() {
        identifierNumber=LCString(AppMgr.shared.identifierNumber)
    }
}
