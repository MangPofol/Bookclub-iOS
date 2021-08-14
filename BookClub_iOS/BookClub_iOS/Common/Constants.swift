//
//  Constants.swift
//  BookClub_iOS
//
//  Created by Lee Nam Jun on 2021/08/05.
//

import Foundation
import UIKit.UIScreen

class Constants {
    static let createBookClubTitleText = "북클럽 생성하기"
    static let screenSize = UIScreen.main.bounds.size
    static let navigationbarColor: UIColor = .white
}

class LineView: UIView {
    convenience init(width: CGFloat = 1.0, color: UIColor = .black) {
        self.init(frame: .zero)
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
