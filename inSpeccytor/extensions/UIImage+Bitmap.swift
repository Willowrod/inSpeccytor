//
//  UIImage+Bitmap.swift
//  inSpeccytor
//
//  Created by Mike Hall on 14/12/2020.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(bitmap: Bitmap) {
        let alphaInfo = CGImageAlphaInfo.premultipliedLast
        let bytesPerPixel = MemoryLayout<Color>.stride
        let bytesPerRow = bitmap.width * bytesPerPixel

        guard let providerRef = CGDataProvider(data: Data(bytes: bitmap.pixels, count: bitmap.height * bytesPerRow) as CFData) else {
            return nil
        }

        guard let cgImage = CGImage(
            width: bitmap.width,
            height: bitmap.height,
            bitsPerComponent: 8,
            bitsPerPixel: bytesPerPixel * 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: alphaInfo.rawValue),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) else {
            return nil
        }

        self.init(cgImage: cgImage)
    }
}
