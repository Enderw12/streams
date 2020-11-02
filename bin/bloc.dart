import 'dart:async';

abstract class BlocState {}

abstract class BlocEvent {}

class Bloc<BlocEvent, BlocState> {
  Bloc(BlocEvent initialEvent) {
    add(initialEvent);
  }

  BlocState mapEventToState(BlocEvent event) {
    // return BlocState();
  }

  final _controller = StreamController<BlocEvent>();

  void add(BlocEvent event) {
    _controller.sink.add(event);
  }

  Stream<BlocState> get stream => _controller.stream
      .map((event) => mapEventToState(event))
      .asBroadcastStream();
}
