import UIKit
import SnapKit

class MultiLineGradientLabelView: UIView {

    private let gradientLayer = CAGradientLayer()
    private let label = UILabel()
    private var insets: UIEdgeInsets?
    
    init(
        frame: CGRect = .zero,
        gradient: Gradient,
        insets: UIEdgeInsets? = nil
    ) {
        self.insets = insets
        super.init(frame: frame)
        setupGradientLayer(gradient)
        setupLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }

    private func setupGradientLayer(_ gradient: Gradient) {
        gradientLayer.setup(with: gradient)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupLabel() {
        addSubview(label)
        
        // Configuração para múltiplas linhas
        label.numberOfLines = 0 // Permite linhas múltiplas
        label.lineBreakMode = .byWordWrapping // Quebra de linha por palavra
        
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(insets?.left ?? 0)
            make.right.equalToSuperview().inset(insets?.right ?? 0)
            make.top.equalToSuperview().inset(insets?.top ?? 0)
            make.bottom.equalToSuperview().inset(insets?.bottom ?? 0)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    var font: UIFont? {
        get { return label.font }
        set { label.font = newValue }
    }

    var textColor: UIColor? {
        get { return label.textColor }
        set { label.textColor = newValue }
    }

    var textAlignment: NSTextAlignment {
        get { return label.textAlignment }
        set { label.textAlignment = newValue }
    }
        
    var attributedText: NSAttributedString? {
        get { return label.attributedText }
        set { label.attributedText = newValue }
    }
}
