import Foundation
import UIKit

protocol BarViewDelegate: class {
    func barTapped(_ tabNo:Int)
}

class BarView:UIView{
    
    weak var delegate:BarViewDelegate?
    
    var paths:Array<UIBezierPath> = Array()
    var shapeLayers:Array<CAShapeLayer> = Array()
    var labels:Array<UILabel> = Array()
    
    var previousValue:CGFloat = 0.0
    var currentValue:CGFloat = 0.0
    var isPreviousLarger:Bool = true
    
    let colors:Array<UIColor> = [UIColor(netHex: 0xE74C3C), UIColor(netHex: 0x229954), UIColor(netHex: 0x2471A3)]
    
    let spacingForStepLabels:CGFloat = 110
    let labelWidth:CGFloat = 120
    let labelHeight:CGFloat = 20
    
    func setup(previousValue:CGFloat, currentValue:CGFloat, previousString:String, currentString:String){
        
        self.previousValue = previousValue
        self.currentValue = currentValue
        isPreviousLarger = previousValue > currentValue
        
        populate(previousString,currentString)
    }
    
    func populate(_ previousString:String,_ currentString:String){
        
        layer.sublayers?.removeAll()
        shapeLayers.removeAll()
        paths.removeAll()
        
        var stepValue:CGFloat = 0
        var upperLimit:CGFloat = 0
        var numberOfSteps:CGFloat = 10
        
        var digitCount:Int = 0
        var multiplier:CGFloat = 100
        
        if isPreviousLarger {   //Determine which value to use to calculate maximum
            digitCount = "\(Int(previousValue))".characters.count
            if digitCount > 3 { //Minimum rounded to closest hundred
                digitCount-=3
                for _ in 0..<digitCount{ //This loop is multiplier*10e
                    multiplier*=10
                }
            }
            //Round the upper limit to the next multiple
            upperLimit = previousValue+multiplier-(previousValue.truncatingRemainder(dividingBy: multiplier))
            let firstDigit:Int = Int(upperLimit/multiplier)
            if firstDigit != 1 && firstDigit != 2 && firstDigit != 5 {
                upperLimit = ((upperLimit/(multiplier*5)).rounded(.up))*multiplier*5
            }
            stepValue = upperLimit/numberOfSteps
            let unusedValueSpace = upperLimit-previousValue
            if unusedValueSpace > stepValue {
                let extraSteps = CGFloat(Int(unusedValueSpace/stepValue))
                numberOfSteps-=extraSteps
                upperLimit-=extraSteps*stepValue
            }
        } else {
            digitCount = "\(Int(currentValue))".characters.count
            if digitCount > 3 {
                digitCount-=3
                for _ in 0..<digitCount{
                    multiplier*=10
                }
            }
            upperLimit = currentValue+multiplier-(currentValue.truncatingRemainder(dividingBy: multiplier))
            let firstDigit:Int = Int(upperLimit/multiplier)
            if firstDigit != 1 && firstDigit != 2 && firstDigit != 5 {
                upperLimit = ((upperLimit/(multiplier*5)).rounded(.up))*multiplier*5
            }
            stepValue = upperLimit/numberOfSteps
            let unusedValueSpace = upperLimit-currentValue
            if unusedValueSpace > stepValue {
                let extraSteps = CGFloat(Int(unusedValueSpace/stepValue))
                numberOfSteps-=extraSteps
                upperLimit-=extraSteps*stepValue
            }
        }
        let graphBase = bounds.height-labelHeight
        
        let previousBarXPos = (bounds.width-spacingForStepLabels)/4
        let previousBarYPos = graphBase*previousValue/upperLimit
        let previousBar = UIBezierPath()
        previousBar.move(to: CGPoint(x: previousBarXPos+spacingForStepLabels, y: graphBase))
        previousBar.addLine(to: CGPoint(x: previousBarXPos+spacingForStepLabels,
                                        y: graphBase-previousBarYPos))
        let previousLayer = CAShapeLayer()
        previousLayer.path = previousBar.cgPath
        previousLayer.lineWidth = (bounds.width-spacingForStepLabels)/2
        previousLayer.fillColor = UIColor.clear.cgColor
        previousLayer.strokeColor = colors[0].cgColor
        layer.addSublayer(previousLayer)
        let previousLabel = UILabel(frame: CGRect(x: previousBarXPos+spacingForStepLabels-labelWidth/2,
                                                  y: graphBase-labelHeight,
                                                  width: labelWidth, height: labelHeight))
        previousLabel.text = previousValue.currency
        previousLabel.textColor = colors[0]
        previousLabel.textAlignment = .center
        addSubview(previousLabel)
        let previousStringLabel = UILabel(frame: CGRect(x: previousBarXPos+spacingForStepLabels-labelWidth/2,
                                                      y: graphBase,
                                                      width: labelWidth, height: labelHeight))
        previousStringLabel.text = previousString
        previousStringLabel.textColor = colors[0]
        previousStringLabel.textAlignment = .center
        addSubview(previousStringLabel)
        let previousAnimation = CABasicAnimation(keyPath: "strokeEnd")
        previousAnimation.duration = 2
        previousAnimation.fromValue = 0
        previousAnimation.toValue = 1
        previousLayer.add(previousAnimation, forKey: "strokeEnd")
        UIView.animate(withDuration: 2, delay: 0, options: .curveLinear, animations: {
            previousLabel.frame = CGRect(x: previousLabel.frame.origin.x,
                                         y: previousLabel.frame.origin.y-previousBarYPos,
                                         width: previousLabel.frame.width, height: previousLabel.frame.height)
        }, completion: nil)
        paths.append(previousBar)
        shapeLayers.append(previousLayer)
        labels.append(previousLabel)
        
        let currentBarXPos = (bounds.width-spacingForStepLabels)/4*3
        let currentBarYPos = graphBase*currentValue/upperLimit
        let currentBar = UIBezierPath()
        currentBar.move(to: CGPoint(x: currentBarXPos+spacingForStepLabels, y: graphBase))
        currentBar.addLine(to: CGPoint(x: currentBarXPos+spacingForStepLabels,
                                       y: graphBase-currentBarYPos))
        let currentLayer = CAShapeLayer()
        currentLayer.path = currentBar.cgPath
        currentLayer.lineWidth = (bounds.width-spacingForStepLabels)/2
        currentLayer.fillColor = UIColor.clear.cgColor
        currentLayer.strokeColor = colors[1].cgColor
        layer.addSublayer(currentLayer)
        let currentLabel = UILabel(frame: CGRect(x: currentBarXPos+spacingForStepLabels-labelWidth/2,
                                                 y: graphBase-labelHeight,
                                                 width: labelWidth, height: labelHeight))
        currentLabel.text = currentValue.currency
        currentLabel.textColor = colors[1]
        currentLabel.textAlignment = .center
        addSubview(currentLabel)
        let currentStringLabel = UILabel(frame: CGRect(x: currentBarXPos+spacingForStepLabels-labelWidth/2,
                                                     y: graphBase,
                                                     width: labelWidth, height: labelHeight))
        currentStringLabel.text = currentString
        currentStringLabel.textColor = colors[1]
        currentStringLabel.textAlignment = .center
        addSubview(currentStringLabel)
        let currentAnimation = CABasicAnimation(keyPath: "strokeEnd")
        currentAnimation.duration = 2
        currentAnimation.fromValue = 0
        currentAnimation.toValue = 1
        currentLayer.add(currentAnimation, forKey: "strokeEnd")
        UIView.animate(withDuration: 2, delay: 0, options: .curveLinear, animations: {
            currentLabel.frame = CGRect(x: currentLabel.frame.origin.x,
                                        y: currentLabel.frame.origin.y-currentBarYPos,
                                        width: currentLabel.frame.width, height: currentLabel.frame.height)
        }, completion: nil)
        paths.append(currentBar)
        shapeLayers.append(currentLayer)
        labels.append(currentLabel)
        
        let xAxisLine = UIBezierPath()
        xAxisLine.move(to: CGPoint(x: spacingForStepLabels, y: graphBase))
        xAxisLine.addLine(to: CGPoint(x: bounds.width, y: graphBase))
        let xAxisLayer = CAShapeLayer()
        xAxisLayer.path = xAxisLine.cgPath
        xAxisLayer.lineWidth = 2
        xAxisLayer.fillColor = UIColor.clear.cgColor
        xAxisLayer.strokeColor = UIColor.black.cgColor
        layer.addSublayer(xAxisLayer)
        
        let yAxisLine = UIBezierPath()
        yAxisLine.move(to: CGPoint(x: spacingForStepLabels, y: 0))
        yAxisLine.addLine(to: CGPoint(x: spacingForStepLabels, y: graphBase))
        let yAxisLayer = CAShapeLayer()
        yAxisLayer.path = yAxisLine.cgPath
        yAxisLayer.lineWidth = 2
        yAxisLayer.fillColor = UIColor.clear.cgColor
        yAxisLayer.strokeColor = UIColor.black.cgColor
        layer.addSublayer(yAxisLayer)
        
        for i in 0..<Int(numberOfSteps+1){
            let markingLine = UIBezierPath()
            markingLine.move(to: CGPoint(x: spacingForStepLabels, y: graphBase/numberOfSteps*CGFloat(i)))
            markingLine.addLine(to: CGPoint(x: spacingForStepLabels-5, y: graphBase/numberOfSteps*CGFloat(i)))
            
            let markingLayer = CAShapeLayer()
            markingLayer.path = markingLine.cgPath
            markingLayer.lineWidth = 1
            markingLayer.fillColor = UIColor.clear.cgColor
            markingLayer.strokeColor = UIColor.black.cgColor
            
            layer.addSublayer(markingLayer)
            
            let markingNumber = UILabel(frame: CGRect(x: 5, y: graphBase/numberOfSteps*CGFloat(i)-10,
                                                      width: spacingForStepLabels-10, height: labelHeight))
            markingNumber.textAlignment = .right
            markingNumber.text = "\((upperLimit-stepValue*CGFloat(i)).currency.components(separatedBy: ".")[0])"
            
            addSubview(markingNumber)
        }
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
                    if count == 0 {
                        delegate?.barTapped(0)
                    } else {
                        delegate?.barTapped(1)
                    }
                }
                count+=1
            }
        }
    }
}
