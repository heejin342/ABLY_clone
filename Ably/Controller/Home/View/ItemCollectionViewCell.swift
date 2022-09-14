//
//  ItemCollectionViewCell.swift
//  Ably
//
//  Created by 김희진 on 2022/09/02.
//

import UIKit
import SnapKit
import SDWebImage
import RxSwift

class ItemCollectionViewCell: UICollectionViewCell {

    var cellData: GoodsViewModel?

    var onClick: ((GoodsViewModel?) -> Void)?
    let cellDisposeBag = DisposeBag()

    var frameView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var itemImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var itemLikeButton: UIButton = {
        let button = UIButton()
        let imageIcon = UIImage(systemName: "heart")?.withTintColor(.pointColor, renderingMode: .alwaysOriginal)
        button.setImage(imageIcon, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.rx.tap.bind { [weak self] in
            guard let onClick = self?.onClick else { return }
            onClick(self?.cellData)
        }.disposed(by: cellDisposeBag)
        return button
    }()

    private lazy var saleAndPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .horizontal
        stackView.spacing = 7
        return stackView
    }()

    private lazy var itemSaleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pointColor
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "00%"
        return label
    }()

    private lazy var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "10,000"
        return label
    }()
    
    private lazy var itemDetailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
        label.text = "상품 설명"
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private lazy var newAndCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
    }()

    private lazy var itemNewChip: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.layer.borderWidth = 1.4
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private lazy var itemNewChipLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = .systemFont(ofSize: 9)
        label.text = "NEW"
        return label
    }()

    private lazy var itemBuyCntLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 11)
        label.text = "100개 구매중"
        return label
    }()
    
    private var divideView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(frameView)
        [itemImageView, saleAndPriceStackView, itemDetailLabel, newAndCountStackView, divideView, itemLikeButton].forEach{ frameView.addSubview($0) }

        setupUI()
    }
    
    func setupUI() {
        frameView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.width.equalTo(contentView.frame.width)
        }

        itemImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(20)
            $0.size.equalTo(80)
        }
        
        saleAndPriceStackView.snp.makeConstraints {
            $0.top.equalTo(itemImageView.snp.top).offset(4)
            $0.leading.equalTo(itemImageView.snp.trailing).offset(12)
            $0.height.equalTo(15)
        }
        saleAndPriceStackView.addArrangedSubview(itemSaleLabel)
        saleAndPriceStackView.addArrangedSubview(itemPriceLabel)


        itemDetailLabel.snp.makeConstraints {
            $0.top.equalTo(saleAndPriceStackView.snp.bottom).offset(8)
            $0.leading.equalTo(saleAndPriceStackView.snp.leading)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        newAndCountStackView.snp.makeConstraints {
            $0.top.equalTo(itemDetailLabel.snp.bottom).offset(20)
            $0.leading.equalTo(saleAndPriceStackView.snp.leading)
            $0.height.equalTo(16)
            $0.bottom.equalToSuperview().inset(20)
        }
        itemNewChip.addSubview(itemNewChipLabel)
        itemNewChipLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(3)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        newAndCountStackView.addArrangedSubview(itemNewChip)
        newAndCountStackView.addArrangedSubview(itemBuyCntLabel)

        divideView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        itemLikeButton.snp.makeConstraints {
            $0.top.equalTo(itemImageView.snp.top).inset(5)
            $0.trailing.equalTo(itemImageView.snp.trailing).inset(5)
            $0.size.equalTo(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.sd_setImage(with: nil)
    }

    
    func configureWithHeart(data: GoodsViewModel) {
        cellData = data
        
        itemImageView.sd_setImage(with: URL(string: data.image))
        itemPriceLabel.text = "\(data.price)".makeComma
        itemDetailLabel.text = data.name

        var discount: CGFloat = 0
        discount = round(100 - (CGFloat(data.price) * 100 / CGFloat(data.actualPrice)))
        if discount != 0 {
            saleAndPriceStackView.insertArrangedSubview(itemSaleLabel, at: 0)
        } else {
            itemSaleLabel.removeFromSuperview()
        }
        itemSaleLabel.text = "\(Int(discount))%"

        if data.isNew {
            newAndCountStackView.insertArrangedSubview(itemNewChip, at: 0)
        } else {
            itemNewChip.removeFromSuperview()
        }
        
        if data.sellCount >= 10 {
            newAndCountStackView.insertArrangedSubview(itemBuyCntLabel, at: newAndCountStackView.subviews.count)
        } else {
            itemBuyCntLabel.removeFromSuperview()
        }
        itemBuyCntLabel.text = "\(data.sellCount)".makeComma + "개 구매중"
        
        if data.isLike {
            itemLikeButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.pointColor, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            itemLikeButton.setImage(UIImage(systemName: "heart")?.withTintColor(.pointColor, renderingMode: .alwaysOriginal), for: .normal)
        }
    }
    
    func configureNoHeart(data: GoodsViewModel) {
        cellData = data
        itemLikeButton.isHidden = true
        
        itemImageView.sd_setImage(with: URL(string: data.image))
        itemPriceLabel.text = "\(data.price)".makeComma
        itemDetailLabel.text = data.name
        
        var discount: CGFloat = 0
        discount = round(100 - (CGFloat(data.price) * 100 / CGFloat(data.actualPrice)))
        if discount != 0 {
            saleAndPriceStackView.insertArrangedSubview(itemSaleLabel, at: 0)
        } else {
            itemSaleLabel.removeFromSuperview()
        }
        itemSaleLabel.text = "\(Int(discount))%"
        
        if data.isNew {
            newAndCountStackView.insertArrangedSubview(itemNewChip, at: 0)
        } else {
            itemNewChip.removeFromSuperview()
        }
        
        if data.sellCount >= 10 {
            newAndCountStackView.insertArrangedSubview(itemBuyCntLabel, at: newAndCountStackView.subviews.count)
        } else {
            itemBuyCntLabel.removeFromSuperview()
        }
        itemBuyCntLabel.text = "\(data.sellCount)".makeComma + "개 구매중"
    }
}

