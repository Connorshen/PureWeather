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
    @IBOutlet weak var coverIv: UIImageView!
    @IBOutlet weak var edgeIv: UIImageView!
    @IBAction func onCloseClick(_ sender: Any) {
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: Event.CLOSE_CLICK, packageName: getPackageName())
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        playMusic()
        initView()
    }
    func initView(){
        coverIv.layer.masksToBounds = true
        coverIv.layer.cornerRadius = 100
        edgeIv.layer.masksToBounds = true
        edgeIv.layer.cornerRadius = 110
    }
    override func viewWillDisappear(_ animated: Bool) {
        stopMusic()
    }
    func stopMusic(){
        if (self.audioPlayer != nil){
            self.audioPlayer?.stop()
        }
        stopRotate()
    }
    func playMusic(){
        let fileUrl = Bundle.main.url(forResource: "hide",
                                      withExtension: "mp3",
                                      subdirectory: nil,
                                      localization: nil)
        self.audioPlayer = try! AVAudioPlayer.init(contentsOf: fileUrl!)
        self.audioPlayer?.numberOfLoops = -1
        if (self.audioPlayer != nil)
        {
            self.audioPlayer?.play()
        }
        startRotate()
        showToast(msg: "开始播放音乐，请打开音量")
    }
    func startRotate() {
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 10
        rotationAnim.isRemovedOnCompletion = false
        coverIv.layer.add(rotationAnim, forKey: nil)
    }
    func stopRotate() {
        coverIv.layer.removeAllAnimations()
    }
}

