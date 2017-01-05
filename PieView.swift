import Foundation
import UIKit

class PieView:UIView{
    
    var paths:Array<UIBezierPath> = Array()
    var shapeLayers:Array<CAShapeLayer> = Array()
    
    var visibleLayers:Array<Bool> = Array()
    var startAngles:Array<CGFloat> = Array()
    var slices:Array<CGFloat> = Array()
    var labels:Array<UILabel> = Array()
    
    let colors:Array<CGColor> = [UIColor(netHex: 0xE74C3C).cgColor, UIColor(netHex: 0x229954).cgColor, UIColor(netHex: 0x2471A3).cgColor]
    
    func setup(slices valueArray:Array<CGFloat>){
        
        visibleLayers.removeAll()
        
        slices = valueArray
        for _ in valueArray {
            visibleLayers.append(true)
        }
        populate()
    }
    
    func populate(){
        
        layer.sublayers?.removeAll()
        shapeLayers.removeAll()
        paths.removeAll()
        startAngles.removeAll()
        labels.removeAll()
        
        var total:CGFloat = 0.0
        var count = 0
        var visibleCount = 0
        for slice in slices {
            if !visibleLayers[count] {
                count+=1
                continue
            }
            let labelToAdd = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 22))
            labelToAdd.text = "\(Int(slice))"
            labelToAdd.textColor = .white
            labels.append(labelToAdd)
            count+=1
            total+=slice
            visibleCount+=1
        }
        if visibleCount <= 2 {
            count = 0
            visibleCount = 0
            for _ in slices {
                if !visibleLayers[count] {
                    count+=1
                    continue
                }
                startAngles.append(CGFloat.pi*CGFloat(visibleCount))
                visibleCount+=1
                count+=1
            }
        } else {
            count = 0
            visibleCount = 0
            for slice in slices {
                if !visibleLayers[count] {
                    count+=1
                    continue
                }
                if visibleCount == 0 {
                    startAngles.append(slice/total*CGFloat.pi)
                } else {
                    var temp = startAngles[visibleCount-1]
                    temp+=slices[visibleCount-1]/total*CGFloat.pi
                    temp+=slice/total*CGFloat.pi
                    startAngles.append(temp)
                }
                visibleCount+=1
                count+=1
            }
        }
        count = 0
        visibleCount = 0
        for slice in slices {
            if !visibleLayers[count] {
                count+=1
                continue
            }
            let path1 = UIBezierPath(arcCenter: CGPoint(x: frame.width/2 , y: frame.height/2), radius: frame.width/4, startAngle: startAngles[visibleCount]-0.01, endAngle: startAngles[visibleCount]+(CGFloat.pi*slice/total), clockwise: true)
            let path2 = UIBezierPath(arcCenter: CGPoint(x: frame.width/2 , y: frame.height/2), radius: frame.width/4, startAngle: startAngles[visibleCount]+0.01, endAngle: startAngles[visibleCount]-(CGFloat.pi*slice/total), clockwise: false)
            
            let x = frame.width/2 + frame.width/3 * cos(startAngles[visibleCount])
            let y = frame.height/2 + frame.width/3 * sin(startAngles[visibleCount])
            labels[visibleCount].center = CGPoint(x: x, y: y)
            addSubview(labels[visibleCount])
            
            let shapeLayer1 = CAShapeLayer()
            shapeLayer1.path = path1.cgPath
            shapeLayer1.fillColor = UIColor.clear.cgColor
            shapeLayer1.strokeColor = colors[count]
            shapeLayer1.lineWidth = frame.width/2
            let shapeLayer2 = CAShapeLayer()
            shapeLayer2.path = path2.cgPath
            shapeLayer2.fillColor = UIColor.clear.cgColor
            shapeLayer2.strokeColor = colors[count]
            shapeLayer2.lineWidth = frame.width/2
            
            let animation1 = CABasicAnimation(keyPath: "strokeEnd")
            animation1.duration = 1
            animation1.fromValue = 0
            animation1.toValue = 1
            shapeLayer1.add(animation1, forKey: "strokeEnd")
            let animation2 = CABasicAnimation(keyPath: "strokeEnd")
            animation2.duration = 1
            animation2.fromValue = 0
            animation2.toValue = 1
            shapeLayer2.add(animation2, forKey: "strokeEnd")
            
            layer.insertSublayer(shapeLayer1, below: labels[visibleCount].layer)
            layer.insertSublayer(shapeLayer2, below: labels[visibleCount].layer)
            paths.append(path1)
            paths.append(path2)
            shapeLayers.append(shapeLayer1)
            shapeLayers.append(shapeLayer2)
            count+=1
            visibleCount+=1
        }
    }
    
    func toggleSlice(_ no:Int, visible:Bool) {
        visibleLayers[no] = visible
        populate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkAndHandleTouches(touches: touches)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    func checkAndHandleTouches(touches:Set<UITouch>) {
        
        for touch in touches {
            var count = 0
            for path in paths {
                
                let tempPath = path.cgPath.copy(strokingWithWidth: frame.width/2, lineCap: CGLineCap.butt, lineJoin: CGLineJoin.round, miterLimit: 0.0)
                
                if (tempPath.contains(touch.location(in: self))) {
                    print("Tapped on number \(count) slice")
                }
                count+=1
            }
        }
    }
}
