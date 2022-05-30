//
//  StructClassActorBootCamp.swift
//  SwiftUThiningConcurrency
//
//  Created by Jacob Ko on 2022/05/20.
//

import SwiftUI

struct StructClassActorBootCamp: View {
	// MARK: -  PROPERTY
	
	// MARK: -  BODY
	var body: some View {
		Text("Hello, World!")
			.onAppear {
				runTest()
			}
	}
}

// MARK: -  PREVIEW
struct StructClassActorBootCamp_Previews: PreviewProvider {
	static var previews: some View {
		StructClassActorBootCamp()
	}
}


// MARK: - EXTENSTION
extension StructClassActorBootCamp {
	
	private func runTest() {
		print("Struct Test")
		structTest1()
		printDivider()
		print("Class Test")
		classTest1()
		printDivider()
		actorTest1()
		// structTest2()
		// printDivider()
		// classTest2()
	}
	
	private func printDivider() {
		print("""
 
 -----------------------------
 """)
	}
	
	private func structTest1() {
		let objectA = MyStruct(title: "Starting title!")
		print("ObjectA: ", objectA.title)
		
		print("Pass the VALUES of objectA to objectB")
		var objectB = objectA
		print("ObjectB: ", objectB.title)
		
		objectB.title = "Second title!"
		print("ObjectB title changed.")
		
		print("ObjectA: ", objectA.title)
		print("ObjectB: ", objectB.title)
	}
	
	private func classTest1() {
		let objectA = MyClass(title: "Starting Title")
		print("ObjectA: ", objectA.title)
		
		// When we are changing the title here not chaning the object itself. We are changing the title inside the object
		print("Pass the REFERENCE of objectA to objectB")
		let objectB = objectA
		print("ObjectB: ", objectB.title)
		
		objectB.title = "Second title!"
		print("ObjectB title changed.")
		
		print("ObjectA: ", objectA.title)
		print("ObjectB: ", objectB.title)
	}
	
	private func actorTest1() {
		Task {
			let objectA = MyActor(title: "Starting Title")
			await print("ObjectA: ", objectA.title)
			
			print("Pass the REFERENCE of objectA to objectB")
			let objectB = objectA
			await print("ObjectB: ", objectB.title)
			
			// actor is now thread safe so we can't chnage the value from outside the actor itself
			// objectB.title = "Second title!"
			await objectB.updaterTile(newTilte: "Second title!")
			print("ObjectB title changed.")
			
			await print("ObjectA: ", objectA.title)
			await print("ObjectB: ", objectB.title)
		}
	}
}


// mutating anywhere but, it is mutating it when you change the title
struct MyStruct {
	var title: String
}

// Immutable struct
struct CustomStruct {
	let title: String
	
	func updateTitle(newTitle: String) -> CustomStruct {
		CustomStruct(title: newTitle)
	}
}

// MutatingStruct you have to add the workd mutaing and want to restuct maybe the way this struct gets updated
struct MutatingStruct {
	private(set) var title: String
	
	init(title: String) {
		self.title = title
	}
	
	mutating func updaterTile(newTilte: String) {
		title = newTilte
	}
}


extension StructClassActorBootCamp {
	
	private func structTest2() {
		print("structTest2")
		
		var struct1 = MyStruct(title: "Title1")
		print("Struct1: ", struct1.title)
		struct1.title = "Title2"
		print("Struct1: ", struct1.title)
		
		var struct2 = CustomStruct(title: "Title1")
		print("Struct2: ", struct2.title)
		struct2 = CustomStruct(title: "Title2")
		print("Struct2: ", struct2.title)
		
		var struct3 = CustomStruct(title: "Title1")
		print("Struct3: ", struct3.title)
		struct3 = struct3.updateTitle(newTitle: "Title2")
		print("Struct3: ", struct3.title)
		
		var struct4 = MutatingStruct(title: "Title1")
		print("Struct4: ", struct4.title)
		struct4.updaterTile(newTilte: "Title2")
		print("Struct4: ", struct4.title)
	}
}


class MyClass {
	var title: String
	
	init(title: String) {
		self.title = title
	}
	
	func updaterTile(newTilte: String) {
		title = newTilte
	}
}

actor MyActor {
	var title: String
	
	init(title: String) {
		self.title = title
	}
	
	func updaterTile(newTilte: String) {
		title = newTilte
	}
}

extension StructClassActorBootCamp {
	
	private func classTest2() {
		print("classTest2")
		
		let class1 = MyClass(title: "Title1")
		print("Class1: ", class1.title)
		class1.title = "Title2"
		print("Class1: ", class1.title)
		
		let class2 = MyClass(title: "Title1")
		print("Class2: ", class2.title)
		class2.updaterTile(newTilte: "Title2")
		print("Class2: ", class2.title)
	}
}

