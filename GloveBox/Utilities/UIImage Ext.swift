import UIKit

extension UIImage {
    func rewrite(scale: CGFloat = 0.3, quality: CGFloat = 0.3) -> UIImage {
        let newSize = CGSize(
            width: self.size.width * scale,
            height: self.size.height * scale
        )
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let data = resizedImage?.jpegData(compressionQuality: quality) ?? Data()
        
        return UIImage(data: data) ?? UIImage()
    }
}
