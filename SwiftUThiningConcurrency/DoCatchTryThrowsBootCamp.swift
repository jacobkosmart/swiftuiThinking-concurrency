//
//  DoCatchTryThrowsBootCamp.swift
//  SwiftUThiningConcurrency
//
//  Created by Jacob Ko on 2022/04/26.
//

import SwiftUI

// MARK: -  DATA SERVICE
class DoCatchTryThrowsBootCampDataManager {
	let isActive: Bool = false
	
	func getTitle() -> (title:String?, error: Error?) {
		if isActive {
			return ("New Text",nil)
		} else {
			return (nil, URLError(.badURL))
		}
	}
	
	func getTitle2() -> Result<String, Error> {
		if isActive {
			return .success("New Text!")
		} else {
			return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
		}
	}
	
	// throws meaning it can throw
	func getTile3() throws -> String {
		if isActive {
			return "New Text!"
		} else {
			throw URLError(.badServerResponse)
		}
	}
	
	func getTile4() throws -> String {
		if isActive {
			return "Final Text!"
		} else {
			throw URLError(.badServerResponse)
		}
	}
}

// MARK: -  VIEWMODEL
class DoCatchTryThrowsBootCampViewModel: ObservableObject {
	// MARK: -  PROPERTY
	@Published var text: String = "Starting text."
	let manager = DoCatchTryThrowsBootCampDataManager()
	
	// MARK: -  INIT
	// MARK: -  FUNCTION
	func fetchTitle() {
		/*
		let returnedValue = manager.getTitle()
		if let newTilte = returnedValue.title {
			self.text = newTilte
		} else if let error = returnedValue.error {
			self.text = error.localizedDescription
		}
		 */
		/*
		let result = manager.getTitle2()
		
		switch result {
		case .success(let newTitile):
			self.text = newTitile
		case .failure(let error):
			self.text = error.localizedDescription
		}
		 */
		
		// let newTitle = try? manager.getTile3()
		// if let newTitle = newTitle {
		// 	self.text = newTitle
		// }
		
		do {
			let newTitle = try? manager.getTile3()
			if let newTitle = newTitle {
				self.text = newTitle
			}
			let finalTile = try manager.getTile4()
			self.text = finalTile
		
		} catch {
			self.text = error.localizedDescription
		}
	}
}

// MARK: -  VIEW
struct DoCatchTryThrowsBootCamp: View {
	// MARK: -  PROPERTY
	@StateObject private var vm = DoCatchTryThrowsBootCampViewModel()
	// MARK: -  BODY
	var body: some View {
		Text(vm.text)
			.frame(width: 300, height: 300)
			.background(Color.blue)
			.onTapGesture {
				vm.fetchTitle()
			}
	}
}

// MARK: -  PREVIEW
struct DoCatchTryThrowsBootCamp_Previews: PreviewProvider {
	static var previews: some View {
		DoCatchTryThrowsBootCamp()
	}
}
