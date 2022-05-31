//
//  ActorBootCamp.swift
//  SwiftUThiningConcurrency
//
//  Created by Jacob Ko on 2022/05/31.
//

import SwiftUI

// MARK: - DATAMANAGER
class MyDataManager {
	static let instance = MyDataManager()
	private init() {}
	
	var data: [String] = []
	private let lock = DispatchQueue(label: "com.MyApp.MyDataManager")
	
	func getRandomData(completionHandler: @escaping (_ title: String?) -> ()) {
		lock.async {
			self.data.append(UUID().uuidString)
			print(Thread.current)
			completionHandler(self.data.randomElement())
		}
	}
}

actor MyActorDataManager {
	static let instance = MyActorDataManager()
	private init() {}
	
	var data: [String] = []
	
	nonisolated let myRandomText = "Someting new"
	
	func getRandomData() -> String? {
		self.data.append(UUID().uuidString)
		print(Thread.current)
		return self.data.randomElement()
	}
	
	// this function is not really worried about thread safety because we know just going to get this returned new data back
	// in the actor, but we don't want to get the data await -> add nonisolated
	nonisolated func getSaveData() -> String {
		return "New Data"
	}
}

// MARK: - HOME
struct HomeView: View {
	
	let manager = MyActorDataManager.instance
	@State private var text: String = ""
	let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
	
	var body: some View {
		ZStack {
			Color.gray.opacity(0.8).ignoresSafeArea()
			Text(text)
				.font(.headline)
		} //: ZSTACK
		.onAppear(perform: {
			let newString = manager.getSaveData()
			let newString2 = manager.myRandomText
			Task {
				await manager.data
			}
		})
		.onReceive(timer) { _ in
			Task {
				if let data = await manager.getRandomData() {
					await MainActor.run(body: {
						self.text = data
					})
				}
			}//: TASK
		}
	}
}

// MARK: - BROWSER
struct BrowserView: View {
	
	let manager = MyActorDataManager.instance
	@State private var text: String = ""
	let timer = Timer.publish(every: 0.01, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
	
	var body: some View {
		ZStack {
			Color.yellow.opacity(0.8).ignoresSafeArea()
			
			Text(text)
		} //: ZSTACK
		.onReceive(timer) { _ in
			Task {
				if let data = await manager.getRandomData() {
					await MainActor.run(body: {
						self.text = data
					})
				}
			}//: TASK
		}
	}
}

struct ActorBootCamp: View {
	// MARK: -  PROPERTY
	// MARK: -  BODY
	var body: some View {
		TabView {
			HomeView()
				.tabItem {
					Label("Home", systemImage: "house.fill")
				}
			BrowserView()
				.tabItem {
					Label("Browse", systemImage: "magnifyingglass")
				}
		}
	}
}

// MARK: -  PREVIEW
struct ActorBootCamp_Previews: PreviewProvider {
	static var previews: some View {
		ActorBootCamp()
	}
}
