//
//  BannerCollectionViewCell.swift
//  Ably
//
//  Created by 김희진 on 2022/09/02.
//

import Foundation
import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var pageLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var pageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        [imageView, pageLabelView].forEach { contentView.addSubview($0) }
        imageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        pageLabelView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(24)
            $0.width.equalTo(40)
        }
        pageLabelView.addSubview(pageLabel)
        pageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func configure(banner: Banners, totalCount: Int) {
        pageLabel.text = "\(banner.id)/\(totalCount)"
        imageView.sd_setImage(with: URL(string: banner.image))
    }
}
