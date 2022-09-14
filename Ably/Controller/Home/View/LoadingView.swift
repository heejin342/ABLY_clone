//
//  LoadingView.swift
//  Ably
//
//  Created by 김희진 on 2022/09/04.
//

import Foundation
import UIKit

class LoadingView: UICollectionReusableView {
    
    var loadingIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        [loadingIndicatorView].forEach{ addSubview($0) }
        loadingIndicatorView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
