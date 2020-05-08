import Foundation
import SpriteKit

public class GMMovableAnalogControl : GMAnalogControl {
    
    var isTracking = false
    
    public init(analogSize: CGSize, bigTexture: SKTexture, smallTexture: SKTexture, trackingArea: CGSize){
        
        super.init(analogSize: analogSize, bigTexture: bigTexture, smallTexture: smallTexture)
        
        self.size = trackingArea
        self.bigStickNode.alpha = 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let touchPoint = touch.location(in: self.scene!)
            
            if self.contains(touchPoint) {
                self.analogTouches.formUnion([touch])
                
                bigStickNode.position = (touches.first?.location(in: self))!
                bigStickNode.touchesBegan(analogTouches, with: event)
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let analogMovedTouches = touches.intersection(analogTouches)
        
        if !analogMovedTouches.isEmpty {
            
            bigStickNode.touchesMoved(analogMovedTouches, with: event)
            self.bigStickNode.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
            
            isTracking = true
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let analogEndedTouches = touches.intersection(analogTouches)
        
        if !analogEndedTouches.isEmpty {
            
            bigStickNode.touchesEnded(analogEndedTouches, with: event)
            analogTouches.subtract(analogEndedTouches)
        }
        
        if isTracking {
            self.bigStickNode.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
            isTracking = false
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        let analogCancelledTouches = touches.intersection(analogTouches)
        
        if !analogCancelledTouches
            .isEmpty {
            
            bigStickNode.touchesCancelled(analogCancelledTouches, with: event)
            self.run(SKAction.fadeAlpha(to: 0.1, duration: 0.2))
            analogTouches.subtract(analogCancelledTouches)
        }
    }
}
