/**
 * Copyright 2019 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'package:matokeo_std7/blocs/menu_bloc.dart';

void run_menu_bloc_example() async {
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
    await menuBloc.loadMenu();
  } catch (e) {
    print(e);
  }
}

void main() async {
  run_menu_bloc_example();
}
