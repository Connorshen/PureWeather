//
//  HourlyWeatherViewCell.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/21.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import UIKit
class HourlyWeatherViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    let TYPE_HOUR_WEATHER=1
    @IBOutlet weak var mListView: UICollectionView!
    var mItems:[BaseItem] = []
    func setInfo(hourlyWeatherItem:HourlyWeatherItem) -> Void {
        mListView.dataSource=self
        mListView.delegate=self
        mListView.register(UINib(nibName: "HourWeatherViewCell", bundle: nil), forCellWithReuseIdentifier: "HourWeatherViewCell")
        mItems.removeAll()
        let weathers=hourlyWeatherItem.hourWeathers
        for weather in weathers{
            mItems.append(HourWeatherItem(itemType: TYPE_HOUR_WEATHER, time: weather.time, temp: weather.temp, img: weather.img))
        }
        mListView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mItems.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let baseItem=mItems[indexPath.row] 
        let cell: HourWeatherViewCell = self.mListView.dequeueReusableCell(withReuseIdentifier: "HourWeatherViewCell", for: indexPath) as! HourWeatherViewCell
        cell.setInfo(hourWeatherItem: baseItem as! HourWeatherItem)
        return cell
    }
}
