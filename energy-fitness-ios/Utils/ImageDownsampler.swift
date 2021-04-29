//
//  ImageDownsampler.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/03/2021.
//

import UIKit
import ImageIO

struct ImageDownsampler {
    
    
    /// Downsampling image
    ///
    ///
    /// Useful when downloaded image is has bit pixel size (3648px × 5472px)
    /// as UIImage allocates the memory of 4 bytes for every pixel (1 byte for red, 1 byte for green,
    /// 1 byte for blue, and 1 byte for the alpha component).
    ///
    /// Therefore, (3648 * 5472) * 4 bytes ≈ 80MB
    ///
    /// An example of using downsampling
    ///
    ///     let filePath = Bundle.main.url(forResource: "downloadedPictureName", withExtension: "jpg")!
    ///     let downsampledImage = downsample(imageAt: filePath, to: imageView.bounds.size)
    ///     imageView.image = downsampleImage
    ///
    /// - Parameters:
    ///   - imageURL: url of downloaded photo (or one in the Bundle)
    ///   - pointSize: size to which it will be sampled
    ///   - scale: scale (default is UIScreen.main.scale)
    /// - Returns: Optional image
    func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        
        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            return nil
        }
        
        // Calculate the desired dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        
        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        // Return the downsampled image as UIImage
        return UIImage(cgImage: downsampledImage)
    }
}
