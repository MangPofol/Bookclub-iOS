//
//  BookclubHomeView.swift
//  BookClub_iOS
//
//  Created by Nam Jun Lee on 2022/03/23.
//

import UIKit

final class BookclubHomeView: UIView {
    private let stackView = UIStackView()
    private let lowView = UIStackView()
    
    let myBookclubLabel = PaddedLabel(padding: UIEdgeInsets(top: 0, left: 29.0.adjustedHeight, bottom: 0, right: -29.0.adjustedHeight))
    var bookclubCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let bookclubSettingLabel = PaddedLabel(padding: UIEdgeInsets(top: 0, left: 10.0.adjustedHeight, bottom: 0, right: -10.0.adjustedHeight))
    let bookclubSettingButton = WriteRecordButton()
    let bookclubHelpButton = WriteRecordButton()
    let createBookclubButton = WriteRecordButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(stackView)
        self.stackView.then {
            $0.axis = .vertical
            $0.distribution = .fill
        }.snp.makeConstraints {
            $0.top.equalTo(safeAreaInsets).inset(35.0.adjustedHeight)
            $0.bottom.left.right.equalTo(safeAreaInsets)
        }
        
        self.stackView.addArrangedSubview(myBookclubLabel)
        self.stackView.setCustomSpacing(18.0, after: self.myBookclubLabel)
        self.myBookclubLabel.then {
            $0.font = .defaultFont(size: 18.0, boldLevel: .bold)
            $0.textColor = .mainColor
            $0.text = "나의 북클럽"
        }.snp.makeConstraints {
            $0.height.equalTo(24.0.adjustedHeight)
        }
        
        self.stackView.addArrangedSubview(bookclubCollectionView)
        self.stackView.setCustomSpacing(34.0, after: self.bookclubCollectionView)
        self.bookclubCollectionView.then {
            $0.backgroundColor = .white
            $0.register(BookclubHomeCollectionViewCell.self, forCellWithReuseIdentifier: BookclubHomeCollectionViewCell.identifier)
            $0.register(BookclubHomeEmptyCell.self, forCellWithReuseIdentifier: BookclubHomeEmptyCell.identifier)
            
            _ = ($0.collectionViewLayout as! UICollectionViewFlowLayout).then {
                $0.itemSize = CGSize(width: 220.0, height: 250.0).resized(basedOn: .height)
                $0.scrollDirection = .horizontal
                $0.minimumInteritemSpacing = 12.0.adjustedHeight
            }
            $0.showsHorizontalScrollIndicator = false
        }.snp.makeConstraints {
            $0.height.equalTo(250.adjustedHeight)
            $0.left.right.equalToSuperview()
        }
        
        self.stackView.addArrangedSubview(lowView)
        _ = self.lowView.then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.spacing = 10.0
            $0.backgroundColor = UIColor(hexString: "EFF0F3")
            $0.topRoundCorner(radius: 20.0.adjustedHeight)
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 20.adjustedHeight, bottom: 0, right: 20.adjustedHeight)
            $0.isLayoutMarginsRelativeArrangement = true
        }
        
        self.lowView.addArrangedSubview(bookclubSettingLabel)
        self.lowView.setCustomSpacing(0.0, after: self.bookclubSettingLabel)
        self.bookclubSettingLabel.then {
            $0.font = .defaultFont(size: 18.0, boldLevel: .bold)
            $0.textColor = .mainColor
            $0.text = "북클럽 관리"
            $0.numberOfLines = 0
        }.snp.makeConstraints {
            $0.height.equalTo(66.0)
        }
        
        self.lowView.addArrangedSubview(bookclubSettingButton)
        self.bookclubSettingButton.then {
            $0.titleLabel.text = "북클럽 설정"
            $0.titleLabel.textColor = .mainColor
            
            $0.backgroundColor = .white
            $0.setCornerRadius(radius: 10.0.adjustedHeight)
            
            $0.writeButton.image = UIImage(named: "RightArrow")?.withRenderingMode(.alwaysTemplate)
            $0.writeButton.tintColor = .mainColor
            
            $0.writeButton.snp.updateConstraints {
                $0.right.equalToSuperview().inset(16.5.adjustedHeight)
                $0.width.equalTo(5.48.adjustedHeight)
                $0.height.equalTo(9.51.adjustedHeight)
            }
        }.snp.makeConstraints {
            $0.height.equalTo(40.0.adjustedHeight)
        }
        
        self.lowView.addArrangedSubview(bookclubHelpButton)
        self.bookclubHelpButton.then {
            $0.titleLabel.text = "북클럽 도움말"
            $0.titleLabel.textColor = .mainColor
            
            $0.backgroundColor = .white
            $0.setCornerRadius(radius: 10.0.adjustedHeight)
            
            $0.writeButton.image = UIImage(named: "RightArrow")?.withRenderingMode(.alwaysTemplate)
            $0.writeButton.tintColor = .mainColor
            
            $0.writeButton.snp.updateConstraints {
                $0.right.equalToSuperview().inset(16.5.adjustedHeight)
                $0.width.equalTo(5.48.adjustedHeight)
                $0.height.equalTo(9.51.adjustedHeight)
            }
        }.snp.makeConstraints {
            $0.height.equalTo(40.0.adjustedHeight)
        }
        
        self.lowView.addArrangedSubview(createBookclubButton)
        self.createBookclubButton.then { item in
            item.titleLabel.text = "북클럽 추가"
            item.titleLabel.font = .defaultFont(size: 14.0, boldLevel: .bold)
            item.setCornerRadius(radius: 10.0.adjustedHeight)
            
            item.writeButton.image = UIImage(named: "PlusIcon")?
                .withRenderingMode(.alwaysTemplate)
            
            item.writeButton.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(10.0.adjustedHeight)
                $0.left.equalToSuperview().inset(14.0.adjustedHeight)
            }
            
            item.titleLabel.snp.remakeConstraints {
                $0.left.equalTo(item.writeButton.snp.right).offset(12.0.adjustedHeight)
                $0.centerY.equalToSuperview()
            }
        }.snp.makeConstraints {
            $0.height.equalTo(40.0.adjustedHeight)
        }
        
        self.lowView.addArrangedSubview(UIView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
