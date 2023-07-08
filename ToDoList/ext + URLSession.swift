//
//  ext + URLSession.swift
//  ToDoList
//
//  Created by Лаванда on 04.07.2023.
//
import UIKit
extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {

        var task: URLSessionDataTask?

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                task = self.dataTask(with: urlRequest) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data, let response = response {
                        continuation.resume(returning: (data, response))
                    } else {
                        let unexpectedError = NSError(domain: "UnexpectedErrorDomain", code: 0, userInfo: nil)
                        continuation.resume(throwing: unexpectedError)
                    }
                }
                task?.resume()
            }
        } onCancel: { [weak task] in
            task?.cancel()
        }
    }
}

