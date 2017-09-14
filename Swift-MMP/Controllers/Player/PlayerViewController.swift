//
//  PlayerViewController.swift
//  Swift-MMP
//
//  Created by John Lui on 2017/9/13.
//  Copyright © 2017年 John Lui. All rights reserved.
//

import UIKit
import AVFoundation
import WatchConnectivity

class AudioStreamFile: NSObject, DOUAudioFile {
    
    var url: URL!
    
    required init(url: URL) {
        self.url = url
    }
    
    @objc func audioFileURL() -> URL! {
        return self.url
    }
}

class PlayerViewController: UIViewController {
    
    let session : WCSession? = WCSession.isSupported() ? WCSession.default() : nil
    
    var nowPlayingInfoCenter = NowPlayingInfoCenter()
    
    var timer = Timer()
    
    var streamer: DOUAudioStreamer!
    fileprivate var kBufferingRatioKVOKey = 1
    fileprivate var kDurationKVOKey = 1
    fileprivate var kStatusKVOKey = 1
    fileprivate var hasArtwork = false
    
    var playingIndex = 0

    var song = Array<String>()

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var statedTimeLabel: UILabel!
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var cacheProgressView: UIProgressView!
    @IBOutlet weak var musicPlayingProgressSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pleaseWait()
        
        let urlString = Common.thumbBaseURI + song[1] + ".jpg"
        if let string = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            self.backgroundImageView.kf.setImage(with: URL(string: string))
            self.albumImageView.kf.setImage(with: URL(string: string))
        }
        
        self.songNameLabel.text = song[0]
        self.albumLabel.text = song[1]
        
        self.nowPlayingInfoCenter.musicPlayerVC = self
        AVAudioSession.sharedInstance()
        
        self.session?.delegate = self;
        self.session?.activate()
        
        self.initPlayerBasedOnReachability()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let session = self.session {
            if session.isReachable {
                session.sendMessage(["action": "init"], replyHandler: nil, errorHandler: { error in
                    print(error)
                });
            }
        }
    }
    

    // MARK: - Plyaer
    func initPlayerBasedOnReachability() {
        
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            self.refreshPlayer()
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.noticeError("no network")
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context == &self.kBufferingRatioKVOKey) {
            DispatchQueue.main.async {
                if self.streamer == nil {
                    return
                }
                self.cacheProgressView.setProgress(Float(self.streamer.bufferingRatio), animated: true)
                
                /*
                // --------------------------
                //
                // save cache to local disk
                //
                // --------------------------
                if self.streamer.bufferingRatio >= 1 {
                    do {
                        let path = self.streamer.cachedPath
                        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                        let songsPath = documentsPath + "/songs"
                        let fileManager = FileManager.default
                        
                        if !fileManager.fileExists(atPath: songsPath) {
                            try fileManager.createDirectory(atPath: songsPath, withIntermediateDirectories: false, attributes: nil)
                        }
                        
                        let path2 = songsPath + ("/" + App.songs[self.playingIndex])
                        
                        if !fileManager.fileExists(atPath: path2) {
                            try fileManager.copyItem(atPath: path!, toPath: path2)
                        }
                    } catch {
                        print(error)
                    }
                }
                */
            }
        } else if (context == &self.kDurationKVOKey) {
            DispatchQueue.main.async {
                if self.streamer == nil {
                    return
                }
                self.timerAction()
            }
        } else if (context == &self.kStatusKVOKey) {
            DispatchQueue.main.async {
                if self.streamer == nil {
                    return
                }
                switch self.streamer.status {
                case .playing:
                    print("Playing")
                    self.clearAllNotice()
                    self.playButton.setImage(UIImage(named: "ic_pause_white_36dp"), for: UIControlState())
                    var dictionaryToWatch: [String: Any] = ["action": "play", "status": "playing"]
                    
                    if !self.hasArtwork {
                        // refresh lock screen info
                        var truePath = ""
                        do {
                            let path = self.streamer.cachedPath
                            if path == nil {
                                return
                            }
                            let path2 = NSTemporaryDirectory() + "a.mp3"
                            let fileManager = FileManager.default
                            if fileManager.fileExists(atPath: path2) {
                                try fileManager.removeItem(atPath: path2)
                            }
                            try fileManager.copyItem(atPath: path!, toPath: path2)
                            truePath = path2
                        } catch {
                            print(error)
                        }
                        let asset = AVURLAsset(url: URL(fileURLWithPath: truePath))
                        self.nowPlayingInfoCenter.setNowPlayingInfo(asset)
                        for i in asset.metadata {
                            if i.commonKey == "artwork" {
                                self.hasArtwork = true
                                if let data = i.value as? Data {
                                    self.albumImageView.image = UIImage(data: data)
                                    self.albumImageView.layer.add(CATransition(), forKey: kCATransition)
                                    
                                    self.backgroundImageView.image = UIImage(data: data)
                                    self.backgroundImageView.layer.add(CATransition(), forKey: kCATransition)
                                }
                            }
                        }
                    }
                    if let image = self.albumImageView.image {
                        dictionaryToWatch["artwork"] = UIImageJPEGRepresentation(image.resizeToSize(CGSize(width: 128, height: 128)), 0.3)
                    }
                    
                    if let session = self.session {
                        if session.isReachable {
                            session.sendMessage(dictionaryToWatch, replyHandler: nil, errorHandler: { error in
                                print(error)
                            });
                        }
                    }
                case .paused:
                    self.playButton.setImage(UIImage(named: "ic_play_white_36dp"), for: UIControlState())
                    if let session = self.session {
                        if session.isReachable {
                            session.sendMessage(["action": "play", "status": "paused"], replyHandler: nil, errorHandler: { error in
                                print(error)
                            });
                        }
                    }
                case .finished:
                    self.playingIndex += 1
                    self.refreshPlayer()
                case .error:
                    self.noticeError("error", autoClear: true, autoClearTime: 3)
                case .buffering:
                    self.pleaseWait()
                default:
                    break
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    func refreshPlayer() {
        self.cancelStreamer()
        var song = ""
        
        var songsArray = Array<String>();
        for i in Common.songsArray {
            songsArray.append(i[0])
        }
        
        if self.playingIndex >= songsArray.count {
            self.playingIndex = 0
        } else if self.playingIndex == -1 {
            self.playingIndex = songsArray.count - 1
        }
        
        // set two label text
        self.songNameLabel.text = Common.songsArray[playingIndex][0]
        self.albumLabel.text = Common.songsArray[playingIndex][1]
        
        song = songsArray[self.playingIndex]
        
        self.streamer = DOUAudioStreamer(audioFile: AudioStreamFile(url: self.getURLOfAudioFile(song)))
        
        self.streamer.addObserver(self, forKeyPath: "bufferingRatio", options: NSKeyValueObservingOptions.new, context: &self.kBufferingRatioKVOKey)
        self.streamer.addObserver(self, forKeyPath: "duration", options: NSKeyValueObservingOptions.new, context: &self.kDurationKVOKey)
        self.streamer.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: &self.kStatusKVOKey)

        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.musicPlayingProgressSlider.isUserInteractionEnabled = true
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }

        self.streamer.play()
        
        self.setupNextAudioHint()
    }
    
    func cancelStreamer() {
        self.hasArtwork = false
        if self.streamer != nil {
            self.streamer.pause()
            
            // pause 之后立刻取消观察，导致检测不到 .Paused 事件，只能手动修改按钮图片了
            self.playButton.setImage(UIImage(named: "ic_play_white_36dp"), for: UIControlState())
            
            self.streamer.removeObserver(self, forKeyPath: "status")
            self.streamer.removeObserver(self, forKeyPath: "duration")
            self.streamer.removeObserver(self, forKeyPath: "bufferingRatio")
            self.streamer = nil
            self.musicPlayingProgressSlider.setValue(0, animated: false)
            self.cacheProgressView.setProgress(0, animated: false)
        }
    }
    
    func setupNextAudioHint() {
        var nextIndex = self.playingIndex + 1
        if nextIndex >= Common.songsArray.count {
            nextIndex = 0
        }
        DOUAudioStreamer.setHintWith(AudioStreamFile(url: self.getURLOfAudioFile(Common.songsArray[nextIndex][0])))
    }
    
    func getURLOfAudioFile(_ song: String) -> URL {
        if let urlString = (Common.songBaseURI + song + ".mp3").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let tempUrl = URL(string: urlString) {
            return tempUrl
        }
        return URL(string: "a")!
    }
    
    func timerAction() {
        if self.streamer != nil && self.streamer.duration != 0 {
            self.musicPlayingProgressSlider.setValue(Float(self.streamer.currentTime / self.streamer.duration), animated: true)
            self.hmsFrom(seconds: Int(self.streamer.currentTime)) { minutes, seconds in
                let minutes = self.getStringFrom(seconds: minutes)
                let seconds = self.getStringFrom(seconds: seconds)
                self.statedTimeLabel.text = "\(minutes):\(seconds)"
            }
            self.hmsFrom(seconds: Int(self.streamer.duration) - Int(self.streamer.currentTime)) { minutes, seconds in
                let minutes = self.getStringFrom(seconds: minutes)
                let seconds = self.getStringFrom(seconds: seconds)
                self.leftTimeLabel.text = "\(minutes):\(seconds)"
            }
        }
    }
    
    // stolen from https://stackoverflow.com/a/40794726
    func hmsFrom(seconds: Int, completion: @escaping (_ minutes: Int, _ seconds: Int)->()) {
        completion((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }

    @IBAction func gobackButtonBeTapped(_ sender: Any) {
        self.cancelStreamer()
        self.timer.invalidate()
        self.clearAllNotice()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func randomButtonBeTapped(_ sender: Any) {
        let imagesArray = [#imageLiteral(resourceName: "ic_list_repeat"), #imageLiteral(resourceName: "ic_one_shot"), #imageLiteral(resourceName: "ic_shuffle_white_36dp")]
        if let button = sender as? UIButton,
            let currentImage = button.currentImage,
            let index = imagesArray.index(of: currentImage) {
            var i = index + 1;
            if i > 2 {
                i = 0
            }
            button.setImage(imagesArray[i], for: UIControlState.normal)
        }
    }
    @IBAction func prevButtonBeTapped(_ sender: Any) {
        self.playingIndex -= 1
        self.refreshPlayer()
    }
    @IBAction func playAndPauseButtonBeTapped(_ sender: Any) {
        if sender is UIButton && self.streamer != nil {
            if self.streamer.status == .paused || self.streamer.status == .idle {
                self.streamer.play()
            } else {
                self.streamer.pause()
            }
        }
    }
    @IBAction func nextButtonBeTapped(_ sender: Any) {
        self.playingIndex += 1
        self.refreshPlayer()
    }
    @IBAction func heartButtonBeTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            let image = button.currentImage == #imageLiteral(resourceName: "ic_favorite_white_48dp") ? #imageLiteral(resourceName: "ic_favorite_red_48dp") : #imageLiteral(resourceName: "ic_favorite_white_48dp")
            button.setImage(image, for: UIControlState.normal)
        }
    }
    @IBAction func musicPlayingProgressSliderValueChanged(_ sender: Any) {
        if self.streamer != nil {
            let time = self.streamer.duration * TimeInterval(self.musicPlayingProgressSlider.value)
            self.streamer.currentTime = time
        }
    }
    
}

extension PlayerViewController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if message["action"] as? String == "toggle" {
                self.playAndPauseButtonBeTapped(self.playButton)
            }
        }
    }
    
    //Handlers in case the watch and phone watch connectivity session becomes disconnected
    func sessionDidDeactivate(_ session: WCSession) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
