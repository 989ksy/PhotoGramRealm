//
//  FileManager+Extension.swift
//  PhotoGramRealm
//
//  Created by Seungyeon Kim on 2023/09/05.
//

import UIKit

extension UIViewController {
    
    func documentDirectoryPath() -> URL? {
        
        //1. 도큐먼트 경로 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentDirectory
        
    }
    
    
    func removeImageFromDocument(fileName:String) {
        //1. 도큐먼트 경로 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        //2.저장할 경로 설정 (세부 경로, 이미지를 저장할 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do{
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error)
        }
        
    }
    
    //도큐먼트 폴더에서 이미지를 가져오는 메서드
    func loadImageFromDocument(fileName: String) -> UIImage {
        //1. 도큐먼트 경로 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage(systemName: "star.fill")! }
        //2.저장할 경로 설정 (세부 경로, 이미지를 저장할 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)!
        } else {
            return UIImage(systemName: "star.fill")!
        }
        
    }
    
    //도큐먼트 폴더에 이미지를 저장하는 메서드
    func saveImageToDocument(fileName: String, image: UIImage) {
        //1. 도큐먼트 경로 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } //documets앞까지의 파일 주소 경로 불러오기 (도큐멘츠 파일까진 입장~)
        //2.저장할 경로 설정 (세부 경로, 이미지를 저장할 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName) // "/"의 역할. "/documents/"123.jpg
        
        //3. 이미지 변환
        guard let data = image.jpegData(compressionQuality: 0.5) else { return } //압축률 지정
        
        //4. 이미지 저장
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error", error) //사용자의 용량이 부족할 때 오류가 날 수도 있기 때문에 대응. 원래는 action을 띄워주어야함.
        }
        
    }
    
}
