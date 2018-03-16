//
//  ViewController.swift
//  TDColorProcessing
//
//  Created by DahiyaBoy on 08/12/17.
//  Copyright © 2017 DahiyaBoy. All rights reserved.
//

import UIKit
import PaintBucket
import ChromaColorPicker

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate , UIScrollViewDelegate, ChromaColorPickerDelegate{

    // MARK:- Outlet
    // MARK:-
    @IBOutlet weak var imgViewMy: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewChroma: UIView!
    
    // MARK:- VC Properties
    // MARK:-
    var imgView2 : UIImageView = UIImageView()
    var imgOriginal = UIImage(named: "week2_1.png")
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
        self.setChromaColorIn(thisView: self.viewChroma)
        self.setImgView1()
    }

    func setChromaColorIn(thisView : UIView){
        let neatColorPicker = ChromaColorPicker(frame:thisView.bounds)
        neatColorPicker.delegate = self //ChromaColorPickerDelegate
        neatColorPicker.padding = 5
        neatColorPicker.stroke = 3
        neatColorPicker.hexLabel.textColor = UIColor.black
        
        thisView.addSubview(neatColorPicker)
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
      
        let touchView = gestureRecognizer.view
        if touchView == self.imgViewMy {
            let point : CGPoint = touch.location(in: imgViewMy)
            touchedPoint = point
        }
        return true
    }
    
    func tapResponse(sender: UITapGestureRecognizer? = nil) {
        let aNewCor = self.getScaledPoint(self.touchedPoint!)
        self.imgDup = self.imgDup?.pbk_imageByReplacingColorAt(Int(aNewCor.x), Int(aNewCor.y), withColor: self.colorSel, tolerance: 90)
        self.imgViewMy.image = self.imgDup
    }
    
    @IBAction func btnCheckAction(_ sender: UIButton) {
        
        let chck = self.compareImages(self.imgDup!, image2: self.imgOriginal!)
        
        if chck{
            print("both images are comparetivly equal")
        }
        else{
            print("images are different")
        }
    }
    
    @IBAction func btnResetAction(_ sender: UIButton) {
        self.imgDup = self.imgOriginal
        self.imgViewMy.image = self.imgDup
    }
    
    // MARK:- Chroma Delegates
    // MARK:-

    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor){
        self.colorSel = color
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
    
    // MARK:- Check Image
    // MARK:-
    
    func compareImages(_ image1 : UIImage, image2 : UIImage) -> Bool{
        
        var width : CGFloat = 0
        var height : CGFloat = 0
        
        if (image1.size.width != image2.size.width) || (image1.size.height != image2.size.height){
            
            print("image size does not matched !!!!!!!!!!")
            
            return false
        
        }
        else{
            width = image1.size.width
            height = image1.size.height
        }
        
        var numDifferences: Float = 0.0
        var totalCompares: Float = Float(width * height / 100.0)
        var yCoord : CGFloat = 0
        
        while yCoord < height {
            var xCoord :CGFloat = 0
            while xCoord < width {
                
                var img1RGB = image1.getPixelColor(pos: CGPoint(x: xCoord, y: yCoord))
                var img2RGB = image2.getPixelColor(pos: CGPoint(x: xCoord, y: yCoord))
                
                if abs(img1RGB[0] - img2RGB[0]) > 25 ||
                    abs(img1RGB[1] - img2RGB[1]) > 25 ||
                    abs(img1RGB[2] - img2RGB[2]) > 25 {
                    //one or more pixel components differs by 10% or more
                    numDifferences += 1
                }
                xCoord += 10
            } // width end
            
            yCoord += 10
            
        } // height end

        if numDifferences / totalCompares <= 0.1 {
            //images are at least 90% identical 90% of the time
            return true
        }
        else {
            //images are less than 90% identical 90% of the time
            return false
        }
    
    } // Func end
    
    
}

extension UIImage {
    func getPixelColor(pos: CGPoint) -> [Int] {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        print("r : \(data[pixelInfo]), g :\(data[pixelInfo+1]), b: \(data[pixelInfo+2]))")
        
//        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
//        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
//        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
//        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
//        return UIColor(red: r, green: g, blue: b, alpha: a)
        return [Int(data[pixelInfo]), Int(data[pixelInfo+1]), Int(data[pixelInfo+2]),Int(data[pixelInfo+3])]
    }
}
