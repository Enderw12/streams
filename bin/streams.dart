import 'dart:async';

import 'dart:math';

import 'bloc.dart';

void main() {
  final bloc = MyBloc();

  // simulating repeated event (eg pressing ++ counter button)
  Stream<MyEvent> sequenceOfEvents =
      fc().map((event_number) => MyEvent(event_number));

  //

  sequenceOfEvents.listen((event) {
    bloc.add(event);
  });

  bloc.stream.listen((state) {
    print(state.title);
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

class MyState extends BlocState {
  final String title;
  MyState(this.title);
}

class MyEvent extends BlocEvent {
  final int turn;
  MyEvent(this.turn);
}

class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(MyEvent(0));

  @override
  MyState mapEventToState(MyEvent event) {
    return MyState('State #${event.turn}');
  }
}
