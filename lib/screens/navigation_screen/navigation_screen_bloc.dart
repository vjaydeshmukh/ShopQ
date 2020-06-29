import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_screen_events.dart';
import 'navigation_screen_states.dart';

class NavigationScreenBloc extends Bloc<NavigationScreenEvents, NavigationScreenStates>{
  int currentPageIndex = 0;
  @override
  NavigationScreenStates get initialState => ShowPageState(currentPageIndex);

  @override
  Stream<NavigationScreenStates> mapEventToState(NavigationScreenEvents event) async*{
    if(event is PageTapped){
      this.currentPageIndex = event.index;
      yield ShowPageState(currentPageIndex);
    }
  }

}