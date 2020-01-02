/*-------------------States--------------------------*/

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:matokeo_core/matokeo_core.dart';

import '../models/result_link.dart';

class MenuState {}

class MenuLoading extends MenuState {}

class MenuLoadingCompleted extends MenuState {}

class MenuLink extends MenuState with EquatableMixin {
  final ResultLink link;

  MenuLink(this.link);

  @override
  List<Object> get props => [link];
}

/*------------Events------------------------*/
class _MenuEvent {}

class _MenuLoadingEvent extends _MenuEvent {}

class _MenuLinkEvent extends _MenuEvent with EquatableMixin {
  final ResultLink link;

  _MenuLinkEvent(this.link);

  @override
  List<Object> get props => [link];
}

class _MenuLoadingCompletedEvent extends _MenuEvent {}

/*------------Parsers------------------------*/

const String _NECTA_MENU_URL = 'https://www.necta.go.tz/psle_results';

class Std7MenuXmlParser with ParserMixin {
  Parser nectaMenuMainParser() {
    var li = nectaMenuLinkParser();
    var ul = parentElement('ul', li);
    var legend = nectaMenuYearParser();
    var inner =
        spaceOptional() & legend & spaceOptional() & ul & spaceOptional();
    return parentElement('fieldset', inner).flatten();
  }

  Parser nectaMenuYearParser() => element('legend');

  Parser nectaMenuLinkParser() => element('li');

  List<String> getNectaMenu(String input) => getParserResults(
        parser: nectaMenuMainParser(),
        input: input,
      );

  int getYear(String input) {
    final year = getElementText(
        tag: 'legend',
        input: getParserResult(
          parser: nectaMenuYearParser(),
          input: input,
        ));
    try {
      return int.parse(year);
    } catch (_) {
      return null;
    }
  }

  String getUrl(String input) {
    var li = getParserResult(
      parser: nectaMenuLinkParser(),
      input: input,
    ).trim();

    var a = getParserResult(parser: element('a'), input: li);

    var url = getAttributeValue(tag: 'a', attribute: 'href', input: a);
    if (url.isEmpty) {
      url = getAttributeValue(tag: 'li', attribute: 'href', input: li);
    }

    return url.isNotEmpty ? url : null;
  }
}

final _menuParser = Std7MenuXmlParser();

Future<List<ResultLink>> getStd7MenuLinks(String input) async {
  var menuList = _menuParser.getNectaMenu(input);

  // ignore: omit_local_variable_types
  List<ResultLink> links = [];
  for (var menuItem in menuList) {
    // ignore: omit_local_variable_types
    final int year = _menuParser.getYear(menuItem);
    // ignore: omit_local_variable_types
    final String url = _menuParser.getUrl(menuItem);

    if ((year != null) && (url != null)) {
      links.add(ResultLink(year.toString(), url));
    }
  }
  return links;
}

/*-------------------Bloc--------------------------*/

class MenuBloc extends Bloc<_MenuEvent, MenuState> {
  Future<void> loadMenu() async {
    dispatchEvent(_MenuLoadingEvent());

    try {
      var html = await getCleanedHtml(
        _NECTA_MENU_URL,
        dirtyTags: <DirtyTag>{
          const DirtyTag(start: '<meta', end: '>'),
          const DirtyTag(start: '<script', end: '</script>'),
          const DirtyTag(start: '<title>', end: '</title>'),
          const DirtyTag(start: '< rel', end: '>'),
          const DirtyTag(start: '<rel', end: '>'),
          const DirtyTag(start: '<style>', end: '</style>'),
          const DirtyTag(start: '<link', end: '>'),
          const DirtyTag(start: '<!', end: '->'),
        },
        keepTags: const <String>[
          'div',
          'h1',
          'legend',
          'li',
          'ul',
          'table',
          'body',
          'fieldset',
          'a'
        ],
        removeCommonDirtTags: false,
      );

      var list = await getStd7MenuLinks(html);

      for (var link in list) {
        dispatchEvent(_MenuLinkEvent(link));
      }
      dispatchEvent(_MenuLoadingCompletedEvent());
    } catch (e) {
      throw MatokeoBlocException(e.toString());
    }
  }

  @override
  Stream<MenuState> mapEventToState(_MenuEvent event) async* {
    if (event is _MenuLoadingEvent) {
      yield MenuLoading();
    } else if (event is _MenuLinkEvent) {
      yield MenuLink(event.link);
    } else if (event is _MenuLoadingCompletedEvent) {
      yield MenuLoadingCompleted();
    } else {
      throw MatokeoBlocException('MenuBloc: mapEventToState, unknown event');
    }
  }
}
