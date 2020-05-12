//
//  Joystick.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

public enum JoystickEventType {
    case begin
    case move
    case end
}

fileprivate let getHandlerID: () -> String = {
    var counter = 0

    return {
        counter += 1
        return "sbscrbr_\(counter)"
    }()
}

fileprivate func getDiameter(from diameter: CGFloat, withRatio ratio: CGFloat) -> CGFloat {
    return diameter * abs(ratio)
}

class Joystick: SKNode {
    var moveable = false
    fileprivate let handle: JoystickComponent
    fileprivate let base: JoystickComponent

    private var pHandleRatio: CGFloat
    private var displayLink: CADisplayLink!
    private var handlers = [JoystickEventType: [String: (Joystick) -> Void]]()
    private var handlerIDsRelEvent = [String: JoystickEventType]()
    private(set) var isTracking = false {
        didSet {
            guard oldValue != isTracking else {
                return
            }

            let loopMode = RunLoop.Mode.common

            if isTracking {
                displayLink.add(to: .current, forMode: loopMode)
                runEvent(.begin)
            } else {
                displayLink.remove(from: .current, forMode: loopMode)
                runEvent(.end)
                let resetAction = SKAction.move(to: .zero, duration: 0.1)
                resetAction.timingMode = .easeOut
                handle.run(resetAction)
            }
        }
    }

    public var velocity: CGPoint {
        let diff = handle.diameter * 0.02
        return CGPoint(x: handle.position.x / diff, y: handle.position.y / diff)
    }

    public var angular: CGFloat {
        let velocity = self.velocity
        return -atan2(velocity.x, velocity.y)
    }

    public var disabled: Bool {
        get { return !isUserInteractionEnabled }

        set {
            isUserInteractionEnabled = !newValue

            if newValue {
                stop()
            }
        }
    }

    public var handleRatio: CGFloat {
        get { return pHandleRatio }

        set {
            pHandleRatio = newValue
            handle.diameter = getDiameter(from: base.diameter, withRatio: newValue)
        }
    }

    public var diameter: CGFloat {
        get { return max(base.diameter, handle.diameter) }

        set {
            let diff = newValue - diameter
            base.diameter += diff
            handle.diameter += diff
        }
    }

    public var radius: CGFloat {
        get { return max(base.radius, handle.radius) }
        set {
            let diff = newValue - radius
            base.radius += diff
            handle.radius += diff
        }
    }

    private init(withBase base: JoystickComponent, handle: JoystickComponent) {
        self.base = base
        self.handle = handle
        self.pHandleRatio = handle.diameter / base.diameter
        super.init()

        disabled = false
        displayLink = CADisplayLink(target: self, selector: #selector(listen))
        handle.zPosition = base.zPosition + 1

        addChild(base)
        addChild(handle)
    }

    deinit {
        displayLink.invalidate()
    }

    convenience init(withDiameter diameter: CGFloat, handleRatio: CGFloat = 0.6) {
        let base = JoystickComponent(diameter: diameter, color: .gray)
        let handleDiameter = getDiameter(from: diameter, withRatio: handleRatio)
        let handle = JoystickComponent(diameter: handleDiameter, color: .black)
        self.init(withBase: base, handle: handle)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func getEventHandlers(forType type: JoystickEventType) -> [String: (Joystick) -> Void] {
        return handlers[type] ?? [String: (Joystick) -> Void]()
    }

    private func runEvent(_ type: JoystickEventType) {
        let handlers = getEventHandlers(forType: type)

        handlers.forEach { _, handler in
            handler(self)
        }
    }

    @discardableResult
    public func on(_ event: JoystickEventType, _ handler: @escaping (Joystick) -> Void) -> String {
        let handlerID = getHandlerID()
        var currHandlers = getEventHandlers(forType: event)
        currHandlers[handlerID] = handler
        handlerIDsRelEvent[handlerID] = event
        handlers[event] = currHandlers

        return handlerID
    }

    public func off(handlerID: String) {
        if let event = handlerIDsRelEvent[handlerID] {
            var currHandlers = getEventHandlers(forType: event)
            currHandlers.removeValue(forKey: handlerID)
            handlers[event] = currHandlers
        }

        handlerIDsRelEvent.removeValue(forKey: handlerID)
    }

    public func stop() {
        isTracking = false
    }

    @objc
    func listen() {
        runEvent(.move)
    }

}

// MARK: - Touches Extension
extension Joystick {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!

        guard handle == atPoint(touch.location(in: self)) else { return }

        isTracking = true
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isTracking else {
            return
        }

        let touch = touches.first!
        let location = touch.location(in: self)
        let baseRadius = base.radius
        let distance = sqrt(pow(location.x, 2) + pow(location.y, 2))
        let distanceDiff = distance - baseRadius

        if distanceDiff > 0 {
            let handlePosition = CGPoint(x: location.x / distance * baseRadius, y: location.y / distance * baseRadius)
            handle.position = handlePosition

            if moveable {
                position.x += location.x - handlePosition.x
                position.y += location.y - handlePosition.y
            }
        } else {
            handle.position = location
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTracking = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTracking = false
    }
}
