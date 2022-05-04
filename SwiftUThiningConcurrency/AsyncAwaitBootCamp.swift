//
//  AsyncAwaitBootCamp.swift
//  SwiftUThiningConcurrency
//
//  Created by Jacob Ko on 2022/05/03.
//

import SwiftUI

// MARK: -  VIEWMODEL
class AsyncAwaitBootcampViewModel: ObservableObject {
	// MARK: -  PROPERTY
	@Published var dataArray: [String] = []
	// MARK: -  INIT
	// MARK: -  FUNCTION
	func addTilte1() {
		// main thread
		DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
			self.dataArray.append("Title1: \(Thread.current)")
		}
	}
	
	func addTilte2() {
		// global thread
		DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
			let title = "Title2: \(Thread.current)"
			DispatchQueue.main.async {
				self.dataArray.append(title)
				
				// main thread
				let title3 = "Title3: \(Thread.current)"
				self.dataArray.append(title3)
			}
		}
	}
	
	func addAuthor1() async {
		let author1 = "Autor1: \(Thread.current)"
		self.dataArray.append(author1)
		
		try? await Task.sleep(nanoseconds: 2_000_000_000) // delay 2 secs like DispachQueue.main.asyncAfter(dealine: .now() + 2.0)
		// try? await doSomething() // all processing tasks on main thread
		
		// author2 : global thread
		let author2 = "Autor2: \(Thread.current)"
		await MainActor.run(body: {
			self.dataArray.append(author2)
			
			// author3: main thread
			let author3 = "Autor3: \(Thread.current)"
			self.dataArray.append(author3)
		})
	}
	
	func addSomething() async {
		try? await Task.sleep(nanoseconds:  2_000_000_000)
		let something1 = "Something1: \(Thread.current)"
		await MainActor.run(body: {
			self.dataArray.append(something1)
			
			let something2 = "Something2: \(Thread.current)"
			self.dataArray.append(something2)
		})
	}
}

// MARK: -  VIEW
struct AsyncAwaitBootCamp: View {
	@StateObject private var vm = AsyncAwaitBootcampViewModel()
	// MARK: -  PROPERTY
	// MARK: -  BODY
	var body: some View {
		List {
			ForEach(vm.dataArray, id: \.self) {
				Text($0)
			}
		} //: LIST
		.onAppear {
			Task {
				await vm.addAuthor1()
				await vm.addSomething()
			
				let finalText = "FINAL TEXT: \(Thread.current)"
				vm.dataArray.append(finalText)
			}
			// vm.addTilte1()
			// vm.addTilte2()
		}
	}
}

// MARK: -  PREVIEW
struct AsyncAwaitBootCamp_Previews: PreviewProvider {
	static var previews: some View {
		AsyncAwaitBootCamp()
	}
}
