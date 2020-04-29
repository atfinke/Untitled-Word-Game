//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport


let blueColor = UIColor(displayP3Red: 40 / 255, green: 80 / 255, blue: 128 / 255, alpha: 1)
let purpleColor = UIColor(displayP3Red: 70 / 255, green: 134 / 255, blue: 244 / 255, alpha: 1)
let _imageViewSize: CGFloat = 22

extension NSAttributedString {
    static func stylized(string: String, size: CGFloat, weight: UIFont.Weight) -> NSAttributedString {
        let initalFont = UIFont.systemFont(ofSize: size, weight: weight)
        guard let descriptor = initalFont.fontDescriptor.withDesign(.rounded) else {
            fatalError()
        }
        let font = UIFont(descriptor: descriptor, size: size)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        return NSAttributedString(string: string, attributes: attributes)
    }
}

class SystemImageButton: UIButton {
    
    // MARK: - Initalization -
    
    init(name: String, color: UIColor = .white) {
        guard let image = UIImage(systemName: name) else { fatalError() }
        super.init(frame: .zero)
        tintColor = color
        setImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class GameHeaderViewTopBar: UIView {
    
    // MARK: - Properties -
    
    private let backButton = SystemImageButton(name: "chevron.left.circle")
    private let quitButton = SystemImageButton(name: "xmark.circle")
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString.stylized(string: "50 Tiles Remain",
                                                           size: 18,
                                                           weight: .semibold)
        return label
    }()
    
    // MARK: - Initalization -
    
    init() {
        super.init(frame: .zero)
        addSubview(backButton)
        addSubview(quitButton)
        addSubview(label)
        
        backgroundColor = purpleColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let leading: CGFloat = directionalLayoutMargins.leading * 2
        backButton.frame = CGRect(x: leading,
                                            y: frame.height / 2 - _imageViewSize / 2,
                                            width: _imageViewSize,
                                            height: _imageViewSize)
        
        let trailing: CGFloat = directionalLayoutMargins.trailing * 2
        quitButton.frame = CGRect(x: frame.width - trailing - _imageViewSize,
                                            y: frame.height / 2 - _imageViewSize / 2,
                                            width: _imageViewSize,
                                            height: _imageViewSize)
        
        let usableLabelWidth = frame.width - backButton.frame.maxX * 2
        
        
        label.frame = CGRect(x: frame.width / 2 - usableLabelWidth / 2,
                             y: 0,
                             width: usableLabelWidth,
                             height: frame.height)
        
    }
}

class GameHeaderViewPlayerStatusView: UIView {
    
    // MARK: - Properties -
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        label.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
//        label.layer.borderWidth = 1
        return label
    }()
    
    private let tilesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
//        label.layer.borderWidth = 1
        return label
    }()
    
    // MARK: - Initalization -
    
    init(player: String) {
        super.init(frame: .zero)
        playerNameLabel.attributedText = NSAttributedString.stylized(string: player,
                                                                     size: 14,
                                                                     weight: .semibold)
        tilesLabel.attributedText = NSAttributedString.stylized(string: "7 | 7",
                                                                size: 16,
                                                                weight: .semibold)
        addSubview(playerNameLabel)
        addSubview(tilesLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let indent: CGFloat = 6
        let tilesLabelSize: CGFloat = 24
        playerNameLabel.frame = CGRect(x: 0,
                                       y: indent,
                                       width: frame.width,
                                       height: frame.height - tilesLabelSize - indent * 2)
        tilesLabel.frame = CGRect(x: 0,
                                  y: frame.height - tilesLabelSize - indent,
                                  width: frame.width,
                                  height: tilesLabelSize)
    }
}

class GameHeaderViewPlayersTurnView: UIView {
    
    // MARK: - Properties -
    
    var color: UIColor = .white {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let shapeLayer = CAShapeLayer()
    
    // MARK: - Initalization -
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        layer.addSublayer(shapeLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rect = frame
        let radius: CGFloat = rect.width / 3 / 4
        let topWidth: CGFloat = rect.width / 3 * 2
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width / 2,
                              y: 0))
        path.addLine(to: CGPoint(x: rect.width / 2 + topWidth / 2,
                                 y: 0))
        path.addArc(withCenter: CGPoint(x: rect.width / 2 + topWidth / 2,
                                        y: radius),
                    radius: radius,
                    startAngle: -CGFloat.pi / 2,
                    endAngle: 0,
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.width / 2 + topWidth / 2 + radius,
                                 y: rect.height - radius))
        path.addArc(withCenter: CGPoint(x: rect.width / 2 + topWidth / 2 + radius * 2,
                                        y: rect.height - radius),
                    radius: radius,
                    startAngle: -CGFloat.pi,
                    endAngle: -CGFloat.pi / 2 * 3,
                    clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addArc(withCenter: CGPoint(x: 0,
                                        y: rect.height - radius),
                    radius: radius,
                    startAngle: -CGFloat.pi / 2 * 3,
                    endAngle: 0,
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: radius, y: radius))
        path.addArc(withCenter: CGPoint(x: radius * 2,
                                        y: radius),
                    radius: radius,
                    startAngle: -CGFloat.pi,
                    endAngle: -CGFloat.pi / 2,
                    clockwise: true)
        path.addLine(to: CGPoint(x: rect.width / 2,
                                 y: 0))
        path.close()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor
    }
}

class GameHeaderViewPlayersView: UIView {
    
    let playerViews: [GameHeaderViewPlayerStatusView]
    
    init(players: [String]) {
        playerViews = players.map { GameHeaderViewPlayerStatusView(player: $0) }
        super.init(frame: .zero)
        playerViews.forEach { addSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (index, view) in playerViews.enumerated() {
            view.frame = frameForPlayer(index: index)
        }
    }
    
    func frameForPlayer(index: Int) -> CGRect {
        let usableWidth = frame.width
            - directionalLayoutMargins.leading
            - directionalLayoutMargins.trailing
        
        let playerWidth = usableWidth / CGFloat(playerViews.count)
        return CGRect(x: directionalLayoutMargins.leading + CGFloat(index) * playerWidth,
                      y: 0,
                      width: playerWidth,
                      height: frame.height)
    }
    
}

class GameHeaderViewStatusBar: UIView {
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString.stylized(string: "Play a word worth at least 􀁁 or 􀃷 the board",
                                                           size: 14,
                                                           weight: .medium)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(statusLabel)
        backgroundColor = blueColor
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        statusLabel.frame = bounds
    }
    
    
}



class GameHeaderView: UIView {
    
    private let topBar = GameHeaderViewTopBar()
    private let playersView: GameHeaderViewPlayersView
    private let statusBar = GameHeaderViewStatusBar()
    private let playersTurnView = GameHeaderViewPlayersTurnView()
    
    let bottomView = UIView()
    
    var playerTurnIndex = 0
    
    init(players: [String]) {
        playersView = GameHeaderViewPlayersView(players: players)
        super.init(frame: .zero)
        
        addSubview(bottomView)
        addSubview(topBar)
        addSubview(playersTurnView)
        addSubview(playersView)
        addSubview(statusBar)
        backgroundColor = purpleColor
        
        playersTurnView.color = blueColor
        bottomView.backgroundColor = .white
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.setNeedsLayout()
//            UIView.animate(withDuration: 1,
//                           delay: 0,
//                           usingSpringWithDamping: 0.80,
//                           initialSpringVelocity: 0.25,
//                           options: .beginFromCurrentState,
//                           animations: {
//                            self.playerTurnIndex += 1
//                            
//                            let color = UIColor.darkGray
//                            self.playersTurnView.color = color
//                            self.statusBar.layer.backgroundColor = color.cgColor
//
//                            self.layoutIfNeeded()
//
//
//
//
//
//            },
//                           completion: nil)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topBar.frame = CGRect(x: 0,
                              y: 0,
                              width: frame.width,
                              height: 56)
        playersView.frame = CGRect(x: 0,
                                   y: topBar.frame.maxY,
                                   width: frame.width,
                                   height: 60)
        statusBar.frame = CGRect(x: 0,
                                 y: playersView.frame.maxY,
                                 width: frame.width,
                                 height: 32)
        
        playersTurnView.frame = playersView
            .frameForPlayer(index: playerTurnIndex)
            .offsetBy(dx: 0, dy: playersView.frame.minY)
        
        
        bottomView.frame = CGRect(x: 0,
                                  y: playersView.frame.maxY,
                                  width: frame.width,
                                  height: frame.height)
    }
}

class GameFooterView: UIView {
    
    // MARK: - Properties -
    
    let bottomBar = GameHeaderViewBottomBar()
    
    // MARK: - Initalization -
    
    init() {
        super.init(frame: .zero)
        addSubview(bottomBar)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBar.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
}

class GameHeaderViewBottomBar: UIView {
    
    // MARK: - Properties -
    
    private let pickUpButton = SystemImageButton(name: "arrowtriangle.up.square.fill")
    private let playButton = SystemImageButton(name: "play.circle.fill")
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString.stylized(string: "art 􀀾 + ra 􀀼 + ti 􀀼 = 􀁆",
                                                           size: 14,
                                                           weight: .semibold)
        return label
    }()
    
    // MARK: - Initalization -
    
    init() {
        super.init(frame: .zero)
        addSubview(pickUpButton)
        addSubview(playButton)
        addSubview(label)
        
        backgroundColor = purpleColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let leading: CGFloat = directionalLayoutMargins.leading * 2
        pickUpButton.frame = CGRect(x: leading,
                                            y: frame.height / 2 - _imageViewSize / 2,
                                            width: _imageViewSize,
                                            height: _imageViewSize)
        
        let trailing: CGFloat = directionalLayoutMargins.trailing * 2
        playButton.frame = CGRect(x: frame.width - trailing - _imageViewSize,
                                            y: frame.height / 2 - _imageViewSize / 2,
                                            width: _imageViewSize,
                                            height: _imageViewSize)
        
        let usableLabelWidth = frame.width - pickUpButton.frame.maxX * 2
        
        
        label.frame = CGRect(x: frame.width / 2 - usableLabelWidth / 2,
                             y: 0,
                             width: usableLabelWidth,
                             height: frame.height)
        
        
    }
}

class MyViewController : UIViewController {
    
    
    let header = GameHeaderView(players: ["Andrew", "Maxine", "Garrett"])
    let footer = GameFooterView()
    
    override func viewDidLoad() {
        view.addSubview(header)
        view.addSubview(footer)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        header.frame = CGRect(x: 0,
                              y: 0,
                              width: view.frame.width,
                              height: 400)
        
        let height: CGFloat = 46
        footer.frame = CGRect(x: 0, y: view.frame.height - height, width: view.frame.width, height: height)
    }
}


// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
