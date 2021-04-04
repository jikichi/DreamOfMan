//
//  AvgleSearchResultsCollectionViewCell.swift
//  DreamOfMan
//
//  Created by jikichi on 2021/04/02.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class AvgleSearchResultsCollectionViewCell: UICollectionViewCell {
    var disposeBag: DisposeBag?

    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    var viewModel: AvgleVideoViewModel? {
        didSet {
            let disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else { return }
            
            viewModel.title
                .drive(self.nameLabel.rx.text)
                .disposed(by: disposeBag)
            
            viewModel.imageURL
                .drive(onNext: { [weak self] imageURL in
                    self?.avglePreviewImageView.loadImageUsingCacheWithURLStirng(urlString: imageURL)
                })
                .disposed(by: disposeBag)
            
            self.disposeBag = disposeBag
        }
    }
    
    var avglePreviewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.numberOfLines = 4
        return label
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    private func setupLayout() {
        
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.0)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.6
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        avglePreviewImageView.backgroundColor = .black
        contentView.addSubview(avglePreviewImageView)
        NSLayoutConstraint.activate([
            avglePreviewImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            avglePreviewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            avglePreviewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            avglePreviewImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.2, 1.2]
        gradientLayer.cornerRadius = 12
        
        let gradientContainerView = UIView()
        contentView.addSubview(gradientContainerView)
        gradientContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            gradientContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        gradientContainerView.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = self.bounds
        gradientLayer.frame.origin.y -= bounds.height
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel])
        stackView.axis = .vertical
        
        gradientContainerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
