//
//  DownloadImageAsync.swift
//  SwiftUThiningConcurrency
//
//  Created by Jacob Ko on 2022/04/28.
//

import SwiftUI
import Combine

// MARK: -  SERVICE
class DownloadImageAsyncImageLoader {
	let url = URL(string: "https://picsum.photos/200")!
	
	func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
		guard
			let data = data,
			let image = UIImage(data: data),
			let response = response as? HTTPURLResponse,
			response.statusCode >= 200 && response.statusCode < 300 else {
				return nil
			}
		return image
	}
	
	func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
		URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			let image = self?.handleResponse(data: data, response: response)
			completionHandler(image, error)
		}
		.resume()
	}
	
	func downloadwithCombine() -> AnyPublisher<UIImage?, Error> {
		URLSession.shared.dataTaskPublisher(for: url)
			.map(handleResponse)
			.mapError({ $0 })
			.eraseToAnyPublisher()
	}
	
	func downloadWithAsync() async throws -> UIImage? {
		do {
			let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
			return handleResponse(data: data, response: response)
		} catch  {
			throw error
		}
	}
}

// MARK: -  VIEWMODEL
class DownloadImageAsyncViewModel: ObservableObject {
	// MARK: -  PROPERTY
	@Published var image: UIImage? = nil
	let loader = DownloadImageAsyncImageLoader()
	var cancellables = Set<AnyCancellable>()
	// MARK: -  INIT
	// MARK: -  FUNCTION
	func fetchImage() async {
		// loader.downloadWithEscaping { [weak self] image, error in
		// 	DispatchQueue.main.async {
		// 		self?.image = image
		// 	}
		// }
		// loader.downloadwithCombine()
		// 	.receive(on: DispatchQueue.main)
		// 	.sink { _ in
		//
		// 	} receiveValue: { [weak self] image in
		// 			self?.image = image
		// 	}
		// 	.store(in: &cancellables)
		
		let image = try? await loader.downloadWithAsync()
		await MainActor.run {
			self.image = image
		}
	}
}

// MARK: -  VIEW
struct DownloadImageAsync: View {
	// MARK: -  PROPERTY
	@StateObject private var vm = DownloadImageAsyncViewModel()
	// MARK: -  BODY
	var body: some View {
		ZStack {
			if let image = vm.image {
				Image(uiImage: image)
					.resizable()
					.scaledToFit()
					.frame(width: 250, height: 250)
			}
		} //: ZSTACK
		.onAppear {
			Task {
				await vm.fetchImage()
			}
		}
	}
}

// MARK: -  PREVIEW
struct DownloadImageAsync_Previews: PreviewProvider {
	static var previews: some View {
		DownloadImageAsync()
	}
}
