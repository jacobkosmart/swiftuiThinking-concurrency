//
//  AsyncLetBootCamp.swift
//  SwiftUThiningConcurrency
//
//  Created by Jacob Ko on 2022/05/10.
//

import SwiftUI

struct AsyncLetBootCamp: View {
	// MARK: -  PROPERTY
	@State private var images: [UIImage] = []
	let columns = [GridItem(.flexible()), GridItem(.flexible())]
	let url = URL(string: "https://picsum.photos/300")!
	// MARK: -  BODY
	var body: some View {
		NavigationView {
			ScrollView {
				LazyVGrid(columns: columns) {
					ForEach(images, id: \.self) { image in
						Image(uiImage: image)
							.resizable()
							.scaledToFit()
							.frame(height: 150)
					} //: LOOP
				} //: GRID
			} //: SCROLL
			.navigationTitle("Async Let Practice")
			.onAppear {
				Task {
					do {
						
						// No await keyword
						async let fetchImage1 = fetchImage()
						async let fetchTitle1 = fetchTitle()
						
						let (image, title) = await (try fetchImage1, fetchTitle1)
						
						// one await keyword
						// let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
						//
						// self.images.append(contentsOf: [image1, image2, image3, image4])
						
						// let image1 = try await fetchImage()
						// self.images.append(image1)
						//
						// let image2 = try await fetchImage()
						// self.images.append(image2)
						//
						// let image3 = try await fetchImage()
						// self.images.append(image3)
						//
						// let image4 = try await fetchImage()
						// self.images.append(image4)
					} catch  {
						
					}
				}//: TASK
			}
		} //: NAVIGATION
	}
	
	// MARK: -  FUNCTION
	func fetchImage() async throws -> UIImage {
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
	
	func fetchTitle() async -> String {
		return "New Title"
	}
}

// MARK: -  PREVIEW
struct AsyncLetBootCamp_Previews: PreviewProvider {
	static var previews: some View {
		AsyncLetBootCamp()
	}
}
