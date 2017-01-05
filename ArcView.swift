import Foundation
import UIKit

class ArcView: UIView {
    
    var path = UIBezierPath()
    let shapeLayer = CAShapeLayer()
    
    func setup(){
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.width/2 , y: frame.height), radius: frame.width/3, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
        
        let baseShapeLayer = CAShapeLayer()
        baseShapeLayer.path = path.cgPath
        baseShapeLayer.fillColor = UIColor.clear.cgColor
        baseShapeLayer.strokeColor = UIColor.lightGray.cgColor
        baseShapeLayer.lineWidth = frame.width/3
        
        layer.addSublayer(baseShapeLayer)
    }
    
    func populate(percentage:CGFloat){
        
        path = UIBezierPath(arcCenter: CGPoint(x: frame.width/2 , y: frame.height), radius: frame.width/3, startAngle: CGFloat.pi, endAngle: CGFloat.pi+(CGFloat.pi*(percentage/100)), clockwise: true)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(netHex: 0xFF0000).cgColor
        shapeLayer.lineWidth = frame.width/3
        
        //Codes to support gradient
        /*let gradient = CAGradientLayer()
        gradient.colors = [UIColor(netHex: 0xE74C3C).cgColor, UIColor(netHex: 0x229954).cgColor, UIColor(netHex: 0x2471A3).cgColor]
        gradient.locations = [0.0,0.5,1.0]
        gradient.mask = shapeLayer
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = bounds*/
        
        layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.beginTime = 0
        animation.duration = Double(Int(percentage/30)+1)
        animation.fromValue = 0
        animation.toValue = 1
        
        let animation2 = CABasicAnimation(keyPath: "strokeColor")
        animation2.beginTime = 0
        animation2.duration = 1
        animation2.fromValue = UIColor(netHex: 0xFF0000).cgColor
        animation2.toValue = UIColor(netHex: 0xFF0000).cgColor
        
        let group = CAAnimationGroup()
        var animationArray:Array<CAAnimation> = Array()
        animationArray.append(animation)
        animationArray.append(animation2)
        
        if percentage > 30 {
            
            let animation3 = CABasicAnimation(keyPath: "strokeColor")
            animation3.beginTime = 1
            animation3.duration = 1
            animation3.fromValue = UIColor(netHex: 0xFF0000).cgColor
            animation3.toValue = UIColor(netHex: 0xF97600).cgColor
            
            shapeLayer.strokeColor = UIColor(netHex: 0xF97600).cgColor
            animationArray.append(animation3)
        }
        if percentage > 60 {
            
            let animation4 = CABasicAnimation(keyPath: "strokeColor")
            animation4.beginTime = 2
            animation4.duration = 1
            animation4.fromValue = UIColor(netHex: 0xF97600).cgColor
            animation4.toValue = UIColor(netHex: 0xF6C600).cgColor
            
            shapeLayer.strokeColor = UIColor(netHex: 0xF6C600).cgColor
            animationArray.append(animation4)
            
        }
        if percentage > 90 {
            
            let animation5 = CABasicAnimation(keyPath: "strokeColor")
            animation5.beginTime = 3
            animation5.duration = 1
            animation5.fromValue = UIColor(netHex: 0xF6C600).cgColor
            animation5.toValue = UIColor(netHex: 0x60B044).cgColor
            
            shapeLayer.strokeColor = UIColor(netHex: 0x60B044).cgColor
            animationArray.append(animation5)
            
        }
        shapeLayer.path = path.cgPath
        group.animations = animationArray
        group.isRemovedOnCompletion = false
        group.duration = 6
        shapeLayer.add(group, forKey: "strokeEnd")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkAndHandleTouches(touches: touches)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkAndHandleTouches(touches: touches)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        shapeLayer.removeAllAnimations()
        shapeLayer.lineWidth = frame.width/3
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        shapeLayer.add(animation, forKey: "strokeEnd")
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        shapeLayer.removeAllAnimations()
        shapeLayer.lineWidth = frame.width/3
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        shapeLayer.add(animation, forKey: "strokeEnd")
    }
    func checkAndHandleTouches(touches:Set<UITouch>) {
        
        var isTouching = false
        for touch in touches {
            
            let path = shapeLayer.path?.copy(strokingWithWidth: frame.width/3, lineCap: CGLineCap.butt, lineJoin: CGLineJoin.round, miterLimit: 0.0)
            
            if (path?.contains(touch.location(in: self)))! {
                isTouching = true
                shapeLayer.removeAllAnimations()
                shapeLayer.lineWidth = frame.width/3+5.0
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.duration = 1.0
                shapeLayer.add(animation, forKey: "strokeEnd")
            }
        }
        if !isTouching {
            shapeLayer.removeAllAnimations()
            shapeLayer.lineWidth = frame.width/3
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 1.0
            shapeLayer.add(animation, forKey: "strokeEnd")
        }
    }
}
