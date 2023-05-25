//
//  BardChatViewController.swift
//  BardChat
//
//  Created by parkminwoo on 2023/05/26.
//

import UIKit

class BardChatViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type a message..."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    private var messages: [String] = []
    private let bard: Bard
    private var snim0e: String?
    
    init() {
        self.bard = Bard()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getSNlM0e()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        inputTextField.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(inputTextField)
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputTextField.topAnchor, constant: -16),
            
            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor)
        ])
    }
    
    private func getSNlM0e() {
        bard.getSNlM0e { [weak self] result in
            switch result {
            case .success(let snim0e):
                self?.snim0e = snim0e
            case .failure(let error):
                print("Failed to get SNlM0e: \(error)")
            }
        }
    }
    
    @objc private func sendMessage() {
        guard let message = inputTextField.text, !message.isEmpty else {
            return
        }
        
        sendMessageToBard(message)
        inputTextField.text = ""
        inputTextField.resignFirstResponder()
    }
    
    private func sendMessageToBard(_ message: String) {
        bard.getAnswer(inputText: message) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.handleBardMessage(response)
                }
            case .failure(let error):
                print("Bard request error: \(error)")
            }
        }
    }
    
    private func handleBardMessage(_ response: [String: Any]) {
        guard let message = response["message"] as? String else {
            print("Invalid response format")
            return
        }
        
        messages.append(message)
        tableView.reloadData()
        
        // Scroll to the bottom of the table view
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension BardChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = messages[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

extension BardChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messages[indexPath.row]
        let label = UILabel()
        label.text = message
        label.numberOfLines = 0
        let maxSize = CGSize(width: view.frame.width - 32, height: CGFloat.greatestFiniteMagnitude)
        let size = label.sizeThatFits(maxSize)
        return size.height + 20
    }
}

extension BardChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}

