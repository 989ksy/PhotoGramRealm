//
//  PhotoImageView.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit

final class PhotoImageView: UIImageView { //final을 붙이면 상속이 안되고, final keyword를 쓰는 이유는? 컴파일 상황에 결정되어서 최적화 레벨 달성할 수 있음. 성능상의 이점이 있음.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = Constants.Desgin.cornerRadius
        layer.borderWidth = Constants.Desgin.borderWidth
        layer.borderColor = Constants.BaseColor.border
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
