//
//  PlayerViewController.swift
//  Swift-MMP
//
//  Created by John Lui on 2017/9/13.
//  Copyright © 2017年 John Lui. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    var song = Array<String>()

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var statedTimeLabel: UILabel!
    @IBOutlet weak var leftTimeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = Common.thumbBaseURI + song[1] + ".jpg"
        if let string = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            self.backgroundImageView.kf.setImage(with: URL(string: string))
            self.albumImageView.kf.setImage(with: URL(string: string))
        }
        
        self.songNameLabel.text = song[0]
        self.albumLabel.text = song[1]
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
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.albumImageView.alpha = 1
        }, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func gobackButtonBeTapped(_ sender: Any) {
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
    }
    @IBAction func pauseButtonBeTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            
        }
    }
    @IBAction func nextButtonBeTapped(_ sender: Any) {
    }
    @IBAction func heartButtonBeTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            let image = button.currentImage == #imageLiteral(resourceName: "ic_favorite_white_48dp") ? #imageLiteral(resourceName: "ic_favorite_red_48dp") : #imageLiteral(resourceName: "ic_favorite_white_48dp")
            button.setImage(image, for: UIControlState.normal)
        }
    }
    
}
