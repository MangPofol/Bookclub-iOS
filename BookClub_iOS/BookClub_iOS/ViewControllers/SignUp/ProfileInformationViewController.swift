//
//  ProfileInformationViewController.swift
//  BookClub_iOS
//
//  Created by Lee Nam Jun on 2021/10/30.
//

import UIKit
import RxSwift

class ProfileInformationViewController: UIViewController {

    let customView = ProfileInformationView()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = customView
        self.navigationItem.backButtonTitle = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customView.nextButton.rx.tap
            .do { _ in
                self.customView.nextButton.animateButton()
            }
            .bind { _ in
                self.navigationController?.pushViewController(NicknameInputViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}