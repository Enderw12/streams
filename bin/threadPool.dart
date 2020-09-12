class Executor {
  /// incapsulates threading logics: generates workers of some type and uses them to do as much jobs as needed
  int maxWorkers;
  int attempts;
  Executor({this.maxWorkers = 10, this.attempts = 1});
  List<Worker> pool = [];
  List<Task> tasks = [];
  bool done = true;

  void add(argument) {
    tasks.add(Task(argument, attempts));
  }

  Future<Iterable> map(Function function, Iterable arguments) async {
    done = false;
    for (var argument in arguments) {
      tasks.add(Task(argument, attempts));
    }
    final results = [];
    for (var task in tasks) {
      results.add(null);
    }

    while (tasks.lastIndexWhere((task) => task.attempts != 0) >= 0) {
      for (var i; i <= tasks.length; i++) {
        if (tasks[i].attempts > 0) {
          if (pool.length < maxWorkers) {
            var worker = freeWorker;
            if (worker != null) {
              worker.argument = tasks[i].argument;
              tasks[i].attempts--;
              results[i] = worker.result;
            }
          }
        }
      }
    }

    return results;
  }

  Worker get freeWorker {
    if (pool.isEmpty) {
      pool.add(Worker());
      return pool.first;
    } else {
      for (var i = 0; i < pool.length - 1; i++) {
        if (pool[i].busy == false) return pool[i];
        if (i == pool.length - 1) {
          pool.add(Worker());
          return pool.last;
        } else {
          return null;
        }
      }
    }
  }
}

class Worker {
  Function function;
  var argument;

  /// maybe i have to do this a type with [attemptsLeft] and a [dynamic] [argument]
  bool busy = false;
  Worker({this.function, this.argument});

  Future get result async {
    busy = true;
    var res;
    try {
      res = await function(argument);
    } catch (e) {
      // replace with logging here
      print(e.toString() +
          'FakeLog: Exception caught when tried ${function} on argument ${argument}');
    }
    busy = false;
    return res;
  }
}

class Task {
  int attempts;
  final argument;
  Task(this.argument, this.attempts);
}
