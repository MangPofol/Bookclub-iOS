//
//  GoalViewController.swift
//  BookClub_iOS
//
//  Created by Lee Nam Jun on 2021/11/05.
//

import UIKit

import RxSwift
import RxCocoa
import CryptoSwift

class GoalViewController: UIViewController {

    let customView = GoalView()
    
    var disposeBag = DisposeBag()
    
    var viewModel: GoalViewModel!
    
    var periods = Array(1...30).map { String($0) }
    var units = ["년", "개월", "일"]
    var booksGoals = Array(1...100).map { String($0) }
    
    override func loadView() {
        self.view = customView
        self.customView.nextButton.isUserInteractionEnabled = true
        self.customView.nextButton.backgroundColor = .mainPink
        self.customView.nextButton.setTitleColor(.white, for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "건너뛰기", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font: UIFont.defaultFont(size: 14, boldLevel: .bold), .foregroundColor: UIColor.mainColor], for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customView.periodPickerView.rx.setDelegate(self).disposed(by: disposeBag)
        self.customView.periodPickerView.dataSource = self
        self.customView.unitPickerView.rx.setDelegate(self).disposed(by: disposeBag)
        self.customView.unitPickerView.dataSource = self
        self.customView.booksPickerView.rx.setDelegate(self).disposed(by: disposeBag)
        self.customView.booksPickerView.dataSource = self
        
        self.customView.unitPickerView.selectRow(1, inComponent: 0, animated: false)
        self.customView.booksPickerView.selectRow(9, inComponent: 0, animated: false)
    
        viewModel = GoalViewModel(nextButtonTapped: Observable.merge(self.navigationItem.rightBarButtonItem!.rx.tap.asObservable(), self.customView.nextButton.rx.tap.asObservable()))
        
        // inputs
        self.customView.periodPickerView.rx.itemSelected.asObservable()
            .withUnretained(self)
            .bind { (owner, val) in
                owner.viewModel.periodText.onNext(owner.periods[val.row])
            }.disposed(by: disposeBag)
        self.customView.unitPickerView.rx.itemSelected.asObservable()
            .withUnretained(self)
            .bind { (owner, val) in
                owner.viewModel.unitText.onNext(owner.units[val.row])
            }.disposed(by: disposeBag)
        self.customView.booksPickerView.rx.itemSelected.asObservable()
            .withUnretained(self)
            .bind { (owner, val) in
                owner.viewModel.booksText.onNext(owner.booksGoals[val.row])
            }.disposed(by: disposeBag)
        
        // bind results {
        self.viewModel.isNextConfirmed
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                if $0 {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
            .disposed(by: disposeBag)
        // }
    }
}

extension GoalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Constants.getAdjustedWidth(200), height: Constants.getAdjustedHeight(60.0)))
        pickerLabel.font = .defaultFont(size: .medium, bold: true)
        pickerLabel.textAlignment = .center
        pickerLabel.textColor = .mainColor
        
        switch pickerView {
        case self.customView.periodPickerView:
            pickerLabel.text = periods[row]
        case self.customView.unitPickerView:
            pickerLabel.text = units[row]
        case self.customView.booksPickerView:
            pickerLabel.text = booksGoals[row]
        default:
            break
        }
        
        return pickerLabel
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.customView.periodPickerView:
            return periods.count
        case self.customView.unitPickerView:
            return units.count
        case self.customView.booksPickerView:
            return booksGoals.count
        default:
            return 0
        }
    }
}
