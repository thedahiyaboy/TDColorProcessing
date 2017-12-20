//
//  ViewController.swift
//  TDColorProcessing
//
//  Created by DahiyaBoy on 08/12/17.
//  Copyright © 2017 DahiyaBoy. All rights reserved.
//

import UIKit
import PaintBucket

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate , UIScrollViewDelegate{

    // MARK:- Outlet
    // MARK:-
    @IBOutlet weak var imgViewMy: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK:- VC Properties
    // MARK:-
    var imgView2 : UIImageView = UIImageView()
    var imgOriginal = UIImage(named: "aa512.png")
    var imgDup : UIImage?
    var arrColorList : [UIColor] = [.black, .blue, .orange, .yellow, .cyan, .gray,
                                    .lightGray, .red, .green, .purple, .magenta]
    var colorSel : UIColor = UIColor.clear
    var touchedPoint : CGPoint?
    
    var scaleImg : CGSize!
    
    
    // MARK:- VC Cycles
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imgDup = imgOriginal
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        self.setImgView1()
    }

    func setImgView1()  {
        
        self.imgViewMy.image = self.imgDup

        self.scaleImageStrore(self.imgDup!, imgView: self.imgViewMy)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapResponse))
        tapGestureRecognizer.delegate = self
        imgViewMy.addGestureRecognizer(tapGestureRecognizer)
        imgViewMy.isUserInteractionEnabled = true
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)  //CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func scaleImageStrore(_ img : UIImage , imgView : UIImageView)  {
        let aScaleHeight : Double = Double(img.size.height / imgView.frame.size.height)
        let aScaleWidth : Double = Double(img.size.width / imgView.frame.size.width)
        
        self.scaleImg = CGSize(width: aScaleWidth, height: aScaleHeight)
    }
   
    
    func getScaledPoint(_ point : CGPoint) -> CGPoint {
        let aNewPointX = point.x * scaleImg.width
        let aNewPointY = point.y * scaleImg.height
        
        return CGPoint(x: aNewPointX, y: aNewPointY)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
    
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgViewMy
    }
    
    // MARK:- Image Process
    // MARK:-
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{

        // Activity Controller
//        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        activityView.frame = CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 50, height: 50)
//        self.view.addSubview(activityView)
//        activityView.startAnimating()
//        activityView.removeFromSuperview()
        
        let touchView = gestureRecognizer.view
        
        if touchView == self.imgViewMy{
            
            let point : CGPoint = touch.location(in: imgViewMy)
            touchedPoint = point
            
           self.imgViewMy.image = self.imgDup
            
            
            // Doing asysn coloring in image to avoid device hang up.
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                print("touch is inside , \(self.touchedPoint!)")
                
                let aNewCor = self.getScaledPoint(self.touchedPoint!)
                
                self.imgDup = self.imgDup?.pbk_imageByReplacingColorAt(Int(aNewCor.x),
                                                                       Int(aNewCor.y),
                                                                       withColor: self.colorSel,
                                                                       tolerance: 10)
                
                self.imgViewMy.image = self.imgDup
                
            }
            
//            DispatchQueue.global(qos: .default).async {
//                
//            }
            
//            DispatchQueue.main.async( execute: {
//            })
            
            return false
        }
        return false
    }
    
    func tapResponse(sender: UITapGestureRecognizer? = nil) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
//        var activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        activityView.frame = CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 50, height: 50)
//        
//        
//        if let firstTouch = touches.first {
//            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)
//            
//            if hitView === self.imgViewMy {
//                
//                
//                DispatchQueue.main.async( execute: {
//                    print("Async2")
//                    print("touch is inside , \(self.touchedPoint!)")
//                    
//                    self.view.addSubview(activityView)
//                    activityView.startAnimating()
//                    
//                    let aNewCor = self.getScaledPoint(self.touchedPoint!)
//                    
//                    self.imgDup = self.imgDup?.pbk_imageByReplacingColorAt(Int(aNewCor.x),
//                                                                           Int(aNewCor.y),
//                                                                           withColor: self.colorSel,
//                                                                           tolerance: 10)
//                    
//                    self.imgViewMy.image = self.imgDup
//                    
//                    activityView.removeFromSuperview()
//                    
//                })
//                
//                
//            } else {
//                print("touch is outside")
//            }
//        }
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

