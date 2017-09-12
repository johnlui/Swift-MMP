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
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var statedTimeLabel: UILabel!
    @IBOutlet weak var leftTimeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = Common.thumbBaseURI + song[1] + ".jpg"
        self.backgroundImageView.kf.setImage(with: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!))
        
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

}
