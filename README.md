## SwiftUI Thinking Concurrency code 모음

## 👉 [강의 채널 바로가기](https://www.youtube.com/playlist?list=PLwvDm4Vfkdphr2Dl4sY4rS9PLzPdyi8PM)

---

## 01.Do-Catch, Try and Throws

```swift
import SwiftUI

// MARK: -  DATA SERVICE
class DoCatchTryThrowsBootCampDataManager {
let isActive: Bool = false

func getTitle() -> String? {
  if isActive {
    return "New Text"
  } else {
    return nil
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
  let newTilte = manager.getTitle()
  if let newTilte = newTilte {
    self.text = newTilte
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
```

Above code, an optional right as a developer we know that is returning optional because it failed to get the text but if you're sharing this code if other people are using this code that's not very clear and it might look like a bug in your app if maybe things are just not updating. Take it a step further and maybe return an error instead

This is good this is a bit better in our code now the ability to check for real values and also check for errors but This is kind of a hassle for us as developers because really we want to return a result here either this function should be successful or it should fail it shouldn't really return us a title end an error. It's probably only be getting one or the other there's never really a use case where we're going to get both of these

```swift
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
}

// MARK: -  VIEWMODEL
class DoCatchTryThrowsBootCampViewModel: ObservableObject {
// MARK: -  PROPERTY
@Published var text: String = "Starting text."
let manager = DoCatchTryThrowsBootCampDataManager()

// MARK: -  INIT
// MARK: -  FUNCTION
func fetchTitle() {
  let returnedValue = manager.getTitle()
  if let newTilte = returnedValue.title {
    self.text = newTilte
  } else if let error = returnedValue.error {
    self.text = error.localizedDescription
  }
}
}

```

  <img height="350"  alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/165196979-6c5f118a-19e0-49aa-bec5-7ea1e1ec353a.gif">

So, It's like little but better now because this is if you're sharing this with other developers or even if you're just coming back to this successful, failure state. It's no longer giving us back both and then we have to kind of manage which one is which and look at both cases and look at all the data instead now we just get back a result

```swift
class DoCatchTryThrowsBootCampDataManager {
	let isActive: Bool = false

	func getTitle2() -> Result<String, Error> {
		if isActive {
			return .success("New Text!")
		} else {
			return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
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
		let result = manager.getTitle2()

		switch result {
		case .success(let newTitile):
			self.text = newTitile
		case .failure(let error):
			self.text = error.localizedDescription
		}
	}
}
```

- To use throw keyWord and then handle error using do try catch statement

```swift
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
}

// MARK: -  VIEWMODEL
class DoCatchTryThrowsBootCampViewModel: ObservableObject {
// MARK: -  PROPERTY
@Published var text: String = "Starting text."
let manager = DoCatchTryThrowsBootCampDataManager()

// MARK: -  INIT
// MARK: -  FUNCTION
func fetchTitle() {
  do {
    let newTitle = try manager.getTile3()
    self.text = newTitle
  } catch {
    self.text = error.localizedDescription
  }
}
}
```

- When you use throw statement and then initialized code to use try? include return nil when it comes error (Not necessary Do catch statement)

```swift
// MARK: -  DATA SERVICE
class DoCatchTryThrowsBootCampDataManager {
	let isActive: Bool = true


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

  let newTitle = try? manager.getTile3()
  if let newTitle = newTitle {
    self.text = newTitle
  }
}
}
```

```swift
// MARK: -  FUNCTION
func fetchTitle() {
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
```

Most of our asynchronous code in our asynchronous functions are going to actually be functions that throw errors so this syntax is going to be really common in async await and when you're using throws you're almost always using do catch statement

## 02 Async and Await

For the example to do delay task compare with `DispatchQueue.main.asyncAfter` and `Async & Await`

`DispatchQueue.main.asyncAfter`

```swift
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
			vm.addTilte1()
			vm.addTilte2()
		}
	}
}

```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/166626670-38907390-affa-457a-b3db-41c74db78c62.gif">

`Async & Await`

```swift
import SwiftUI

// MARK: -  VIEWMODEL
class AsyncAwaitBootcampViewModel: ObservableObject {
// MARK: -  PROPERTY
@Published var dataArray: [String] = []
// MARK: -  INIT
// MARK: -  FUNCTION
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
}
}
}
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/166626813-3820ddd9-d27c-4de6-8d3b-b4ed467e4386.gif">

### Download image with Async and Await

Compare with different asynchronous way such as @escaping, combine and Async & Await when it comes from downloading image

- Case 1. Download image with @escaping

```swift
import SwiftUI

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
}

// MARK: -  VIEWMODEL
class DownloadImageAsyncViewModel: ObservableObject {
// MARK: -  PROPERTY
@Published var image: UIImage? = nil
let loader = DownloadImageAsyncImageLoader()
// MARK: -  INIT
// MARK: -  FUNCTION
func fetchImage() {
loader.downloadWithEscaping { [weak self] image, error in
  DispatchQueue.main.async {
    self?.image = image
  }
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
  vm.fetchImage()
}
}
}
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/165654782-21df8047-6f96-46cb-973a-fecd7baaf234.png">

- Case 2. Download image with Combine

```swift
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


func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
URLSession.shared.dataTaskPublisher(for: url)
  .map(handleResponse)
  .mapError({ $0 })
  .eraseToAnyPublisher()
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
func fetchImage() {
  loader.downloadWithCombine()
    .receive(on: DispatchQueue.main)
    .sink { _ in

    } receiveValue: { [weak self] image in
        self?.image = image
    }
    .store(in: &cancellables)
}
}
```

- Case 3. Download image with Async and Await

```swift
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
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/165670469-98b0dcb7-05c8-41a1-a21e-de96a07b2499.png">

## 03.Task

There is a whole bunch of different types of tasks and using task groups and detach tasks

- Basic Task with async/await

```swift
// MARK: -  VIEWMODEL
class TaskBootCampViewModel: ObservableObject {
// MARK: -  PROPERTY
@Published var image: UIImage? = nil
// MARK: -  INIT
// MARK: -  FUNCTION
func fetchImage() async {
do {
  guard let url = URL(string: "https://picsum.photos/1000") else { return }
  let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
  self.image = UIImage(data: data)
} catch  {
  print(error.localizedDescription)
}
}
}

// MARK: -  VIEW
struct TaskBootCamp: View {
// MARK: -  PROPERTY
@StateObject private var vm = TaskBootCampViewModel()
// MARK: -  BODY
var body: some View {
VStack(spacing: 40) {
if let image = vm.image {
  Image(uiImage: image)
    .resizable()
    .scaledToFit()
    .frame(width: 200, height: 200)
}
} //: VSTACK
.onAppear {
Task {
  await vm.fetchImage()
}
}
}
}
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/166629300-b3369619-4bc0-4f62-92c4-3aeb61bb3a66.png">

- Set up task priority

```swift
// MARK: -  VIEW
struct TaskBootCamp: View {
// MARK: -  PROPERTY
@StateObject private var vm = TaskBootCampViewModel()
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
.onAppear {

// The order of task priorities
  Task(priority: .high) {
    // Task.yield() just can wait and let other tasks go in front of it if there are other tasks
    await Task.yield()
    print("High: \(Thread.current) : \(Task.currentPriority)")
  }
  Task(priority: .userInitiated) {
    print("UserInitiated: \(Thread.current) : \(Task.currentPriority)")
  }
  Task(priority: .medium) {
    print("Medium: \(Thread.current) : \(Task.currentPriority)")
  }

  Task(priority: .low) {
    print("Low: \(Thread.current) : \(Task.currentPriority)")
  }
  Task(priority: .utility) {
    print("Utility: \(Thread.current) : \(Task.currentPriority)")
  }
  Task(priority: .background) {
    print("Background: \(Thread.current) : \(Task.currentPriority)")
  }
```

<img width="1175" alt="image" src="https://user-images.githubusercontent.com/28912774/166631442-d9745af3-4653-4106-aeff-f90cf20d8dc4.png">

- Add child Tasks

```swift
// child tasks will inherit all of the metadata from parent tasks
Task(priority: .userInitiated) {
  print("UserInitiated: \(Thread.current) : \(Task.currentPriority)")

  // detached has a different priority than the parent priority
  Task.detached {
    print("detached: \(Thread.current) : \(Task.currentPriority)")
  }
}
```

<img width="1168" alt="image" src="https://user-images.githubusercontent.com/28912774/166632745-eeed9b4a-84fa-403d-b3e0-1f3333d2d9fe.png">

- Cancel Tasks

There's one of the most important things about tasks because when you create so many tasks in your app. But, if you move away from the screen or does something else we also want the ability to cancel to save power wise and might want to cancel them if things move off screen

```swift
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
.onDisappear(perform: {
// when display off then cancel tasks during process
fetchImageTask?.cancel()
})
.onAppear {
fetchImageTask = Task {
  print(Thread.current)
  print(Task.currentPriority)
  await vm.fetchImage()
}
}
}
}
```

<img width="1082" alt="image" src="https://user-images.githubusercontent.com/28912774/166635105-bcb7f0a6-fd6b-4791-bf61-77e8a8c7cd4c.png">

- Task modifier (iOS 15)

`.task { code }` : Adds an asynchronous task to perform when this view appears

```swift
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
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/166635777-b97fd276-26c8-4a7f-b87d-99820b78c765.gif">

- `Task.checkCancellation() throws`

If the task is cancelled this will throw an error

```swift
for x in array {
  // working loop right here if it was running this after each piece of work it would check if the task is canceled and then it would stop if the task was canceled and it would throw back an error our of this function. Obviously, not throwing so we have to deal with all of that if you have long running tasks and you are going to cancel them you might want to throw in an occasional check for the task actually being cancelled

  try Task.checkCancellation()

}
```

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

---

<!-- <p align="center">
  <img height="350"  alt="스크린샷" src="">
</p> -->

<!-- README 한 줄에 여러 screenshot 놓기 예제 -->
<!-- <p>
   <img height="350" alt="스크린샷" src="">
   <img height="350" alt="스크린샷" src="">
   <img height="350" alt="스크린샷" src="">
</p> -->

---

<!-- 🔶 🔷 📌 🔑 👉 -->

## 🗃 Reference

Swift Concurrency (Intermediate Level) - [https://www.youtube.com/playlist?list=PLwvDm4Vfkdphr2Dl4sY4rS9PLzPdyi8PM](https://www.youtube.com/playlist?list=PLwvDm4Vfkdphr2Dl4sY4rS9PLzPdyi8PM)
