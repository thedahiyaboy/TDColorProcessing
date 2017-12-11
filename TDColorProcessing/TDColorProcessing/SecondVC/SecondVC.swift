//
//  SecondVC.swift
//  TDColorProcessing
//
//  Created by DahiyaBoy on 09/12/17.
//  Copyright © 2017 DahiyaBoy. All rights reserved.
//

import UIKit

class SecondVC: UIViewController ,  UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate{

    
    // MARK:- Outlets
    // MARK:-
    @IBOutlet weak var imgView: UIImageView!
    
    // MARK:- Properties
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

        // Do any additional setup after loading the view.
        
        self.imgView.image = imgOriginal
        imgDup = imgOriginal
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapResponse))
        tapGestureRecognizer.delegate = self
        imgView.addGestureRecognizer(tapGestureRecognizer)
        imgView.isUserInteractionEnabled = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let pixelData = imgDup?.pixelData()
        
        
        
    }
    
    // MARK:- Btn Action
    // MARK:-

    @IBAction func btnCheckAction(_ sender: UIButton) {
        // Check image 
    }
    
    @IBAction func btnResetAction(_ sender: UIButton) {
        self.imgView.image = self.imgDup
    }
    // MARK:- Gesture
    // MARK:-
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
        let touchView = gestureRecognizer.view
        if touchView == imgView{
            let point : CGPoint = touch.location(in: imgView)
            touchedPoint = point
            return true
        }
        return false
    }
    
    func tapResponse(sender: UITapGestureRecognizer? = nil) {
        
        print("touched Point on imageview : \(touchedPoint!)")
        
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
    
    // MARK:- Scanline Methods
    // MARK:-
 
    public func getRGBAs(fromImage image: UIImage, x: Int, y: Int, count: Int) -> [UIColor] {
        
        var result = [UIColor]()
        
        // First get the image into your data buffer
        guard let cgImage = image.cgImage else {
            print("CGContext creation failed")
            return []
        }
        
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawdata = calloc(height*width*4, MemoryLayout<CUnsignedChar>.size)
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: rawdata, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("CGContext creation failed")
            return result
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Now your rawData contains the image data in the RGBA8888 pixel format.
        var byteIndex = bytesPerRow * y + bytesPerPixel * x
        
        for _ in 0..<count {
            let alpha = CGFloat(rawdata!.load(fromByteOffset: byteIndex + 3, as: UInt8.self)) / 255.0
            let red = CGFloat(rawdata!.load(fromByteOffset: byteIndex, as: UInt8.self)) / alpha
            let green = CGFloat(rawdata!.load(fromByteOffset: byteIndex + 1, as: UInt8.self)) / alpha
            let blue = CGFloat(rawdata!.load(fromByteOffset: byteIndex + 2, as: UInt8.self)) / alpha
            byteIndex += bytesPerPixel
            
            let aColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            result.append(aColor)
        }
        
        free(rawdata)
        
        return result
    }
    
}

        //  unsigned int byteIndex = (bytesPerRow * startPoint.y) + startPoint.x * bytesPerPixel;
        //  unsigned int ocolor = getColorCode(byteIndex, imageData);

extension UIImage {
    func pixelData() -> [UInt8]? {
        let size = self.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return pixelData
    }
}
