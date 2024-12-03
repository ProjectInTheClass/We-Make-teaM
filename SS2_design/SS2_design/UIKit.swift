//UIKit 연결

import SwiftUI
import UIKit

// UIViewControllerRepresentable 생성
struct CustomUIKitViewController: UIViewControllerRepresentable {
    @Binding var projects: [String] // SwiftUI에서 데이터 바인딩
    
    // UIViewController를 생성
    func makeUIViewController(context: Context) -> CustomViewController {
        return CustomViewController()
    }
    
    // SwiftUI의 데이터를 UIKit에 업데이트
    func updateUIViewController(_ uiViewController: CustomViewController, context: Context) {
        uiViewController.projects = projects
    }
}

// UIKit의 UIViewController
class CustomViewController: UIViewController {
    var projects: [String] = [] // 데이터를 저장
    private let tableView = UITableView() // UIKit의 TableView 사용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        // AutoLayout 설정
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// UITableViewDelegate, UITableViewDataSource 채택
extension CustomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = projects[indexPath.row]
        cell.textLabel?.textColor = .black
        return cell
    }
}


