//
//  UIView+.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/8.
//

#if os(iOS)
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
}
#endif
