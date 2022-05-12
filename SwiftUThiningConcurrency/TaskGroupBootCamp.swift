//
//  TaskGroupBootCamp.swift
//  SwiftUThiningConcurrency
//
//  Created by Jacob Ko on 2022/05/12.
//

import SwiftUI

// MARK: -  DATA MANAGER
class TaskGroupBootCampDataManager {
	
	func fetchImageWithAsyncLet() async throws -> [UIImage] {
		async let fetchIamge1 = fetchImage(urlString: "https://picsum.photos/300")
		async let fetchIamge2 = fetchImage(urlString: "https://picsum.photos/300")
		async let fetchIamge3 = fetchImage(urlString: "https://picsum.photos/300")
		async let fetchIamge4 = fetchImage(urlString: "https://picsum.photos/300")
		
		let (image1, image2, image3, image4) = await (try fetchIamge1, try fetchIamge2, try fetchIamge3, try fetchIamge4)
		return [image1, image2, image3, image4]
	}
	
	func fetchImageWithTaskGroup() async throws -> [UIImage] {
		let urlStrings = [
			"https://picsum.photos/300",
			"https://picsum.photos/300",
			"https://picsum.photos/300",
			"https://picsum.photos/300",
			"https://picsum.photos/300",
		]
		
		return try await withThrowingTaskGroup(of: UIImage?.self) { group in
			var images: [UIImage] = []
			images.reserveCapacity(urlStrings.count)
			
			for urlString in urlStrings {
				group.addTask {
					try? await self.fetchImage(urlString: urlString)
				}
			}
			for try await image in group {
				if let image = image {
					images.append(image)
				}
			}
			return images
		}
	}
	
	func fetchImage(urlString: String) async throws -> UIImage {
		guard let url = URL(string: urlString)  else {
			throw URLError(.badURL)
		}
		do {
			let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
			if let image = UIImage(data: data) {
				return image
			} else {
				throw URLError(.badURL)
			}
		} catch  {
			throw error
		}
	}
}

// MARK: -  VIEWMODEL
class TaskGroupBootCampViewModel: ObservableObject {
	@Published var images: [UIImage] = []
	let manager = TaskGroupBootCampDataManager()
	
	func getImages() async {
		if let images = try? await manager.fetchImageWithTaskGroup() {
			self.images.append(contentsOf: images)
		}
	}
}

// MARK: -  VIEW
struct TaskGroupBootCamp: View {
	// MARK: -  PROPERTY
	@StateObject private var vm = TaskGroupBootCampViewModel()
	let columns = [GridItem(.flexible()), GridItem(.flexible())]
	// let url = URL(string: "https://picsum.photos/300")!
	// MARK: -  BODY
	var body: some View {
		NavigationView {
			ScrollView {
				LazyVGrid(columns: columns) {
					ForEach(vm.images, id: \.self) { image in
						Image(uiImage: image)
							.resizable()
							.scaledToFit()
							.frame(height: 150)
					} //: LOOP
				} //: GRID
			} //: SCROLL
			.navigationTitle("Task Group Practice")
			.task {
				await vm.getImages()
			}
		}
	}
	
	// MARK: -  PREVIEW
	struct TaskGroupBootCamp_Previews: PreviewProvider {
		static var previews: some View {
			TaskGroupBootCamp()
		}
	}
}
