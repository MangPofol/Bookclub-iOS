//
//  SideMenuView.swift
//  BookClub_iOS
//
//  Created by Lee Nam Jun on 2021/08/09.
//

import UIKit

final class SideMenuView: UIView {
    var nameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        $0.adjustsFontForContentSizeCategory = true
        $0.textColor = .white
        $0.text = "이름"
    }
    
    var idLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.adjustsFontForContentSizeCategory = true
        $0.textColor = .white
        $0.text = "아이디: hi06021"
    }
    
    var modifyAccountButonn = UIButton().then {
        $0.setTitle("회원정보수정", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel!.font = UIFont.preferredFont(forTextStyle: .body)
        $0.titleLabel!.adjustsFontForContentSizeCategory = true
        $0.backgroundColor = .white
        $0.sizeToFit()
    }
    
    var myBookClubLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.adjustsFontForContentSizeCategory = true
        $0.textColor = .white
        $0.text = "▼ 나의 북클럽"
        // ▶︎
    }
    
    var myBookClubTableView = UITableView().then {
        $0.separatorColor = .black
        $0.separatorStyle = .none
    }
    
    var createBookClubButton = UIButton().then {
        $0.setTitle("북클럽 생성하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .orange
    }
    
    lazy var myBookClubStack = UIStackView(arrangedSubviews: [myBookClubLabel, myBookClubTableView, createBookClubButton]).then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.distribution = .equalSpacing
    }
    
    var joinedBookClubLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.adjustsFontForContentSizeCategory = true
        $0.textColor = .white
        $0.text = "▼ 참여한 북클럽"
    }
    
    var joinedClubTableView = UITableView().then {
        $0.separatorColor = .black
        $0.separatorStyle = .none
        $0.backgroundColor = .black
    }
    
    lazy var joinedClubStack = UIStackView(arrangedSubviews: [joinedBookClubLabel, joinedClubTableView]).then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.distribution = .equalSpacing
    }
    
    var alertLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.adjustsFontForContentSizeCategory = true
        $0.textColor = .white
        $0.text = "▼ 알림"
    }
    
    var alertTableView = UITableView().then {
        $0.separatorColor = .black
        $0.separatorStyle = .none
    }
    
    lazy var alertStack = UIStackView(arrangedSubviews: [alertLabel, alertTableView]).then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.distribution = .equalSpacing
    }
    
    var usageButton = UIButton().then {
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.white.cgColor
        $0.backgroundColor = .black
        $0.setTitle("앱 활용법", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    var versionButton = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitle("앱버젼", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    var inquireButton = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitle("문의하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    var settingButton = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitle("설정", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    lazy var buttonStack = UIStackView(arrangedSubviews: [versionButton, inquireButton, settingButton]).then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .equalSpacing
        $0.alignment = .trailing
        $0.backgroundColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.addSubview(nameLabel)
        self.addSubview(idLabel)
        self.addSubview(modifyAccountButonn)
        self.addSubview(myBookClubStack)
        self.addSubview(joinedClubStack)
        self.addSubview(alertStack)
        self.addSubview(usageButton)
        self.addSubview(buttonStack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeView() {
        nameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(Constants.screenSize.height / 20)
        }
        idLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        modifyAccountButonn.snp.makeConstraints {
            $0.centerY.equalTo(idLabel)
            $0.right.equalToSuperview().inset(20)
        }
        myBookClubStack.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(Constants.screenSize.height / 25.0)
            $0.left.right.equalToSuperview().inset(20)
        }
        joinedClubStack.snp.makeConstraints {
            $0.top.equalTo(myBookClubStack.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        alertStack.snp.makeConstraints {
            $0.top.equalTo(joinedClubStack.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        usageButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
        buttonStack.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
    }
}

