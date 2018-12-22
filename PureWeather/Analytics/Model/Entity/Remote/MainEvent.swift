//
//  ClickEvent.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/4.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import LeanCloud
class MainEvent: BaseRemoteEntity {
    @objc dynamic var eventType:LCString?
    @objc dynamic var eventId:LCString?
    @objc dynamic var eventTime:LCDate?
    @objc dynamic var pageName:LCString?
    @objc dynamic var msg1:LCString?
    @objc dynamic var msg2:LCString?
    override static func objectClassName() -> String {
        return "MainEvent"
    }
}
