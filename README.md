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

## 04.Async Let

Async Let can us perform multiple asynchronous methods at the same time. When you write the await keyword and have a bunch of method on after another we are waiting for each method to finish before performing the next one.

Async Let performing the next one a singlet is actually letting us perform multiple methods at the same time and then wait for the result of all of those methods together

- The example of multiple fetch images by using async & await

```swift
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
    let image1 = try await fetchImage()
    self.images.append(image1)

    let image2 = try await fetchImage()
    self.images.append(image2)


  } catch  {

  }
}//: TASK

Task {
  do {
    let image3 = try await fetchImage()
    self.images.append(image3)

    let image4 = try await fetchImage()
    self.images.append(image4)
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
}
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/167584829-06402c4d-d818-4a89-9aab-16c35780f3e1.gif">

This is bulking up the code it doesn't seem very efficient and as you probably guessed there's a much better way to do

- The example of multiple fetch images by using async let

This is to create an async let like creating a constant except it's an asynchronous constant

```swift
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
  async let fetchImage2 = fetchImage()
  async let fetchImage3 = fetchImage()
  async let fetchImage4 = fetchImage()

  // one await keyword
  let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)

  self.images.append(contentsOf: [image1, image2, image3, image4])

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
}
```

So, async let is great for executing multiple asynchronous functions at once and then await the result of all of those functions at the same time so we can fetch a bunch of different things and then wait for all of the results to come back we update our screen

## 05.TaskGroup

If we have a whole bunch of asynchronous functions that we need to run like maybe 10 or 20. async let isn't scalable how can we run a whole bunch a group of tasks at the same time concurrently.

Apple has actually given us something called a task group in which we can create a single group of tasks and run a whole bunch of tasks concurrently

- Fetch multiple images without Task Group

You could image in that if the fetch images went to 10 or 20 or more. This is not
very scalable

```swift
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

private func fetchImage(urlString: String) async throws -> UIImage {
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
if let images = try? await manager.fetchImageWithAsyncLet() {
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
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/167993618-cb0302b0-3502-488d-9de4-dd929ebca085.gif">

There's got to be a better way to write and perform multiple concurrent asynchronous requests and the way we do that again is with the task group.

- Fetch multiple images with Task Group

```swift
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
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/167996493-ebb67190-e869-4521-a2f3-84e8e2da81d1.gif">

## 05.Continuation

When you are working with SDK and API that are not updated for swift concurrency you can use a continuation to convert them to be usable with your asynchrony swift concurrency code

- Simple async code with fetched single image from API by using async await and URLSession.shared.data

```swift
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
  let data = try await manager.getData(url: url)

  if let image = UIImage(data: data) {
    await MainActor.run(body: {
      self.image = image
    })
  }
} catch {
  print(error)
}
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
    await vm.getImage()
  }
}
}
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/169422540-a5f8a0d5-9ac5-4f12-bea6-92801cda7c26.png">

But unfortunately a lof of SDKs and APIs are not yet updated for async and await some of them maybe will be updated in the future. You want to be able to convert their SDK form as it is to async await

So, use completion handler oen of the original ways that we did asynchronous code in swift and using escaping closures

```swift
class CheckedContinuationBootCampNetworkManager {

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
}

```

```swift
// MARK: - SERVICE
class CheckedContinuationBootCampNetworkManager {
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
  // await vm.getHeartImage()
  await vm.getHeartImage2()
}
}
}
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/169425825-8de6f384-22c8-4984-ac3f-70866c061c13.png">

## 06.Struct vs Class vs Actor

### Compare with Struct and Class

To Compare them, creating the same object using a struct and a class dive into the differences

- Struct Object Code

When we create struct don't actually have to create an init

```swift
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

struct MyStruct {
var title: String
}

// MARK: - EXTENSTION
extension StructClassActorBootCamp {
private func runTest() {
print("Test Started")
structTest1()
}

private func structTest1() {
let objectA = MyStruct(title: "Starting title!")
print("ObjectA: ", objectA.title)

var objectB = objectA
print("ObjectB: ", objectB.title)

objectB.title = "Second title!"
print("ObjectB title changed.")

print("ObjectA: ", objectA.title)
print("ObjectB: ", objectB.title)
}
}
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/169478607-275acbd4-9b14-4e40-a242-e8aaa02a6d2d.png">

You will notice that when you change the title of objectB did not update, only object b's title did update because this struct is a value type and when you pass a value type. ObjectB is actually totally distinct and separate from ObjectA because it passed the values and not a reference

- Class Object Code

Class we do have to give them an actual explicit initializer

```swift
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

struct MyStruct {
var title: String
}

class MyClass {
var title: String

init(title: String) {
  self.title = title
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
}

```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/169482703-bab2e837-945c-45e0-831f-83bebe29c1d2.png">

You can notice the big difference is that both objectA and B's title changed. The struct is passing the VALUE from objectA to objectB Otherwise, the class is passing the REFERENCE from them. Here, main point is Class objectA,B are both actually pointing to the same object in memory, so that underlying reference is connected to anywhere that is pointing to that reference so both object

<img  alt="스크린샷" src="https://blog.onewayfirst.com/img/2019-03/reference-vs-value.gif">

> https://blog.onewayfirst.com/ios/posts/2019-03-19-class-vs-struct/

- Value type creates the copy (a new instance) and stores the data (on Stack Memory). Modifying the data (or the instance) does not affect the original.

- Reference type creates the shared instance that points the memory location of the data (on Heap Memory). Modifying the data affects the original.

- Mutating Struct example code

```swift
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
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/169726749-9d61ed22-a1c8-4cf1-a10c-140962ded480.png">

- Class example code

The difference of struct and class, in the struct, it has to make this variable because when we mutated the title we were chaining the object we were literally mutating this object tha actually changed. Mutating means we are going to take the current values we're going to change them we're going to create a new object with new values

```swift
class MyClass {
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

```

<img width="983" alt="image" src="https://user-images.githubusercontent.com/28912774/169921780-1ab5ad14-2bcf-4b1e-9cab-cc2ab9a7168e.png">

> https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language

![image](https://user-images.githubusercontent.com/28912774/169921973-bd2f8e10-4ac0-4df6-95f2-bcfef48c0386.png)

> https://medium.com/@vinayakkini/swift-basics-struct-vs-class-31b44ade28ae

<img width="863" alt="image" src="https://user-images.githubusercontent.com/28912774/169927133-edd579f0-6666-4420-80fa-c4e817891501.png">

> https://stackoverflow.com/questions/27441456/swift-stack-and-heap-understanding

<img width="905" alt="image" src="https://user-images.githubusercontent.com/28912774/169927792-c4f35a4f-5fe4-4e50-a326-fede8820619a.png">

> https://stackoverflow.com/questions/24232799/why-choose-struct-over-class/24232845

- What is ARC in Swift and how is it used (Automatic Reference Counting)
  in Object-C developers used to have to actually keep track of the count in Swift this is mostly done automatically for us. ARC is only for objects that are in the heap such as classes and actors

> Value types which store on stack memory such as structures and enumerating are just copying the data to data. Therefore it is not affected by ARC

> ARC is to track and manage the app's memory usage. Arc automatically frees up the memory used by class instances when those instances are no longer needed.

> Every instance of a class has a property called reference count so if reference count is greater than 0, the instance is still kept in memory otherwise, it will be removed from the memory.

- Weak and Strong reference

When you create a strong reference without using weak self, you are telling the compiler that we absolutely need self this class we need it to to still be in memory when we come back the asynchronous code if the user moves away to another screen in the app and the system tries to de-allocate this class it will then understand because there is still a reference so, Strong reference class is not going to de-allocate

What is weak self? This is making class as optional that if the class wants to de-allocate that's totally fine because if when the code comes back the asynchronous code if the class is still in memory we'll handle the response but if it is de-allocated for whatever reason

If you keep that strong reference you are keeping at least on reference count to that object in memory and so that object in memory being the class is never going to get de-allocated until all of the references are gone

So, if we make it a weak reference it's then going to make this reference an optional this reference being weak will not count towards the reference count when it is trying to figure our if this instance needs to be kept in memory still.

![image](https://user-images.githubusercontent.com/28912774/169934937-3ae12113-d50c-4612-b1a7-81f7ac771982.png)

![image](https://user-images.githubusercontent.com/28912774/169934963-8a54ed08-cc45-4f91-81ba-83fa820f17b3.png)

> https://medium.com/doyeona/automatic-reference-counting-in-swift-arc-weak-strong-unowned-925f802c1b99

### Class vs Actor

Actors are more or less the same thing as classes except they are thread safe

![image](https://user-images.githubusercontent.com/28912774/170898400-c9ed1b96-33cf-44b7-a973-76a5238be219.png)

> https://www.backblaze.com/blog/whats-the-diff-programs-processes-and-threads/

In the Multi Thread, it might access an object in the heap and then this thread might also access the same object in the heap. Now the heap is going to synchronize them and that's basically because there is noting by default that's going to stop two different threads from accessing the same object in memory.

Now both classes and actors are stored in the heap cause they are more or less the same thing the only big difference is that the actors are going to be thread safe

In the class if two different threads are accessing that class they can function at the exact same time. But in an actor if two threads are accessing the same actor one of them is probably going to have to await that other thread to finish its processes before the second thread can get into that actor

Actors require to be in an asynchronous environment and when you want to access anything inside the actor you need to await on it. If they are accessing at the same time you might run into a situation where one thread might have to literally await for the other thread to finish

```swift
actor MyActor {
	var title: String

	init(title: String) {
		self.title = title
	}

	func updaterTile(newTilte: String) {
		title = newTilte
	}
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

```

<img width="497" alt="image" src="https://user-images.githubusercontent.com/28912774/170900513-3674200e-a716-4c54-8362-1c299336422b.png">

### Warp up

1. Value vs Reference type

- Value Types : Struct, Enum, String Int, etc

  - Stored in the stack

  - Faster

  - Thread safe

  - When you assign or pass value type a new copy of data is created.

- Reference Types: Class, Function, Actor

  - Stored in the Heap

  - Slower, but synchronized

  - Not thread safe (by default)

  - When you assign or pass reference type a new reference to original instance will be created (pointer)

2. Stack vs Heap

- Stack

  - Stored value types

  - Variables allocated on the stack are stored directly to the memory, and access to this memory is very fast

  - Each thread has it's own stack

- Heap

  - Stored reference types

  - Shared across threads

3. Struct vs Class vs Actor

- Struct

  - Based on Values

  - Can be mutated

  - Stored in the Stack!

- Class

  - Based on Reference (Instance)

  - Stored in the Heap!

  - Inherit from other classes

- Actor

  - Same as Class, but thread safe!

Structs: Data Models, View
Classes: ViewModels
Actors: Shared 'Manager' and 'Data Store'

## 07.Actor

### 1.What is the problem that actor are solving?

In the actual apps a lof of times we are using background threads that use URL session fetch data from server. The important thing that as developers is background threads are all accessing the same class that you know class are not thread safe

So, if two or more threads access the same object in memory at the same time you can run into really bad problems in your app you can run into data races if not worse crashes

If you want to check thread safe to turn on Thread Sanitizer in edit Scheme

<img width="919" alt="image" src="https://user-images.githubusercontent.com/28912774/171088636-b926d53a-cd13-441c-8987-0ffc16701a68.png">

```swift
// MARK: - DATAMANAGER
class MyDataManager {
static let instance = MyDataManager()
private init() {}

var data: [String] = []

func getRandomData() -> String? {
self.data.append(UUID().uuidString)
print(Thread.current)
return data.randomElement()
}
}

// MARK: - HOME
struct HomeView: View {

let manager = MyDataManager.instance
@State private var text: String = ""
let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()

var body: some View {
ZStack {
Color.gray.opacity(0.8).ignoresSafeArea()
Text(text)
  .font(.headline)
} //: ZSTACK
.onReceive(timer) { _ in
DispatchQueue.global(qos: .background).async {
  if let data = manager.getRandomData() {
    DispatchQueue.main.async {
      self.text = data
    }
  }
}
}
}
}

// MARK: - BROWSER
struct BrowserView: View {

let manager = MyDataManager.instance
@State private var text: String = ""
let timer = Timer.publish(every: 0.01, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()

var body: some View {
ZStack {
Color.yellow.opacity(0.8).ignoresSafeArea()

Text(text)
} //: ZSTACK
.onReceive(timer) { _ in
DispatchQueue.global(qos: .default).async {
  if let data = manager.getRandomData() {
    DispatchQueue.main.async {
      self.text = data
    }
  }
}
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
```

<img width="839" alt="image" src="https://user-images.githubusercontent.com/28912774/171089503-a371fe8d-81e1-4d58-b3b7-8c30b6471a95.png">

Above the picture, you can see same pointer (0x000107a4d9d0) and different thread 7 and 1 and the same piece of memory in the heap that we can call this problem as data race (multiple threads are accessing the same class (pointer))

This is probably one of the hardest things to debug

### 2.How was this problem solved prior to actors?

- To take the class and to make it thread safe

<img height="350" alt="스크린샷" src="">

```swift
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

// MARK: - HOME
struct HomeView: View {

let manager = MyDataManager.instance
@State private var text: String = ""
let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()

var body: some View {
ZStack {
Color.gray.opacity(0.8).ignoresSafeArea()
Text(text)
  .font(.headline)
} //: ZSTACK
.onReceive(timer) { _ in
DispatchQueue.global(qos: .background).async {
  manager.getRandomData { title in
    if let data = title {
      DispatchQueue.main.async {
        self.text = data
      }
    }
  }
}
}
}
}

// MARK: - BROWSER
struct BrowserView: View {

let manager = MyDataManager.instance
@State private var text: String = ""
let timer = Timer.publish(every: 0.01, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()

var body: some View {
ZStack {
Color.yellow.opacity(0.8).ignoresSafeArea()

Text(text)
} //: ZSTACK
.onReceive(timer) { _ in
DispatchQueue.global(qos: .default).async {
manager.getRandomData { title in
  if let data = title {
    DispatchQueue.main.async {
      self.text = data
    }
  }
}
}
}
}
}
```

That's pretty much the solution to making classes thread safe. It is purely put all of your functions into a dispatchQueue a lock or a queue and then they will be thread safe because this will basically when all the functions reach this line

### 3.Actors can solve the problem!

So more or less an actor is a class that automatically for the thread safe because we are in the asynchronous swift concurrency environment we no longer have to use completion handlers either

```swift
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

func getRandomData() -> String? {
  self.data.append(UUID().uuidString)
  print(Thread.current)
  return self.data.randomElement()
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
```

### 4.nonisolated

So, every time we want to access something inside the actor we then need to await to get into that actor because all of the code inside the actor is isolated. It is isolated to that actor so then thread safe

Sometimes, where you have some code in your actor that actually does not need to be isolated to the actor

```swift
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
