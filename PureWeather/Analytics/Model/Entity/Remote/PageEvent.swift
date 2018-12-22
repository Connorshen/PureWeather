//
//  PageLog.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/4.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import LeanCloud
class PageEvent: BaseRemoteEntity {
    @objc dynamic var pageName:LCString?
    @objc dynamic var startTime:LCDate?
    @objc dynamic var endTime:LCDate?
    @objc dynamic var dur:LCString?
    override static func objectClassName() -> String {
        return "PageLog"
    }
}
