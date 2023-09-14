//
//  RealmModel.swift
//  PhotoGramRealm
//
//  Created by Seungyeon Kim on 2023/09/04.
//

import Foundation
import RealmSwift

class DiaryTable: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var dairyTitle: String //일기 제목 (필수)
    @Persisted var dairyDate: Date //일기 등록 날짜 (필수)
    @Persisted var contents: String? //일기 내용 (옵션)
    @Persisted var image: String? //일기 사진 URL (옵션)
    @Persisted var diaryLike: Bool //즐겨찾기 기능(필수)
//    @Persisted var diaryPin: Bool
    @Persisted var dairySummary: String

    convenience init(dairyTitle: String, dairyDate: Date, diaryContents: String?, diaryPhoto: String?) {
        self.init()
        
        self.dairyTitle = dairyTitle
        self.dairyDate = dairyDate
        self.contents = diaryContents
        self.image = diaryPhoto
        self.diaryLike = true
        self.dairySummary = "제목은 '\(dairyTitle)'이고, 내용은 '\(diaryContents ?? "")'입니다."
        
    }
    
}

