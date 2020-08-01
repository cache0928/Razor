//
//  UIView+.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/8.
//

#if canImport(UIKit)
import UIKit

extension UIView: RazorCompatible {}
extension RazorWrapper where Base: UIView {
    public var viewController: UIViewController? {
        var view: UIView? = base
        while view?.next as? UIViewController == nil {
            view = view?.superview
        }
        return view?.next as? UIViewController
    }
    
    public var snapshotImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        base.layer.render(in: context)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap
    }
    
    public func snapshotImageAfter(screenUpdates: Bool) -> UIImage? {
        guard !base.responds(to: #selector(UIView.drawHierarchy(in:afterScreenUpdates:))) else {
            return snapshotImage
        }
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        base.drawHierarchy(in: base.bounds, afterScreenUpdates: screenUpdates)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap
    }
    
    public var snapshotPDF: Data? {
        let data = NSMutableData() as CFMutableData
        guard let consumer = CGDataConsumer(data: data) else {
            return nil
        }
        guard let context = CGContext(consumer: consumer, mediaBox: &base.bounds, nil) else {
            return nil
        }
        context.beginPDFPage(nil)
        context.translateBy(x: 0, y: base.bounds.size.height)
        context.scaleBy(x: 1, y: -1)
        base.layer.render(in: context)
        context.endPDFPage()
        context.closePDF()
        return Data(data as NSMutableData)
    }
    
    public func removeAllSubviews() {
        base.subviews.forEach { $0.removeFromSuperview() }
    }
    
}
#endif
