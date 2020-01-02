A starting point for writing a NECTA STD 7 results app using dart programming language.

```dart

import 'package:matokeo_std7/blocs/menu_bloc.dart';

void main(){
  //MenuBloc loads NECTA STD 7 results 
   var menuBloc = MenuBloc();
  
    menuBloc.listen((state) {
      print(state);
      if (state is MenuLink) {
        print(state.link);
      }
  
      if (state is MenuLoading) {
        print('loading....');
      }
  
      if (state is MenuLoadingCompleted) {
        print('loading completed!');
      }
    }, onError: (e) {
      print('Error -> ${e.toString()}');
    });
  
    try {
      //loading the main menu
      await menuBloc.loadMenu();
    } catch (e) {
      print(e);
    }
}
 


```