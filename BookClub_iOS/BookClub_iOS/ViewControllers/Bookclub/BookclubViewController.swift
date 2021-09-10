//
//  BookclubViewController.swift
//  BookClub_iOS
//
//  Created by Lee Nam Jun on 2021/08/26.
//

import UIKit
import RxSwift
import RxCocoa

class BookclubViewController: UIViewController {

    let disposeBag = DisposeBag()
    let customView = BookclubView()
    var viewModel: BookclubViewModel!
    
    let hotViewController = HotContainerController()
    var bookCollectionVC = BookCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    override func loadView() {
        self.view = customView
        setNavigationBar()
        customView.bookCollectionContainer.addSubview(bookCollectionVC.view)
        bookCollectionVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.hotContainer.addSubview(hotViewController.view)
        hotViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        customView.memberProfileCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        customView.makeView()
        
        // viewModel
        viewModel = BookclubViewModel(
            filterTapped: Observable.merge(
                customView.searchButton.rx.tap.map { _ in
                    !self.customView.searchButton.isOn ? FilterTypeInBookclub.none : FilterTypeInBookclub.search },
                customView.clubMemberButton.rx.tap.map { _ in
                    !self.customView.clubMemberButton.isOn ? FilterTypeInBookclub.none: FilterTypeInBookclub.member },
                customView.sortingButton.rx.tap.map { _ in
                    !self.customView.sortingButton.isOn ? FilterTypeInBookclub.none : FilterTypeInBookclub.sorting }))
        
        // Book collection 스크롤 대응
        bookCollectionVC.collectionView.rx.didScroll
            .bind {
                if self.bookCollectionVC.collectionView.contentOffset.y <= self.customView.lowerView.bounds.height {
                    self.customView.lowerView.snp.updateConstraints {
                        $0.top.equalTo(self.customView.upperView.snp.bottom).offset(-self.bookCollectionVC.collectionView.contentOffset.y - 20)
                    }
                } else {
                    self.customView.lowerView.snp.updateConstraints {
                        $0.top.equalTo(self.customView.upperView.snp.bottom).offset(-self.customView.lowerView.bounds.height - 20)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        // bind outputs {
        viewModel.profiles
            .bind(to: customView.memberProfileCollectionView
                    .rx
                    .items(cellIdentifier: MemberProfileCollectionViewCell.identifier, cellType: MemberProfileCollectionViewCell.self)) { (row, element, cell) in
                print(row, element)
                cell.profileImageView.image = UIImage(named: "SampleProfile")
            }
            .disposed(by: disposeBag)
        
        let filterButtonsTapped = Observable.combineLatest(self.customView.searchButton.isOnRx, self.customView.clubMemberButton.isOnRx, self.customView.sortingButton.isOnRx)
        filterButtonsTapped
            .skip(1)
            .bind {
                let status = $0.0 || $0.1 || $0.2
                self.customView.selectedControl.snp.updateConstraints { $0.height.equalTo(status ? 30 : 0) }
            }
            .disposed(by: disposeBag)
        
        // }
        
        
    }
    
    func setNavigationBar() {
        guard let nav = self.navigationController else {
            return
        }
        nav.navigationBar.barTintColor = .mainColor
        nav.navigationBar.tintColor = .white
        nav.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.defaultFont(size: .big, bold: true), .foregroundColor: UIColor.white]

        // bar underline 삭제
        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.shadowImage = UIImage()

        let buttonImage = UIImage(systemName: "text.justify")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: buttonImage, style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: buttonImage, style: .plain, target: nil, action: nil)
    }
}

extension BookclubViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.profileImageSize()
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
}
