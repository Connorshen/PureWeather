//
//  SingleLocation.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/22.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import LeanCloud
class SingleLocation: BaseRemoteEntity {
    @objc dynamic var name: LCString?
    @objc dynamic var coordinate: LCGeoPoint?
    @objc dynamic var des: LCString?
    @objc dynamic var formattedAddress: LCString?
    @objc dynamic var reGeocode: LCString?
    @objc dynamic var speed: LCString?
    @objc dynamic var course: LCString?
    @objc dynamic var altitude: LCString?
    @objc dynamic var precision: LCString?
    override static func objectClassName() -> String {
        return "SingleLocation"
    }
    func setCoordinate(lat:Double?,lon:Double?) -> Void {
        if let lat=lat,let lon=lon{
            self.coordinate=LCGeoPoint(latitude: lat, longitude: lon)
        }
    }
    func setDes(des:String?) -> Void {
        if let des=des {
            self.des=LCString(des)
        }
    }
    func setLocation(location:CLLocation?)->Void{
        if let location=location{
            self.coordinate=LCGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.des=LCString(location.description)
            self.speed=LCString("\(location.speed)")
            self.course=LCString("\(location.course)")
            self.altitude=LCString("\(location.altitude)")
            self.precision=LCString("\(location.horizontalAccuracy)")
        }
    }
    func setReGeocode(reGeocode:AMapLocationReGeocode?)->Void{
        if let reGeocode=reGeocode{
            self.reGeocode=LCString("\(reGeocode)")
            self.formattedAddress=LCString(reGeocode.formattedAddress)
        }
    }
    func setFailed(){
        self.des="定位发生错误"
    }
}
