//
//  MyLibraryViewController.swift
//  BookClub_iOS
//
//  Created by Lee Nam Jun on 2021/08/13.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu
import SnapKit

class MyLibraryViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var viewModel: MyLibraryViewModel?
    lazy var customView = MyLibraryView()
    
    // MARK: - loadView()
    override func loadView() {
        // add and configure collection view
        customView.collectionView.register(BookListViewCell.self, forCellWithReuseIdentifier: BookListViewCell.identifier)
        customView.bookclubSelector.register(BookclubSelectorCell.self, forCellWithReuseIdentifier: BookclubSelectorCell.identifier)
        customView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        customView.bookclubSelector.rx.setDelegate(self).disposed(by: disposeBag)
        self.view = customView
    }
    
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MyLibraryViewModel(
            input: (
                typeTapped: customView.typeControl.rx.controlEvent(.valueChanged)
                    .map {
                        BookListType(rawValue: self.customView.typeControl.index)!
                    },
                filterTapped: Observable.merge(
                    customView.searchButton.rx.tap.map { _ in
                        !self.customView.searchButton.isOn ? FilterType.none : FilterType.search },
                    customView.bookclubButton.rx.tap.map { _ in
                        !self.customView.bookclubButton.isOn ? FilterType.none: FilterType.bookclub },
                    customView.sortingButton.rx.tap.map { _ in
                        !self.customView.sortingButton.isOn ? FilterType.none : FilterType.sorting }
                )
            )
        )
        self.view.backgroundColor = .white
        self.title = "내 서재"
        
        // Left navigation button
        setNavigationBar()
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.defaultFont(size: .big, bold: true)]
        
        // bind inputs {
        
        self.navigationItem.leftBarButtonItem!
            .rx.tap
            .bind {
                let menu = SideMenuNavigationController(rootViewController: SideMenuViewController())
                menu.leftSide = true
                menu.presentationStyle = .menuSlideIn
                menu.menuWidth = Constants.screenSize.width * 0.85
                self.present(menu, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        self.navigationItem.rightBarButtonItem!
            .rx.tap
            .bind {
                print($0)
            }
            .disposed(by: disposeBag)
        
        // 검색 바 처리
        customView.searchBar
            .rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        customView.bookclubSelector
            .rx.itemSelected
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)

        // }
        
        // 스크롤시 상단 버튼 숨기기
        customView.collectionView.rx.didScroll
            .bind {
                if self.customView.collectionView.contentOffset.y <= self.customView.typeControl.bounds.height + self.customView.buttonStack.bounds.height + 12 {
                    self.customView.typeControl.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(-self.customView.collectionView.contentOffset.y)
                    }
                } else {
                    self.customView.typeControl.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(-(self.customView.typeControl.bounds.height + self.customView.buttonStack.bounds.height + 12))
                    }
                }
            }
            .disposed(by: disposeBag)
        
        // bind outputs {
        viewModel!.data
            .bind(to:
                    self.customView.collectionView
                    .rx
                    .items(cellIdentifier: BookListViewCell.identifier, cellType: BookListViewCell.self)) { (row, element, cell) in
                cell.bookImageView.image = UIImage(named: element.image)
                cell.bookTitleLabel.text = element.title
            }.disposed(by: disposeBag)
        
        viewModel!.bookListType
            .bind {
                print($0)
            }
            .disposed(by: disposeBag)
        
        viewModel!.filterType
            .bind {
                self.customView.bookclubButton.isOn = false
                self.customView.searchButton.isOn = false
                self.customView.sortingButton.isOn = false
                
                switch $0 {
                case .none:
                    break
                case .search:
                    self.customView.searchButton.isOn = true
                case .bookclub:
                    self.customView.bookclubButton.isOn = true
                case .sorting:
                    self.customView.sortingButton.isOn = true
                }
            }
            .disposed(by: disposeBag)
        
        self.customView.searchButton.isOnRx
            .skip(1)
            .subscribe(onNext: {
                setSearchBar($0)
            })
            .disposed(by: disposeBag)
        
        self.customView.bookclubButton.isOnRx
            .skip(1)
            .subscribe(onNext: {
                setBookclubSelector($0)
            })
            .disposed(by: disposeBag)

        
        // 뷰 모델로 부터 소속된 북클럽을 받아와서 북클럽 필터에 표시
        viewModel!.bookclubs
            .bind(to: self.customView.bookclubSelector
                    .rx
                    .items(cellIdentifier: BookclubSelectorCell.identifier, cellType: BookclubSelectorCell.self)) { (row, element, cell) in
                cell.backgroundColor = .gray1
                cell.titleLabel.text = " \(element)"
            }
            .disposed(by: disposeBag)
        
        // cell을 모두 configure 한 후 autolayout 세팅
        customView.makeView()
        
        // }
        
        // private funcs
        func setSearchBar(_ isOn: Bool) {
            self.customView.searchBar.isHidden = !isOn
            self.customView.selectedControl.snp.updateConstraints { $0.height.equalTo(isOn ? 30 : 0) }
            self.customView.searchBar.text = nil
        }
        
        func setBookclubSelector(_ isOn: Bool) {
            self.customView.bookclubSelector.reloadData()
            self.customView.bookclubSelector.isHidden = !isOn
            self.customView.selectedControl.snp.updateConstraints { $0.height.equalTo(isOn ? 30 : 0) }
            self.customView.searchBar.text = nil
        }
        
        func setNavigationBar() {
            guard let nav = self.navigationController else {
                return
            }
            nav.navigationBar.barTintColor = Constants.navigationbarColor
            nav.navigationBar.tintColor = .black
            nav.navigationBar.isTranslucent = false

            // bar underline 삭제
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.shadowImage = UIImage()

            let buttonImage = UIImage(systemName: "text.justify")
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: buttonImage, style: .plain, target: nil, action: nil)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: buttonImage, style: .plain, target: nil, action: nil)
        }
    }
}

extension MyLibraryViewController: UICollectionViewDelegateFlowLayout {
    // 한 가로줄에 cell이 3개만 들어가도록 크기 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionViewLayout == self.customView.collectionViewLayout {
            return Constants.bookListCellSize()
        } else {
            return Constants.bookclubSelectorSize()
        }
    }
}
