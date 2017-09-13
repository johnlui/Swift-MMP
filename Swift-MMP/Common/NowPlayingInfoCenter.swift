//
//  NowPlayingInfoCenter.swift
//  Swift-MMP
//
//  Created by John Lui on 2017/9/13.
//  Copyright © 2017年 John Lui. All rights reserved.
//

import MediaPlayer

class NowPlayingInfoCenter: NSObject {
    
    var mprcPlay, mprcPause, mprcPrevious, mprcNext: MPRemoteCommand!
    var musicPlayerVC: PlayerViewController!
    
    func setNowPlayingInfo(_ asset: AVURLAsset) {
        var info = [String: AnyObject]()
        for i in asset.metadata {
            if let key = i.commonKey {
                switch key {
                case AVMetadataCommonKeyArtwork:
                    info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: UIImage(data: i.value as! Data)!)
                case AVMetadataCommonKeyArtist:
                    info[MPMediaItemPropertyArtist] = i.value?.description as AnyObject?
                case MPMediaItemPropertyAlbumTitle:
                    info[MPMediaItemPropertyAlbumTitle] = i.value?.description as AnyObject?
                case AVMetadataCommonKeyTitle:
                    info[MPMediaItemPropertyTitle] = i.value?.description as AnyObject?
                default:
                    break
                }
            }
        }
        info[MPMediaItemPropertyPlaybackDuration] = self.musicPlayerVC.streamer.duration as AnyObject?
        info[MPNowPlayingInfoPropertyPlaybackRate] = 1 as AnyObject?
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        
        self.mprcPlay = MPRemoteCommandCenter.shared().playCommand
        self.mprcPlay.removeTarget(self)
        self.mprcPlay.addTarget (handler: { (event) -> MPRemoteCommandHandlerStatus in
            return .success
        })
        self.mprcPlay.addTarget(self, action: #selector(play(_:)))
        
        
        self.mprcPause = MPRemoteCommandCenter.shared().pauseCommand
        self.mprcPause.removeTarget(self)
        self.mprcPause.addTarget (handler: { (event) -> MPRemoteCommandHandlerStatus in
            return .success
        })
        self.mprcPause.addTarget(self, action: #selector(pause(_:)))
        
        
        self.mprcPrevious = MPRemoteCommandCenter.shared().previousTrackCommand
        self.mprcPrevious.removeTarget(self)
        self.mprcPrevious.addTarget (handler: { (event) -> MPRemoteCommandHandlerStatus in
            return .success
        })
        self.mprcPrevious.addTarget(self, action: #selector(previous(_:)))
        
        
        self.mprcNext = MPRemoteCommandCenter.shared().nextTrackCommand
        self.mprcNext.removeTarget(self)
        self.mprcNext.addTarget (handler: { (event) -> MPRemoteCommandHandlerStatus in
            return .success
        })
        self.mprcNext.addTarget(self, action: #selector(next(_:)))
    }
    
    func play(_ event: MPRemoteCommandEvent) {
        self.musicPlayerVC.streamer.play()
    }
    func pause(_ event: MPRemoteCommandEvent) {
        self.musicPlayerVC.streamer.pause()
    }
    func previous(_ event: MPRemoteCommandEvent) {
        print("prevButtonBeTapped")
        self.musicPlayerVC.prevButtonBeTapped(self)
    }
    func next(_ event: MPRemoteCommandEvent) {
        print("nextButtonBeTapped")
        self.musicPlayerVC.nextButtonBeTapped(self)
    }
}
