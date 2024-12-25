//
//  Extensions.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 5.11.2024.
//

import Foundation
import UIKit
import SDWebImage


extension String {
    
    func capitalizaFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

extension String {
    
    func toViewWidth(font : UIFont) -> CGFloat {
        return self.size(withAttributes: [.font: font]).width
    }
    
    func toViewHeight(font : UIFont) -> CGFloat {
        return self.size(withAttributes: [.font: font]).height
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        self.sd_setImage(with: url,completed: nil)
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension UINavigationController {
    
    func navigateToPreview3(with movie : Movie){
        
        DispatchQueue.main.async { [weak self] in
            let moviePreviewController = MainPreviewViewController()
            moviePreviewController.configure(movie: movie)
            self?.pushViewController(moviePreviewController, animated: true)
        }
    }
}

extension UIViewController {
    
    func navigateToPreview(with movie : Movie){
        DispatchQueue.main.async { [weak self] in
            let moviePreviewController = MainPreviewViewController()
            moviePreviewController.configure(movie: movie)
            self?.present(moviePreviewController, animated: true)
        }
    }
    
    
    func showNetworkErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            // Retry the network request here
            //self.fetchDataFromAPI()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // Present the alert in your view controller
       
        self.present(alert, animated: true, completion: nil)
        
    }
}


// Key for storing the closure in associated objects
private var tapGestureKey: UInt8 = 0

extension UIView {
    
    // Add a tap gesture recognizer with a closure
    func addTapGesture(action: @escaping () -> Void) {
        // Create the tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        // Attach the gesture recognizer to the view
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        
        // Store the closure in the associated object
        objc_setAssociatedObject(self, &tapGestureKey, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    // Handle the tap gesture
    @objc private func handleTap() {
        // Retrieve the closure associated with the view
        if let action = objc_getAssociatedObject(self, &tapGestureKey) as? () -> Void {
            action()  // Call the closure
        }
    }
    
}


