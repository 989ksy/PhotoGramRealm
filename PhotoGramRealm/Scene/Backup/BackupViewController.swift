//
//  BackupViewController.swift
//  PhotoGramRealm
//
//  Created by Seungyeon Kim on 2023/09/07.
//

import UIKit
import SnapKit
import Zip

class BackupViewController: BaseViewController {
    
    let backupButton = {
        let view = UIButton()
        view.backgroundColor = .systemOrange
        return view
    }()
    let restorepButton = {
        let view = UIButton()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    let backupTableView = {
        let view = UITableView()
        view.rowHeight = 50
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func configure() {
        super.configure()
        
        view.addSubview(backupTableView)
        view.addSubview(backupButton)
        view.addSubview(restorepButton)
        
        
        backupButton.addTarget(self, action: #selector(backupButtonClicked), for: .touchUpInside)
        restorepButton.addTarget(self, action: #selector(restoreButtonClicked), for: .touchUpInside)
        
        backupTableView.delegate = self
        backupTableView.dataSource = self
        
    }
    
    @objc func backupButtonClicked() {
        
        //1. 백업하고자 하는 파일들의 경로 배열 생성
        var urlPaths = [URL]()
        
        //2. 도큐먼트 위치
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        //3. 백업하고자 하는 파일 경로 ex ~~~/~~/~~~/Document/default.realm
        let realmFile = path.appendingPathComponent("default.realm")
        
        //4. 3번 경로가 유효한 지 확인
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            print("백업할 파일이 없습니다.")
            return
        }
        
        //5. 압축하고자 하는 파일을 배열에 추가
        urlPaths.append(realmFile)
        
        //6. 압축
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "JackArchive") //이름이 같으면 덮어쓰기, "JackArchive_\(Int.random(in:1...1000))"하면 파일 여러개 만들어짐.
            print("location: \(zipFilePath)")
        } catch {
            print("압축을 실패했어요.")
        }
        
    }
    
    @objc func restoreButtonClicked() {
        
        //파일 앱을 통한 복구 진행
        //forOpeningContentTypes 열고 싶은 파일 제약 (jpg만, pdf만...) // .archive (압축파일만 가져올게) 선택하고 나면 나머지 옵션은 비활성화.
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        backupTableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        
        backupButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        restorepButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
}

extension BackupViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(#function, urls)
        
        guard let selectedFileURL = urls.first else { //파일앱 내 URL
            print("선택한 파일에 오류가 있어요")
            return
        }
        
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있어요")
            return
        }
        
        //도큐먼트 폴더 내 저장할 경로 설정
        //선택한 파일의 파일앱 마지막 주소를 넣어줘서 압축파일을 다운.
        let sandboxFileUrl = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        //경로에 복구할 파일(zip)이 이미 있는지 확인
        if FileManager.default.fileExists(atPath: sandboxFileUrl.path) {
            
            let fileURL = path.appendingPathComponent("JackArchive.zip") // path = 도큐먼트 *** 경로 중요
            
            do { // zip해제를 하고, 도큐먼트에 파일을 풀어줘, 덮어쓰기 = overwrite, password는 설정하지 않았어, progress 압축에 대한 진행율을 보여준다.
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress:\(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("압축해제 완료: \(unzippedFile)")
                })
            } catch {
                print("압축 해제 실패")
            }
            
        } else {
        //경로에 복구할 파일이 없을 때의 대응
        //복사 붙여넣기
            
            do { // at = 출발, to = 도착
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileUrl)
                let fileURL = path.appendingPathComponent("JackArchive.zip")
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress:\(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("압축해제 완료: \(unzippedFile)")
//                    exit(0) 강제종료
                })

            } catch {
                print("압축 해제 실패")
            }
        }
    }
    
}

extension BackupViewController: UITableViewDataSource, UITableViewDelegate {
    
    //zip파일
    func fetchZipList() -> [String] {
        var list: [String] = []
        
        do {
            guard let path = documentDirectoryPath() else { return list }
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            let zip = docs.filter {$0.pathExtension == "zip"} //jpg 등 zip이 가지고 있는 데이터는 긴 문자열~! / pathExtension = 확장자, 확장자 이름의 파일을 데려오기 때문에 오타 유의할 것. / document"/" 이후의 마지막.
            for i in zip {
                list.append(i.lastPathComponent)
            }
        } catch {
            print("Error")
        }
        return list
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchZipList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell()}
        print("cell")
        cell.textLabel?.text = fetchZipList()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showActivityViewController(fileName: fetchZipList()[indexPath.row]) //각각의 셀에 대한 파일이름
    }
    
    func showActivityViewController(fileName: String) {
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있어요")
            return
        }
        
        let backupFileUrl = path.appendingPathComponent(fileName)
        let vc = UIActivityViewController(activityItems: [backupFileUrl], applicationActivities: [])
        
        present(vc, animated:  true)
    }
    
}
