import GameplayKit

public struct AnalogData {
    public var velocity = CGPoint.zero
    public var angle = CGFloat(0)
}

public protocol GMAnalogDelegate: class {
    func analogDataUpdated(analogicData: AnalogData)
}


public class GMAnalogControl: SKSpriteNode {

    var bigStickNode : GMBigStickNode!
    
    public var data = AnalogData()
    
    var analogTouches = Set<UITouch>()
    
    var isTouching = false

    public weak var delegate: GMAnalogDelegate?
    
    public init(analogSize: CGSize, bigTexture: SKTexture, smallTexture: SKTexture) {
        
        super.init(texture: nil, color: UIColor.clear, size: analogSize)
        
        bigStickNode = GMBigStickNode(size: analogSize, bigTexture: bigTexture, smallTexture: smallTexture)
        
        bigStickNode.delegate = self
        
        self.addChild(bigStickNode)
    }

    public convenience init(analogSize: CGSize, bigTexture: SKTexture, smallTexture: SKTexture, trackingArea: CGSize) {
        
        self.init(analogSize: analogSize, bigTexture: bigTexture, smallTexture: smallTexture)
        
        self.size = trackingArea
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        self.setup()
    }

    func setup() {
        
        guard let sizeValue : Double = self.userData?.value(forKey: "Size") as? Double else{
            fatalError("The Value for key 'Size' can't be casted for Double type")
        }
        
        guard let bigTextureValue : String = self.userData?.value(forKey: "BigTexture") as? String else{
            fatalError("The Value for key 'BigTexture' can't be casted for String type")
        }
        
        guard let smallTextureValue : String = self.userData?.value(forKey: "SmallTexture") as? String else{
            fatalError("The Value for key 'SmallTexture' can't be casted for String type")
        }
        
        let bigTexture = SKTexture(imageNamed: bigTextureValue)
        let smallTexture = SKTexture(imageNamed: smallTextureValue)
        
        let size = CGSize(width: sizeValue, height: sizeValue)
        
        bigStickNode = GMBigStickNode(size: size, bigTexture: bigTexture, smallTexture: smallTexture)
    
        bigStickNode.delegate = self
        
        self.addChild(bigStickNode)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let touchPoint = touch.location(in: self.scene!)

            if self.contains(touchPoint) {
                self.analogTouches.formUnion([touch])
                
                bigStickNode.touchesBegan(analogTouches, with: event)
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    
        let analogMovedTouches = touches.intersection(analogTouches)
        
        if !analogMovedTouches.isEmpty {
            bigStickNode.touchesMoved(analogMovedTouches, with: event)
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let analogEndedTouches = touches.intersection(analogTouches)
        
        if !analogEndedTouches.isEmpty {
            bigStickNode.touchesEnded(analogEndedTouches, with: event)
        
            analogTouches.subtract(analogEndedTouches)
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        let analogicCancelledTouches = touches.intersection(analogTouches)
        
        if !analogicCancelledTouches
            .isEmpty {
            bigStickNode.touchesCancelled(analogicCancelledTouches, with: event)
        
            analogTouches.subtract(analogicCancelledTouches)
            
        }
    }
}

extension GMAnalogControl : GMBigStickNodeDelegate{
    func analogDidMoved(analog: GMBigStickNode, xValue: Float, yValue: Float) {
        data.velocity = CGPoint(x: CGFloat(xValue), y: CGFloat(yValue))
        data.angle = CGFloat(-atan2(xValue, yValue))
        
        delegate?.analogDataUpdated(analogicData: data)
    }
}
