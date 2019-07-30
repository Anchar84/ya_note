//
//  ImageViewController.swift
//  Notes
//
//  Created by user on 22.07.2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var imgViews = [UIImageView]()
    
    @IBOutlet weak var scroll: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for name in ["img1", "img2", "img3", "img4", "img5"] {
            let imgView = UIImageView(image: UIImage(named: name))
            imgView.contentMode = .scaleToFill
            imgViews.append(imgView)
            scroll.addSubview(imgView)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for (index, iView) in imgViews.enumerated() {
            iView.frame.size = scroll.frame.size
            iView.frame.origin.x = scroll.frame.width * CGFloat(index)
            iView.frame.origin.y = 0
        }
        let w = scroll.frame.width * CGFloat(imgViews.count)
        scroll.contentSize = CGSize(width: w, height: scroll.frame.height)
    }

}
