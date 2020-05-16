////
////  Component.swift
////  wwdc2020
////
////  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
////  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
////
//
//import SpriteKit
//
//class JoystickComponent: SKSpriteNode {
//    private var context = UInt8(1)
//
//    public var image: UIImage? {
//        didSet {
//            redrawTexture()
//        }
//    }
//
//    public var diameter: CGFloat {
//        get { return size.width }
//        set { size = CGSize(width: newValue, height: newValue) }
//    }
//
//    open override var size: CGSize {
//        get { return super.size }
//
//        set {
//            let maxValue = max(newValue.width, newValue.height)
//            super.size.width = maxValue
//            super.size.height = maxValue
//        }
//    }
//
//    public var radius: CGFloat {
//        get { return diameter / 2 }
//        set { diameter = newValue * 2 }
//    }
//
//    init(diameter: CGFloat, color: UIColor? = nil, image: UIImage? = nil) {
//        let pureColor = color ?? UIColor.black
//        let size = CGSize(width: diameter, height: diameter)
//        super.init(texture: nil, color: pureColor, size: size)
//
//        self.diameter = diameter
//        self.image = image
//
//        addObserver(self, forKeyPath: "color", options: NSKeyValueObservingOptions.old, context: &context)
//        redrawTexture()
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    deinit {
//        removeObserver(self, forKeyPath: "color")
//    }
//
//    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        if keyPath == "color" {
//            redrawTexture()
//        }
//    }
//
//    private func redrawTexture() {
//        let scale = UIScreen.main.scale
//        let needSize = CGSize(width: diameter, height: diameter)
//
//        UIGraphicsBeginImageContextWithOptions(needSize, false, scale)
//        let rectPath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: needSize))
//        rectPath.addClip()
//
//        if let img = image {
//            img.draw(in: CGRect(origin: .zero, size: needSize), blendMode: .normal, alpha: 1)
//        } else {
//            color.set()
//            rectPath.fill()
//        }
//
//        let textureImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//
//        texture = SKTexture(image: textureImage)
//    }
//}
