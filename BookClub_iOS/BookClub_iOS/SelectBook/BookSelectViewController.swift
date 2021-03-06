//
//  BookSelectViewController.swift
//  BookClub_iOS
//
//  Created by Lee Nam Jun on 2021/09/17.
//

import UIKit
import RxSwift

class BookSelectViewController: UIViewController {
    
    let customView = BookSelectView()
    var viewModel: BookSelectionViewModel!
    
    var bookCollectionVC = BookCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    let disposeBag = DisposeBag()
    var bookSelectionDisposeBag = DisposeBag()
    
    var newBookSelected = BehaviorSubject<Book?>(value: nil)
    
    override func loadView() {
        self.view = customView
        setNavigationBar()
        self.addChild(bookCollectionVC)
        customView.bookCollectionContainer.addSubview(bookCollectionVC.view)
        bookCollectionVC.didMove(toParent: self)
        bookCollectionVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BookSelectionViewModel(
            input: (
                searchBarText: customView.searchBar.rx.text.asObservable().distinctUntilChanged(),
                readingButtonTapped: customView.readingButton.rx.tap
                    .asObservable()
                    .map { .NOW },
                finishedButtonTapped: customView.finishedButton.rx.tap
                    .asObservable()
                    .map { .AFTER },
                wantToButtonTapped: customView.wantToButton.rx.tap
                    .asObservable()
                    .map { .BEFORE }
            )
        )
        
    // bind outputs {
        // 책 목록에서 책 선택
        bookCollectionVC.collectionView.rx.didScroll
            .bind { [weak self] in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        // 읽는 중, 완독, 읽고싶은 선택
        viewModel!.bookTypeFilter
            .bind { [weak self] in
                self?.bookCollectionVC.viewModel.category.accept($0)
            }
            .disposed(by: disposeBag)
        
        // 새 책 검색
        viewModel.searchTextChanged
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .bind { [weak self] in
                self?.bookCollectionVC.viewModel.searchBook(by: $0 ?? "")
            }
            .disposed(by: disposeBag)
        
        // 새 책 검색 중
        viewModel.isSearching
            .bind { [weak self] in
                self?.searchMode($0)
            }
            .disposed(by: disposeBag)
        
        // 새 책 추가
        newBookSelected
            .filter { $0 != nil }
            .bind { [weak self] in
                if let root = self?.navigationController?.viewControllers[1] as? WriteViewController {
                    root.selectedBook = $0?.bookModel
                    self?.navigationController?.popViewController(animated: false)
                }
            }
            .disposed(by: disposeBag)
    // }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Private Funcs
    private func setNavigationBar() {
        guard let nav = self.navigationController else {
            return
        }
        self.title = "책 선택하기"
        nav.navigationBar.barTintColor = Constants.navigationbarColor
        nav.navigationBar.tintColor = .mainColor
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [.font: UIFont.defaultFont(size: .big, bold: true)]
        
        self.removeBackButtonTitle()
        
        // bar underline 삭제
        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.shadowImage = UIImage()
    }
    
    private func backToWriteView(selectedBook: Book) {
        if let root = self.navigationController?.viewControllers.first as? WriteViewController {
            root.selectedBook = selectedBook.bookModel
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    func searchMode(_ on: Bool) {
        if on {
            customView.buttonContainer.isHidden = true
            customView.searchResultTitleLabel.isHidden = false
            customView.searchResultLineView.isHidden = false
            bookSelectionDisposeBag = DisposeBag()
            bookCollectionVC.viewModel.tappedBook
                .bind { [weak self] in
                    guard let self = self else { return }
                    let vc = BookOptionSelectViewController()
                    vc.modalTransitionStyle = .coverVertical
                    vc.selectedBook = $0
                    vc.bookSelectVC = self
                    self.present(vc, animated: true, completion: nil)
                }
                .disposed(by: bookSelectionDisposeBag)
        } else {
            customView.buttonContainer.isHidden = false
            customView.searchResultTitleLabel.isHidden = true
            customView.searchResultLineView.isHidden = true
            bookSelectionDisposeBag = DisposeBag()
            bookCollectionVC.viewModel.tappedBook
                .bind { [weak self] in
                    self?.newBookSelected.onNext($0)
                }
                .disposed(by: bookSelectionDisposeBag)
        }
    }
}
