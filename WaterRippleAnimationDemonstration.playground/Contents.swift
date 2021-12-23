//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class waveView: UIView {
    private var context: CGContext? = nil
    private var displayLink: CADisplayLink? = nil
    private var startTime = 0.0
    private let animationLength = 5.0
    private var percent: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        context = UIGraphicsGetCurrentContext()
        waveStokeDraw(in: context!, rect, percent: percent)
        wavePathDraw(in: context!, rect, percent: percent)
    }
    
    func waveStokeDraw(in ctx: CGContext,_ rect: CGRect, percent: CGFloat) {
        var yPosition = 0.0
        for xPosition in 0..<Int(rect.size.width) {
            yPosition = Double(10 * cos((CGFloat(xPosition) / 180 * .pi) + 2 * .pi * percent) + 30)
            if xPosition == 0 {
                ctx.move(to: CGPoint(x: 0, y: yPosition))
            } else {
                ctx.addLine(to: CGPoint(x: Double(xPosition),
                                        y: yPosition))
            }
        }
        UIColor.blue.setStroke()
        ctx.strokePath()
    }
    
    func wavePathDraw(in ctx: CGContext,_ rect: CGRect, percent: CGFloat) {
        ctx.move(to: CGPoint(x: 0, y: 20))
        var yPosition = 0.0
        for xPosition in 0..<Int(rect.size.width) {
            yPosition = Double(10 * cos((CGFloat(xPosition) / 180 * .pi) + 2 * .pi * percent) + 30)
            ctx.addLine(to: CGPoint(x: Double(xPosition),
                                    y: yPosition))
        }
        
        ctx.addLine(to: CGPoint(x: rect.width,
                                y: rect.height))
        ctx.addLine(to: CGPoint(x: 0,
                                y: rect.height))
        ctx.addLine(to: CGPoint(x: 0,
                                y: yPosition))
        ctx.setAlpha(0.15)
        UIColor.blue.setFill()
        ctx.closePath()
        ctx.fillPath()
        UIGraphicsPopContext()
    }
    
    func startDisplayLink() {
        stopDisplayLink()
        self.displayLink = CADisplayLink(target: self,
                                         selector:#selector(displayLinkDidFire))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc func displayLinkDidFire(_ displayLink: CADisplayLink) {
        if percent == 1 {
            percent = 0
        } else {
            percent = percent + 0.02
        }
        setNeedsDisplay()
    }
    
    func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = waveView(frame: CGRect(x: 0, y: 0, width: 320, height: 640))
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = view as? waveView {
            view.startDisplayLink()
        }
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
