//
//  CityWeatherViewCell.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/28.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class CityWeatherViewCell: UITableViewCell {
    @IBOutlet weak var locatedIv: UIImageView!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var rangeLb: UILabel!
    @IBOutlet weak var weatherLb: UILabel!
    @IBOutlet weak var tempLb: UILabel!
    @IBOutlet weak var cityNameLb: UILabel!
    @IBOutlet weak var closeBtn: UIImageView!
    private var cityId:String?
    private var delegate:CityWeatherDelegate?
    func setInfo(item:CityWeatherItem,delegate:CityWeatherDelegate) -> Void {
        self.delegate = delegate
        cityNameLb.text=item.cityName
        cityId=item.cityId
        rangeLb.text=item.range
        weatherLb.text=item.weather
        tempLb.text=item.temp
        if item.canDelete{
            closeBtn.isHidden=true
            locatedIv.isHidden=false
        }else{
            closeBtn.isHidden=false
            locatedIv.isHidden=true
        }
        weatherIcon.image=UIImage(named: "yellow_\(item.weatherIcon)")
        closeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeClick)))
        closeBtn.isUserInteractionEnabled=true
        mView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellClick)))
        mView.isUserInteractionEnabled=true
    }
    @objc func cellClick(){
        delegate?.onCellClick(cityId: cityId!)
    }
    @objc func closeClick(){
        delegate?.onDelete(cityId: cityId!)
    }
}
protocol CityWeatherDelegate {
    func onDelete(cityId:String)
    func onCellClick(cityId:String)
}
