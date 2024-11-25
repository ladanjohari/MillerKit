import Foundation

extension Collection {
  func parallelMap<T>(
    parallelism requestedParallelism: Int? = nil,
    _ transform: @escaping (Element) async throws -> T
  ) async throws -> [T] {
    let defaultParallelism = 2
    let parallelism = requestedParallelism ?? defaultParallelism

    let n = self.count
    if n == 0 {
      return []
    }

    return await try Task.withGroup(resultType: (Int, T).self) { group in
      var result = Array<T?>(repeatElement(nil, count: n))

      var i = self.startIndex
      var submitted = 0

      func submitNext() async throws {
        if i == self.endIndex { return }

        await group.add { [submitted, i] in
          let value = await try transform(self[i])
          return (submitted, value)
        }
        submitted += 1
        formIndex(after: &i)
      }

      // submit first initial tasks
      for _ in 0..<parallelism {
        await try submitNext()
      }

      // as each task completes, submit a new task until we run out of work
      while let (index, taskResult) = await try! group.next() {
        result[index] = taskResult

        await try Task.checkCancellation()
        await try submitNext()
      }

      assert(result.count == n)
      return Array(result.compactMap { $0 })
    }
  }
}
