//
//  BaseTableViewCell.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    @available(*, unavailable) //특정 버전 이상 가능하게 하는 거 => available //여기서는 해당구문 사용될 일이 없다!, 스토리보드에서 사용되서인데, 우리가 스토리보드를 사용하지 않아서, 다른 파일에서 required 안되게.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {}
    
    func setConstraints() {}
}
