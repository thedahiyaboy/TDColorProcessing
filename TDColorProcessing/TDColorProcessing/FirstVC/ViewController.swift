//
//  ViewController.swift
//  TDColorProcessing
//
//  Created by DahiyaBoy on 08/12/17.
//  Copyright © 2017 DahiyaBoy. All rights reserved.
//

import UIKit
import PaintBucket

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    // MARK:- Outlet
    // MARK:-
    @IBOutlet weak var imgViewMy: UIImageView!
    
    
    // MARK:- VC Properties
    // MARK:-
    
    var imgOriginal = UIImage(named: "color.png")
    var imgDup : UIImage?
    var arrColorList : [UIColor] = [.black, .blue, .orange, .yellow, .cyan, .gray,
                                    .lightGray, .red, .green, .purple, .magenta]
    var colorSel : UIColor = UIColor.clear
    var touchedPoint : CGPoint?
    
    // MARK:- VC Cycles
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.imgViewMy.image = imgOriginal
        imgDup = imgOriginal
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapResponse))
        tapGestureRecognizer.delegate = self
        imgViewMy.addGestureRecognizer(tapGestureRecognizer)
        imgViewMy.isUserInteractionEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- Image Process
    // MARK:-
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
        
        let touchView = gestureRecognizer.view
        
        if touchView == imgViewMy{
            
            let point : CGPoint = touch.location(in: imgViewMy)
            touchedPoint = point
            return true
        }
        return false
    }
    
    func tapResponse(sender: UITapGestureRecognizer? = nil) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)
            
            if hitView === self.imgViewMy {
                print("touch is inside")
                self.imgDup = self.imgDup?.pbk_imageByReplacingColorAt(Int((self.touchedPoint?.x)!),
                                                                       Int((self.touchedPoint?.y)!),
                                                                       withColor: self.colorSel,
                                                                       tolerance: 10)
                
                self.imgViewMy.image = self.imgDup
                
            } else {
                print("touch is outside")
            }
        }
    }
    
    @IBAction func btnCheckAction(_ sender: UIButton) {
        
    }
    
    @IBAction func btnResetAction(_ sender: UIButton) {
        self.imgDup = self.imgOriginal
        self.imgViewMy.image = self.imgDup
    }
    
    // MARK:- CollectionView
    // MARK:-

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrColorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColColorListCell", for: indexPath) as! ColColorListCell
        
        cell.viewColor.backgroundColor = arrColorList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        colorSel = arrColorList[indexPath.row]
    }
    
}

