//
//  LocationMgr.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/24.
//  Copyright © 2018年 沈正圆. All rights reserved.
//
///定位失败默认使用杭州的坐标
import Foundation
class LocationMgr:BaseMgr{
    private var locationManager:AMapLocationManager!
    private var getLocationSuccessful=false
    private var curLat:Double?
    private var curLon:Double?
    private var curLocation:CLLocation?
    private var reGeocode:AMapLocationReGeocode?
    static let shared=LocationMgr()
    private let DEFAULT_LAT:Double=30.224627
    private let DEFAULT_LON:Double=120.141346
    static let KEY_LCATED = NSNotification.Name(rawValue:"key_located")
    static let KEY_LCATED_FAILED = NSNotification.Name(rawValue:"key_located_failed")
    func getCurLat() -> Double {
        if let lat=curLat{
            return lat
        }else {
            return DEFAULT_LAT
        }
    }
    func getCurLon() -> Double {
        if let lon=curLon{
            return lon
        }else {
            return DEFAULT_LON
        }
    }
    func getCurLocation() -> CLLocation? {
        return curLocation
    }
    func getCurReGeocode() -> AMapLocationReGeocode? {
        return reGeocode
    }
    func isLocatedSuccessful() -> Bool {
        return getLocationSuccessful
    }
    func getLocation() -> Void {
        locationManager=AMapLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.locationTimeout = 2
        locationManager.reGeocodeTimeout = 2
        locationManager.requestLocation(withReGeocode: true, completionBlock: {(location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    self.getLocationSuccessful=false
                    self.sendMessage(name: LocationMgr.KEY_LCATED_FAILED, object: nil)
                    AnalyticsMgr.shared.uploadLoation()
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            
            if let location = location {
                self.getLocationSuccessful=true
                self.curLat=location.coordinate.latitude
                self.curLon=location.coordinate.longitude
                self.curLocation=location
                self.reGeocode=reGeocode
                self.sendMessage(name: LocationMgr.KEY_LCATED, object: nil)
                AnalyticsMgr.shared.uploadLoation()
            }
        })
    }
}
