//
//  ViewController.swift
//  Ably
//
//  Created by 김희진 on 2022/09/02.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var viewModel = HomeViewModel()
    
    lazy var contentCollectionView = HomeView().makeCollectionView()
    let refresher = UIRefreshControl()
    var loadingView: LoadingView?
    var bannerView: BannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI(viewModel)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(contentCollectionView)
        contentCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "홈"
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
        viewModel.isFinish = false
        bannerView?.resetTimer()
        contentCollectionView.refreshControl?.beginRefreshing()
        viewModel.populateData()
        contentCollectionView.refreshControl?.endRefreshing()
    }
    
    func bindUI(_ viewModel: HomeViewModel) {
        viewModel.goodsData
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                if $0.count == 10 {
                    self.contentCollectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func changeButtonUI(with senderData: GoodsViewModel) {
        var goodsData = viewModel.goodsData.value
        let updatedData = GoodsViewModel(value: senderData)
        
        goodsData = goodsData.map {
            if $0.id == senderData.id {
                updatedData.isLike = !senderData.isLike
                updatedData.createdAt = Date()
                return updatedData
            }
            return $0
        }
        
        viewModel.goodsData.accept(goodsData)
        contentCollectionView.reloadData()
        LikeListRealmManager.shared.realmUpdate(data: updatedData)
    }
    
    func loadMoreData() {
        if !viewModel.isLoading {
            viewModel.isLoading = true
            
            self.viewModel.fetchMoreData() { indexArr in
                DispatchQueue.main.async {
                    if !indexArr.isEmpty {
                        self.contentCollectionView.insertItems(at: indexArr)
                    } else {
                        self.loadingView?.loadingIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.goodsData.value.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.Id, for: indexPath) as? ItemCollectionViewCell else { return UICollectionViewCell() }

        let cellData = viewModel.goodsData.value[indexPath.row]
        cell.configureWithHeart(data: cellData)

        cell.onClick = { cellData in
            if let data = cellData {
                self.changeButtonUI(with: data)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionView.elementKindSectionHeader :
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BannerView.Id , for: indexPath) as? BannerView else { return UICollectionReusableView() }
            
            bannerView = header
            header.prepare(banners: viewModel.bannerData.value)
            return header
            
        case UICollectionView.elementKindSectionFooter :
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingView.Id , for: indexPath) as? LoadingView else { return UICollectionReusableView() }
            loadingView = footer
            return footer
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.frame.width, height: 55)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter && !viewModel.isFinish {
            self.loadingView?.loadingIndicatorView.startAnimating()
        } else if elementKind == UICollectionView.elementKindSectionHeader {
            self.bannerView?.resetTimer()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.loadingIndicatorView.stopAnimating()
        } else if elementKind == UICollectionView.elementKindSectionHeader {
            self.bannerView?.timer?.invalidate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !viewModel.isFinish {
            if indexPath.row == viewModel.goodsData.value.count - 1 && !viewModel.isLoading {
                loadMoreData()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 0.7)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 130)
    }
}
