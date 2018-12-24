//
//  VideoController.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/9.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import AVFoundation
class VideoController:BaseController{
    var audioPlayer:AVAudioPlayer?
    @IBAction func onCloseClick(_ sender: Any) {
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: Event.CLOSE_CLICK, packageName: getPackageName())
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        playMusic()
    }
    override func viewWillDisappear(_ animated: Bool) {
        stopMusic()
    }
    func stopMusic(){
        if (self.audioPlayer != nil)
        {
            self.audioPlayer?.stop()
        }
    }
    func playMusic(){
        let fileUrl = Bundle.main.url(forResource: "hide",
                                      withExtension: "mp3",
                                      subdirectory: nil,
                                      localization: nil)
        self.audioPlayer = try! AVAudioPlayer.init(contentsOf: fileUrl!)
        if (self.audioPlayer != nil)
        {
            self.audioPlayer?.play()
        }
        
    }
}
