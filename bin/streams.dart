import 'dart:async';

import 'dart:math';

void main() {
  final bloc = MyBloc();

  // simulating repeated event (eg pressing ++ counter button)
  Stream<MyEvent> sequenceOfEvents =
      fc().map((event_number) => MyEvent(event_number));

  //

  sequenceOfEvents.listen((event) {
    bloc.add(event);
  });

  bloc.stream.listen((event) {
    print(event.title);
  });
}

// generator just for demonstartion
Stream<int> fc() async* {
  while (true) {
    final int i = Random().nextInt(1000);
    await Future.delayed(Duration(milliseconds: i));
    yield i;
  }
}

abstract class BlocState {}

abstract class BlocEvent {}

class Bloc<BlocEvent, BlocState> {
  BlocState mapEventToState(BlocEvent event) {
    // return BlocState();
  }

  final _controller = StreamController<BlocEvent>();

  StreamSink<BlocEvent> get event_sink => _controller.sink;

  void add(BlocEvent event) {
    event_sink.add(event);
  }

  Stream<BlocState> get stream => _controller.stream
      .map((event) => mapEventToState(event))
      .asBroadcastStream();
}

class MyState extends BlocState {
  final String title;
  MyState(this.title);
}

class MyEvent extends BlocEvent {
  final int turn;
  MyEvent(this.turn);
}

class MyBloc extends Bloc<MyEvent, MyState> {
  @override
  MyState mapEventToState(MyEvent event) {
    return MyState('State #${event.turn}');
  }
}
