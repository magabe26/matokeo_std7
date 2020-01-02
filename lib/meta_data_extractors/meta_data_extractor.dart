import 'package:matokeo_core/matokeo_core.dart';
import 'package:meta/meta.dart';

abstract class MetaDataExtractor with ParserMixin {
  final String input;

  MetaDataExtractor(this.input) : assert(input != null);

  @alwaysThrows
  void throwException([String message]);

  String get councilTitleTag;

  String get titleTag;

  String get noTitleFoundMessage;

  Future<String> _title(String tag, Parser parser, String errorMessage) {
    final title = getElementText(
        tag: tag,
        input: getParserResult(
          parser: parser,
          input: input,
        ));
    if (title.isEmpty) {
      throwException(errorMessage);
    }
    return Future.value(title);
  }

  Future<String> getCouncilTitle() {
    return _title(
        councilTitleTag, councilTitleParser(), 'No CouncilTitle Found');
  }

  Future<String> getTitle() async {
    return _title(titleTag, titleParser(), noTitleFoundMessage);
  }

  Future<int> getResultYear() async {
    try {
      final title = await getTitle();
      return int.parse(getParserResult(
        parser: spaceOptional().seq(digit().plus()),
        input: title,
      ));
    } catch (_) {
      throwException('No Year Found');
    }
  }

  Parser councilTitleParser() => element(councilTitleTag).flatten();

  Parser titleParser() => element(titleTag).flatten();
}
