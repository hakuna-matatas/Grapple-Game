//
//  GameViewController.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 6/30/16.
//  Copyright (c) 2016 Alan Gao. All rights reserved.
//

import UIKit
import SpriteKit
import FBSDKShareKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.shareToFB), name: "showFBSheet", object: nil)
        
        if let scene = TitleScreen(fileNamed:"TitleScreen") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
    
    func shareToFB() {
        let fbShareContent = FBSDKShareLinkContent()
        fbShareContent.contentURL = NSURL(string:"https://www.google.com/search?q=penguin&source=lnms&tbm=isch&sa=X&ved=0ahUKEwic3ebN55bOAhVI8mMKHfl5Dw8Q_AUICCgB&biw=1280&bih=705#imgrc=mvO8p2N7Lflp1M%3A")
        fbShareContent.contentTitle = "Grapple is great"
        fbShareContent.contentDescription = "God bless penguins"
        fbShareContent.imageURL = NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/0/08/South_Shetland-2016-Deception_Island%E2%80%93Chinstrap_penguin_%28Pygoscelis_antarctica%29_04.jpg")
        
        let fbDialog = FBSDKShareDialog()
        fbDialog.shareContent = fbShareContent
        fbDialog.mode = FBSDKShareDialogMode.Native
        if(!fbDialog.canShow()) {
            fbDialog.mode = FBSDKShareDialogMode.FeedBrowser
        }
        
        fbDialog.show()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
