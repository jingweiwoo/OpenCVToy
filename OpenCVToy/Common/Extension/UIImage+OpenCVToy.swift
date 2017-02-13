//
//  UIImage+OpenCVToy.swift
//  OpenCVToy
//
//  Created by Jingwei Wu on 10/02/2017.
//  Copyright © 2017 jingweiwu. All rights reserved.
//

import Foundation
import ImageIO

extension UIImage {
    
    func resizeToTargetSize(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        let scale = UIScreen.main.scale
        let newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: scale * floor(size.width * heightRatio), height: scale * floor(size.height * heightRatio))
        } else {
            newSize = CGSize(width: scale * floor(size.width * widthRatio), height: scale * floor(size.height * widthRatio))
        }
        
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: floor(newSize.width), height: floor(newSize.height)))
        
        //println("size: \(size), newSize: \(newSize), rect: \(rect)")
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func scaleToMinSideLength(sideLength: CGFloat) -> UIImage {
        
        let pixelSideLength = sideLength * UIScreen.main.scale
        
        //println("pixelSideLength: \(pixelSideLength)")
        //println("size: \(size)")
        
        let pixelWidth = size.width * scale
        let pixelHeight = size.height * scale
        
        //println("pixelWidth: \(pixelWidth)")
        //println("pixelHeight: \(pixelHeight)")
        
        let newSize: CGSize
        
        if pixelWidth > pixelHeight {
            
            guard pixelHeight > pixelSideLength else {
                return self
            }
            
            let newHeight = pixelSideLength
            let newWidth = (pixelSideLength / pixelHeight) * pixelWidth
            newSize = CGSize(width: floor(newWidth), height: floor(newHeight))
            
        } else {
            
            guard pixelWidth > pixelSideLength else {
                return self
            }
            
            let newWidth = pixelSideLength
            let newHeight = (pixelSideLength / pixelWidth) * pixelHeight
            newSize = CGSize(width: floor(newWidth), height: floor(newHeight))
        }
        
        if scale == UIScreen.main.scale {
            let newSize = CGSize(width: floor(newSize.width / scale), height: floor(newSize.height / scale))
            //println("A scaleToMinSideLength newSize: \(newSize)")
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))
            self.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let image = newImage {
                return image
            }
            
            return self
            
        } else {
            //println("B scaleToMinSideLength newSize: \(newSize)")
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))
            self.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let image = newImage {
                return image
            }
            
            return self
        }
    }
    
    func fixRotation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        let width = self.size.width
        let height = self.size.height
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
            transform = transform.rotated(by: CGFloat(M_PI))
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
            
        default:
            break
        }
        
        let selfCGImage = self.cgImage
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: selfCGImage!.bitsPerComponent, bytesPerRow: 0, space: selfCGImage!.colorSpace!, bitmapInfo: selfCGImage!.bitmapInfo.rawValue);
        
        context!.concatenate(transform)
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context!.draw(selfCGImage!, in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: height, height: width)))
        default:
            context!.draw(selfCGImage!, in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: width, height: height)))
        }
        
        let cgImage = context!.makeImage()!
        return UIImage(cgImage: cgImage)
    }
    
    func compress(imageQuality quality: CGFloat = 0.1) -> UIImage {
        let compressedData = UIImageJPEGRepresentation(self, quality)
        return UIImage.init(data: compressedData!)!
    }
    
    func scaleToRatio(ratio: CGFloat = 0.5) -> UIImage {        
        let image = self
        UIGraphicsBeginImageContext(CGSize(width: image.size.width * ratio, height: image.size.height * ratio))
        image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: image.size.width * ratio, height: image.size.height * ratio)))
        let scaledImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func clip(byRect rect: CGRect) -> UIImage {
        let img: CGImage = self.cgImage!.cropping(to: rect)!
        let smallBounds = CGRect(x: 0, y: 0, width: img.width - 6, height: img.height - 6)
        
        UIGraphicsBeginImageContext(smallBounds.size)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(img, in: smallBounds)
        
        let dealedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return dealedImage;
    }
    
    func clips(byRects rects: [CGRect]) -> [UIImage] {
        var images: [UIImage] = []
        guard rects.count > 0 else {
            return images
        }
        
        for rect in rects {
            images.append(self.clip(byRect: rect))
        }
        return images
    }
    
    class func draw(rects: [CGRect], scaleRatio ratio: CGFloat, onImage img: UIImage) -> UIImage {
        guard rects.count > 0 else {
            return img
        }
        
        let image = img
        UIGraphicsBeginImageContext(CGSize(width: image.size.width, height: image.size.height))
        image.draw(in: CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
        let context = UIGraphicsGetCurrentContext()!
        context.beginPath()
        context.setLineWidth(4.0)
        context.setStrokeColor(UIColor.green.cgColor)
        context.addRects(rects)
        context.strokePath()
        
        let dealedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return dealedImage
    }
}


