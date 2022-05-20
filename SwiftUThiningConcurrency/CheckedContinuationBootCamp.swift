//
//  CheckedContinuationBootCamp.swift
//  SwiftUThinkingConcurrency
//
//  Created by Jacob Ko on 2022/05/20.
//

import SwiftUI

// MARK: - SERVICE
class CheckedContinuationBootCampNetworkManager {
	func getData(url: URL) async throws -> Data {
		do {
			let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
			return data
		} catch  {
			throw error
		}
	}
	
	func getData2(url: URL) async throws -> Data {
		return try await withCheckedThrowingContinuation { continuation in
			URLSession.shared.dataTask(with: url) { data, response, error in
				// withCheckedThrowingContinuation in we get data and we resume it once perfect
				if let data = data {
					continuation.resume(returning: data)
				} else if let error = error {
					continuation.resume(throwing: error)
				} else {
					continuation.resume(throwing: URLError(.badURL))
				}
				// need to resume it exactly once -> will be crashed APP
				// continuation.resume(throwing: URLError(.badURL))
			}
			.resume()
		}
	}
	
	func getHeartImageFromDatabase(completionHandler: @escaping (_ image: UIImage) -> ()) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			completionHandler(UIImage(systemName: "heart.fill")!)
		}
	}
	
	func getHeartImageFromDatabase2() async -> UIImage {
		await withCheckedContinuation { continuation in
			getHeartImageFromDatabase { image in
				continuation.resume(returning: image)
			}
		}
	}
}


// MARK: - VIEWMODEL
class CheckedContinuationBootCampViewModel: ObservableObject {
	// MARK: -  PROPERTY
	@Published var image: UIImage? = nil
	let manager = CheckedContinuationBootCampNetworkManager()
	// MARK: -  INIT
	// MARK: -  FUNCTION
	func getImage() async {
		guard let url = URL(string: "https://picsum.photos/300") else { return }
		
		do {
			let data = try await manager.getData2(url: url)
			
			if let image = UIImage(data: data) {
				await MainActor.run(body: {
					self.image = image
				})
			}
		} catch {
			print(error)
		}
	}
	
	func getHeartImage() async {
		manager.getHeartImageFromDatabase { [weak self ] image in
			self?.image = image
		}
	}
	
	func getHeartImage2() async {
		self.image = await manager.getHeartImageFromDatabase2()
	}
}

// MARK: - VIEW
struct CheckedContinuationBootCamp: View {
	// MARK: -  PROPERTY
	@StateObject private var vm = CheckedContinuationBootCampViewModel()
	// MARK: -  BODY
	var body: some View {
		ZStack {
			if let image = vm.image {
				Image(uiImage: image)
					.resizable()
					.scaledToFit()
					.frame(width: 200, height: 200)
			}
		} //: ZSTACK
		.task {
			// await vm.getImage()
			await vm.getHeartImage()
			await vm.getHeartImage2()
		}
	}
}

// MARK: -  PREVIEW
struct CheckedContinuationBootCamp_Previews: PreviewProvider {
	static var previews: some View {
		CheckedContinuationBootCamp()
	}
}
