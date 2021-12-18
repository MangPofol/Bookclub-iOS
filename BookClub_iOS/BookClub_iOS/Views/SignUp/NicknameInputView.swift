//
//  NicknameInputView.swift
//  BookClub_iOS
//
//  Created by Lee Nam Jun on 2021/10/30.
//

import UIKit

final class NicknameInputView: UIView {
    var titleLabel = UILabel().then {
        $0.text = "당신의 닉네임은?"
        $0.textColor = .mainColor
        $0.font = .defaultFont(size: .big, bold: true)
    }
    
    var nicknameTextField = UITextField().then {
        $0.backgroundColor = .textFieldBackgroundGray
        $0.placeholder = "내용을 입력해주세요."
        $0.font = .defaultFont(size: 16.0)
        $0.setCornerRadius(radius: Constants.getAdjustedHeight(10.0))
        $0.addLeftPadding(value: Constants.getAdjustedWidth(10.0))
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.textContentType = .username
    }
    
    var nicknameConfirmMessageLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.textColor = UIColor(hexString: "E5949D")
        $0.font = .defaultFont(size: .small)
        $0.text = "특수문자, 한글, 영어 혼용 가능 (최대 10자)"
    }
    
    var nextButton = UIButton().then {
        $0.isUserInteractionEnabled = false
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor(hexString: "C3C5D1"), for: .normal)
        $0.titleLabel?.font = .defaultFont(size: 18, boldLevel: .bold)
        $0.backgroundColor = .textFieldBackgroundGray
        $0.setCornerRadius(radius: Constants.getAdjustedHeight(8.0))
    }
    
    var nextInformationLabel = UILabel().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.textColor = UIColor(hexString: "E5949D")
        $0.font = .defaultFont(size: .small)
        $0.text = "입력한 정보는 추후 북클럽 내 ‘나의 프로필’에 표시됩니다."
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(titleLabel)
        self.addSubview(nicknameTextField)
        self.addSubview(nicknameConfirmMessageLabel)
        self.addSubview(nextButton)
        self.addSubview(nextInformationLabel)
        
        makeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeView() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.getAdjustedHeight(33.0))
            $0.left.equalToSuperview().inset(Constants.getAdjustedWidth(20.0))
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.getAdjustedHeight(24.0))
            $0.left.right.equalToSuperview().inset(Constants.getAdjustedWidth(20.0))
            $0.height.equalTo(Constants.getAdjustedHeight(40.0))
        }
        
        nicknameConfirmMessageLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(Constants.getAdjustedHeight(4.0))
            $0.left.equalToSuperview().inset(Constants.getAdjustedWidth(30.0))
        }
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextInformationLabel.snp.top).offset(-Constants.getAdjustedHeight(9.0))
            $0.width.equalTo(Constants.getAdjustedWidth(320.0))
            $0.height.equalTo(Constants.getAdjustedHeight(52.0))
        }
        nextInformationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Constants.getAdjustedHeight(75.0))
        }
    }
}
