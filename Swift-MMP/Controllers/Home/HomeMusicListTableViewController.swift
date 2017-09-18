//
//  HomeMusicListTableViewController.swift
//  Swift-MMP
//
//  Created by 吕文翰 on 2017/9/12.
//  Copyright © 2017年 John Lui. All rights reserved.
//

import UIKit
import Kingfisher

class HomeMusicListTableViewController: UITableViewController {
    
    weak var viewController: ViewController!
    weak var homeViewController: HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Common.songsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeMusicListTableViewCell

        let song = Common.songsArray[indexPath.row]
        
        let urlString = Common.thumbBaseURI + song[1] + ".jpg"
        cell.iv.kf.setImage(with: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!), placeholder: #imageLiteral(resourceName: "no_cover"))
        cell.titleLabel.text = song[0]
        cell.artistLabel.text = "周杰伦  |  " + song[1]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Player", bundle: nil).instantiateViewController(withIdentifier: "playerVC") as! PlayerViewController
        vc.song = Common.songsArray[indexPath.row]
        vc.playingIndex = indexPath.row
        self.viewController.show(vc, sender: tableView.cellForRow(at: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func randomButtonBeTapped(_ sender: Any) {
        let index = Int(Int(arc4random()) % Common.songsArray.count)
        self.tableView(self.tableView, didSelectRowAt: IndexPath(row: index, section: 0))
    }
    @IBAction func moreButtonBeTapped(_ sender: Any) {
        if let button = sender as? UIButton,
            let y = button.superview?.convert(button.frame.origin, to: nil).y {
            self.homeViewController.menuContainerViewTopConstraint.constant = y + 20
            self.homeViewController.menuContainerView.layoutIfNeeded()
            self.homeViewController.menuContainerView.isHidden = self.homeViewController.menuContainerView.isHidden ? false : true
        }
    }

}
