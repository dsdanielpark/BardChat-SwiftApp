import UIKit
import Alamofire

class ChatViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    
    var messages: [String] = []
    
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
        let url = "https://api.bard.google.com/chat/completions"
        let parameters: [String: Any] = [
            "prompt": message,
            "max_completions": 1
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let completions = json["completions"] as? [String],
                       let completion = completions.first {
                        self?.handleBardResponse(completion)
                    } else {
                        self?.handleBardResponse("No response from Bard.")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    self?.handleBardResponse("Failed to connect to Bard.")
                }
            }
    }
    
    func handleBardResponse(_ response: String) {
        messages.append(response)
        tableView.reloadData()
        
        // 스크롤을 맨 아래로 이동하여 최신 메시지를 보여줍니다.
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
}
