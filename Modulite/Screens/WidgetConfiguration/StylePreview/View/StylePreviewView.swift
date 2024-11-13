//
//  StylePreviewView.swift
//  Modulite
//
//  Created by André Wozniack on 30/10/24.
//

import UIKit
import SnapKit
import WidgetStyling

class StylePreviewView: UIView {
    
    var onSelectStylePressed: (() -> Void)?
    var updateSelectedStyleIndex: ((_ index: Int) -> Void)?
    
    // MARK: - Subviews
    private(set) lazy var styleName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        return collectionView
    }()
    
    private(set) lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 3
        control.currentPage = 0
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .black
        control.addTarget(self, action: #selector(didChangePageControl), for: .valueChanged)
        return control
    }()
    
    private(set) lazy var useButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .fiestaGreen.resolvedColor(
            with: .init(userInterfaceStyle: .light)
        )
        config.attributedTitle = AttributedString(
            "USE THIS STYLE",
            attributes: AttributeContainer([
                .font: UIFont(textStyle: .title2, weight: .bold),
                .foregroundColor: UIColor.white
            ])
        )
        
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(didPressUseButton), for: .touchUpInside)
        
        return view
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteTurnip
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func addSubviews() {
        addSubview(styleName)
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(useButton)
    }
    
    private func setupConstraints() {
        styleName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(styleName.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        useButton.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.bottom.equalToSuperview().offset(-60)
        }
    }
    
    func configure(with style: WidgetStyle) {
        styleName.text = style.name
    }
    
    // MARK: - Actions
    
    @objc func didPressUseButton() {
        onSelectStylePressed?()
    }
    
    @objc func didChangePageControl() {
        let pageIndex = pageControl.currentPage
        let currentOffset = collectionView.contentOffset.x / collectionView.frame.width
        let animated = abs(currentOffset - CGFloat(pageIndex)) == 1

        let offsetX = CGFloat(pageIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }
}
