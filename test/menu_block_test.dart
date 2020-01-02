import 'package:matokeo_std7/blocs/menu_bloc.dart';
import 'package:matokeo_std7/models/result_link.dart';
import 'package:test/test.dart';

main() {
  group('Menu block tests: ', () {
    String cleanMenuHtml;
    List<ResultLink> expectedResult;

    setUp(() {
      cleanMenuHtml = '''
 <fieldset>
  <legend>2012</legend>
 <ul><li href="https://12.45.555/results_2012"></li></ul>
 </fieldset>
 
  <fieldset>
  <legend>2015</legend>
 <ul><li href="https://12.45.555/results_2015"></li></ul>
 </fieldset>
 
 
 ''';

      expectedResult = [
        ResultLink('2012', 'https://12.45.555/results_2012'),
        ResultLink('2015', 'https://12.45.555/results_2015')
      ];
    });

    test('A call to getStd7MenuLinks should return the expected result',
        () async {
      final results = await getStd7MenuLinks(cleanMenuHtml);
      expect(expectedResult, results);
    });
  });
}
