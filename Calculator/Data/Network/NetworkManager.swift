//
//  NetworkManager.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import OSLog

protocol NetworkManager {
    func performRequest<T: Decodable>(
        _ request: RequestDescriptor,
        allowRetry: Bool
    ) async throws -> T
    func performRequest(_ request: RequestDescriptor, allowRetry: Bool) async throws
}

final class DefaultNetworkManager: NetworkManager, Sendable {

    // MARK: Properties
    
    private let baseURLProvider: BaseURLProvider
    
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Calculator",
        category: "Networking"
    )
    
    // MARK: Initialization
    
    init(baseURLProvider: BaseURLProvider) {
        self.baseURLProvider = baseURLProvider
    }
    
    // MARK: Public Methods
    
    func performRequest<T: Decodable>(
        _ request: RequestDescriptor,
        allowRetry: Bool
    ) async throws -> T {
        let urlRequest = await makeURLRequest(from: request)
        
        do {
            logger.info("➡️ Request: \(request.method.rawValue) \(request.path)")
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("❌ Invalid response type for \(request.path)")
                throw NetworkError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                logger.info("⬅️ Response: \(httpResponse.statusCode) \(request.path)")
                return try decoder.decode(T.self, from: data)
            case 401:
                
                /* Обновления токена
                 
                 logger.warning("🔒 401 Unauthorized for \(request.path)")
                 guard allowRetry else { throw NetworkError.authorizationFailed }
                 
                 try await authorizationManager.refreshTokens()
                 logger.info("🔁 Retrying request after refreshing tokens: \(request.path)")
                 return try await performRequest(request, allowRetry: false)
                 
                 */
                
                return try decoder.decode(T.self, from: data)
            default:
                if let serverError = try? decoder.decode(ServerErrorResponse.self, from: data) {
                    logger.warning("⚠️ Server error: \(serverError.message) [\(request.path)]")
                    throw NetworkError.serverError(
                        code: httpResponse.statusCode,
                        errorCode: nil,
                        message: serverError.message
                    )
                } else {
                    logger.error("❗ Unhandled error status: \(httpResponse.statusCode) [\(request.path)]")
                    throw NetworkError.serverError(
                        code: httpResponse.statusCode,
                        errorCode: nil,
                        message: nil
                    )
                }
            }
        }
    }
    
    func performRequest(_ request: RequestDescriptor, allowRetry: Bool) async throws {
        let urlRequest = await makeURLRequest(from: request)
        
        do {
            logger.info("➡️ Request: \(request.method.rawValue) \(request.path)")
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("❌ Invalid response type for \(request.path)")
                throw NetworkError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                logger.info("⬅️ Response: \(httpResponse.statusCode) \(request.path)")
            case 401:
                logger.info("⬅️ Response: \(httpResponse.statusCode) \(request.path)")

                /* Обновления токена
                 
                logger.warning("🔒 401 Unauthorized for \(request.path)")
                guard allowRetry else { throw NetworkError.authorizationFailed }
                
                try await authorizationManager.refreshTokens()
                logger.info("🔁 Retrying request after refreshing tokens: \(request.path)")
                return try await performRequest(request, allowRetry: false)
                 */
                
            default:
                if let serverError = try? decoder.decode(ServerErrorResponse.self, from: data) {
                    logger.warning("⚠️ Server error: \(serverError.message) [\(request.path)]")
                    throw NetworkError.serverError(
                        code: httpResponse.statusCode,
                        errorCode: nil,
                        message: serverError.message
                    )
                } else {
                    logger.error("❗ Unhandled error status: \(httpResponse.statusCode) [\(request.path)]")
                    throw NetworkError.serverError(
                        code: httpResponse.statusCode,
                        errorCode: nil,
                        message: nil
                    )
                }
            }
        }
    }
    
    // MARK: Private Methods
    
    private func makeURLRequest(from descriptor: RequestDescriptor) async -> URLRequest {
        let url = baseURLProvider.url(for: descriptor.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = descriptor.method.rawValue
        if let body = descriptor.body {
            do {
                urlRequest.httpBody = try encoder.encode(body)
            } catch {
                logger.error("Could not encode data for request: \(descriptor.path)")
            }
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /* Если необходим токен
        if descriptor.requiresAuth, let token = await authorizationManager.accessToken {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        */
        descriptor.headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
}


/* 
// MARK: - AuthorizationManagerDelegate

extension DefaultNetworkManager: AuthorizationManagerDelegate {
    
    func refreshTokens(refreshToken: String) async throws -> TokensResponse {
        // TODO: Implement tokens refreshing request
        TokensResponse(access: "", refresh: "")
    }
    
}
*/
