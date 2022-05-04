//
//  TaskBootCamp.swift
//  SwiftUThiningConcurrency
//
//  Created by Jacob Ko on 2022/05/04.
//

import SwiftUI


// MARK: -  VIEWMODEL
class TaskBootCampViewModel: ObservableObject {
	// MARK: -  PROPERTY
	@Published var image: UIImage? = nil
	@Published var image2: UIImage? = nil
	// MARK: -  INIT
	// MARK: -  FUNCTION
	func fetchImage() async {
		try? await Task.sleep(nanoseconds: 5_000_000_000)
		do {
			guard let url = URL(string: "https://picsum.photos/1000") else { return }
			let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
			await MainActor.run(body: {
				self.image = UIImage(data: data)
				print("IMAGE RETURNED SUCCESSFULLY!")
			})
		} catch  {
			print(error.localizedDescription)
		}
	}
	
	func fetchImage2() async {
		do {
			guard let url = URL(string: "https://picsum.photos/1000") else { return }
			let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
			await MainActor.run(body: {
				self.image2 = UIImage(data: data)
			
			})
		} catch  {
			print(error.localizedDescription)
		}
	}
}

// MARK: -  HOMEVIEW
struct TaskBootCampHomeView: View {
	var body: some View {
		NavigationView {
			ZStack {
				NavigationLink("Click Me!!") {
					TaskBootCamp()
				}
			} //: ZSTACK
		} //: NAVIGATION
	}
}


// MARK: -  VIEW
struct TaskBootCamp: View {
	// MARK: -  PROPERTY
	@StateObject private var vm = TaskBootCampViewModel()
	@State private var fetchImageTask: Task<(), Never>? = nil
	// MARK: -  BODY
	var body: some View {
		VStack(spacing: 40) {
			if let image = vm.image {
				Image(uiImage: image)
					.resizable()
					.scaledToFit()
					.frame(width: 200, height: 200)
			}
			if let image = vm.image2 {
				Image(uiImage: image)
					.resizable()
					.scaledToFit()
					.frame(width: 200, height: 200)
			}
		} //: VSTACK
		
		// SwiftUI automatically cancels the task if the view disappears before the action completes
		.task {
			await vm.fetchImage()
		}
		// .onDisappear(perform: {
		// 	// when display off then cancel tasks during process
		// 	fetchImageTask?.cancel()
		// })
		// .onAppear {
		// 	fetchImageTask = Task {
		// 		print(Thread.current)
		// 		print(Task.currentPriority)
		// 		await vm.fetchImage()
		// 	}
			// Task {
			// 	print(Thread.current)
			// 	print(Task.currentPriority)
			// 	await vm.fetchImage2()
			// }
			
			// The order of task priorities
			// Task(priority: .high) {
			// 	// Task.yield() just can wait and let other tasks go in front of it if there are other tasks
			// 	await Task.yield()
			// 	print("High: \(Thread.current) : \(Task.currentPriority)")
			// }
			// Task(priority: .userInitiated) {
			// 	print("UserInitiated: \(Thread.current) : \(Task.currentPriority)")
			// }
			// Task(priority: .medium) {
			// 	print("Medium: \(Thread.current) : \(Task.currentPriority)")
			// }
			//
			// Task(priority: .low) {
			// 	print("Low: \(Thread.current) : \(Task.currentPriority)")
			// }
			// Task(priority: .utility) {
			// 	print("Utility: \(Thread.current) : \(Task.currentPriority)")
			// }
			// Task(priority: .background) {
			// 	print("Background: \(Thread.current) : \(Task.currentPriority)")
			// }
			
			// child tasks will inherit all of the metadata from parent tasks
			// Task(priority: .userInitiated) {
			// 	print("UserInitiated: \(Thread.current) : \(Task.currentPriority)")
			//
			// 	// detached has a different priority than the parent priority
			// 	Task.detached {
			// 		print("detached: \(Thread.current) : \(Task.currentPriority)")
			// 	}
			// }
			//
		// }
	}
}

// MARK: -  PREVIEW
struct TaskBootCamp_Previews: PreviewProvider {
	static var previews: some View {
		TaskBootCamp()
	}
}
