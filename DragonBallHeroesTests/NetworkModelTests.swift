//
//  NetworkModelTests.swift
//  DragonBallHeroesTests
//
//  Created by Pablo Marín Gallardo on 7/2/24.
//

import XCTest
@testable import DragonBallHeroes

final class NetworkModelTests: XCTestCase {
    
    private var sut: NetworkManager!
    private var someHeroes: [Heroe]!
    private var someTransformation: [Transformation]!
    private var someToken: String!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        sut = NetworkManager(session: session)
        someHeroes = [
            Heroe(
                id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
                name: "Goku",
                photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300",
                favorite: false,
                description: "Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra, pero hay dos versiones sobre el origen del personaje. Según una publicación especial, cuando Goku nació midieron su poder y apenas llegaba a dos unidades, siendo el Saiyan más débil. Aun así se pensaba que le bastaría para conquistar el planeta. Sin embargo, la versión más popular es que Freezer era una amenaza para su planeta natal y antes de que fuera destruido, se envió a Goku en una incubadora para salvarle.")
        ]
        someTransformation = [
            Transformation(
                id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
                name: "1. Oozaru – Gran Mono",
                photo: "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp",
                description: "Cómo todos los Saiyans con cola, Goku es capaz de convertirse en un mono gigante si mira fijamente a la luna llena. Así es como Goku cuando era un infante liberaba todo su potencial a cambio de perder todo el raciocinio y transformarse en una auténtica bestia. Es por ello que sus amigos optan por cortarle la cola para que no ocurran desgracias, ya que Goku mató a su propio abuelo adoptivo Son Gohan estando en este estado. Después de beber el Agua Ultra Divina, Goku liberó todo su potencial sin necesidad de volver a convertirse en Oozaru")
        ]
        someToken = "SomeToken"
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        someHeroes = nil
        someTransformation = nil
        someToken = nil
    }
    
    func testLogin() {
        let someUser = "SomeUser"
        let somePassword = "SomePassword"
        
        MockURLProtocol.requestHandler = { request in
            let loginString = String(format: "%@:%@", someUser, somePassword)
            let loginData = loginString.data(using: .utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Basic \(base64LoginString)")
            
            let data = try XCTUnwrap(self.someToken.data(using:.utf8))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-type":"application/json"]
                )
            )
            return (response, data)
        }
        
        let expectation = expectation(description: "Login success")
        
        sut.login(
            email: someUser,
            password: somePassword
        ) { token, error  in
            guard let token else {
                XCTFail("Expected success but received \(error?.localizedDescription ?? "")")
                print("ERRORR: ", error?.localizedDescription ?? "")
                return
            }
            XCTAssertEqual(token, self.someToken)
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func testFetchHeroes() {
        
        MockURLProtocol.requestHandler = { request in
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(self.someToken!)")
            
            let data = try XCTUnwrap(JSONEncoder().encode(self.someHeroes))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-type":"application/json"]
                )
            )
            return (response, data)
            
        }
        
        let expectation = expectation(description: "fetchHeroes success")
        
        sut.fetchHeroes(token: someToken) { [self] heroes, error in
            
            XCTAssertEqual(heroes?.count, someHeroes.count)
            XCTAssertNotNil(heroes)
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testFetchTransformations() {
        
        MockURLProtocol.requestHandler = { request in
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(self.someToken!)")
            
            let data = try XCTUnwrap(JSONEncoder().encode(self.someTransformation))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-type":"application/json"]
                )
            )
            return (response, data)
            
        }
        
        let expectation = expectation(description: "fetchTransformation success")
        
        sut.fetchTransformations(token: self.someToken, id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94") { transformations, error in
            
            XCTAssertEqual(transformations?.first?.name, self.someTransformation.first?.name)
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}

// OHHTTPStubs

final class MockURLProtocol: URLProtocol {
    static var error: NetworkError?
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let handler = MockURLProtocol.requestHandler else {
            assertionFailure("Received unexpected request with no handler")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        
    }
}
