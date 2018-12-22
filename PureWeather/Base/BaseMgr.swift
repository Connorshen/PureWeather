//
//  BaseMgr.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/24.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class BaseMgr{
    func sendMessage(name: NSNotification.Name, object: Any?) -> Void {
        NotificationCenter.default.post(name: name, object: object)
    }
}
