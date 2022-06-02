//
//  GlobalActorBootCamp.swift
//  SwiftUThiningConcurrency
//
//  Created by Jacob Ko on 2022/06/02.
//

import SwiftUI

// MARK: - Global Actor
@globalActor struct MyFirstGlobalActor {
	static var shared = MyNewDatamanager()
}


// MARK: - DATAMANAGER
actor MyNewDatamanager {
	
	func getDataFromDB() -> [String] {
		return ["One", "Two", "Three", "Four"]
	}
}

// MARK: - VIEWMODEL
class GlobalActorBootCampViewModel: ObservableObject {
	// MARK: -  PROPERTY
	@Published var dataArray: [String] = []
	let manager = MyFirstGlobalActor.shared
	// MARK: -  INIT
	// MARK: -  FUNCTION
	@MyFirstGlobalActor
	 func getData()  {
		
		// Heavy Complex Methods
		// synchronization is performed through the shared actor instance to ensure
		// mutually-exclusive access to the declaration.
		 Task {
			 let data = await manager.getDataFromDB()
			 self.dataArray = data
		 }
	}
}

// MARK: - VIEW
struct GlobalActorBootCamp: View {
	// MARK: -  PROPERTY
	@StateObject private var vm = GlobalActorBootCampViewModel()
	// MARK: -  BODY
	var body: some View {
		ScrollView {
			VStack {
				ForEach(vm.dataArray, id: \.self) {
					Text($0)
						.font(.headline)
				}
			} //: VSTACK
		} //: SCROLL
		.task {
			await vm.getData()
		}
	}
}

// MARK: -  PREVIEW
struct GlobalActorBootCamp_Previews: PreviewProvider {
	static var previews: some View {
		GlobalActorBootCamp()
	}
}
