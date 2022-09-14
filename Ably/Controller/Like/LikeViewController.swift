//
//  LikeViewController.swift
//  Ably
//
//  Created by 김희진 on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa
import Realm
import RealmSwift

class LikeViewController: UIViewController {

    let disposeBag = DisposeBag()
    var viewModel = LikeViewModel()
    
    let likeView = LikeView()
    lazy var likeCollectionView = likeView.makeCollectionView()
    lazy var emptyLabel = likeView.makeEmptyLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI(viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.populateData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(likeCollectionView)
        likeCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "좋아요"
        likeCollectionView.delegate = self
        likeCollectionView.dataSource = self
    }
    
    func bindUI(_ viewModel: LikeViewModel) {
        viewModel.likeListArray
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { data in
                self.likeCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.likeListisEmpty.subscribe(onNext: {
            if $0 {
                self.likeCollectionView.addSubview(self.emptyLabel)
                self.emptyLabel.snp.makeConstraints {
                    $0.center.equalToSuperview()
                }
            } else {
                self.emptyLabel.removeFromSuperview()
            }
        })
        .disposed(by: disposeBag)
        
    }
}

extension LikeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.likeListArray.value.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.Id, for: indexPath) as? ItemCollectionViewCell else { return UICollectionViewCell() }

        let cellData = viewModel.likeListArray.value[indexPath.row]
        cell.configureNoHeart(data: cellData)
        return cell
    }
}

extension LikeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 130)
    }
}
