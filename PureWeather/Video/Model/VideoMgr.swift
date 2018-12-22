//
//  VideoMgr.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/12/22.
//  Copyright © 2018 沈正圆. All rights reserved.
//

import Foundation
import LeanCloud
class VideoMgr: BaseMgr {
    static let shared = VideoMgr()
    var musicUrl:String = ""
    func getMusic(){
        let query = LCQuery(className: "Music")
        query.find() { result in
            switch result {
            case .success(let objects):
                if objects.count>0{
                    let object = objects[0]
                    if let music = object as? Music{
                        print(music.file?.jsonString)
                    }
                }
                break
            case .failure(let error):
                break
            }
        }
    }
}
