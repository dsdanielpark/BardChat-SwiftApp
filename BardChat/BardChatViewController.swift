import UIKit

class BardChatViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    
    var messages: [String] = []
    let bard = Bard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if let message = inputTextField.text, !message.isEmpty {
            sendMessageToBard(message)
            inputTextField.text = ""
        }
    }
    
    func sendMessageToBard(_ message: String) {
        bard.getAnswer(inputText: message) { [weak self] result in
            switch result {
            case .success(let response):
                if let answer = response["message"] as? String {
                    self?.handleBardMessage(answer)
                }
            case .failure(let error):
                print("Bard API Error: \(error)")
            }
        }
    }
    
    func handleBardMessage(_ message: String) {
        messages.append(message)
        tableView.reloadData()
        
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension BardChatViewController: UITableViewDataSource, UITableViewDelegate {
    // UITableViewDataSource와 UITableViewDelegate의 내용은 주어진 코드와 동일합니다.
    // ...
}
