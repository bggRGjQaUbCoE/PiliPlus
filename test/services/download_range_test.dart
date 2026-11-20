import 'package:PiliPlus/services/download/download_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('416 completes a file whose local size matches the resource', () {
    expect(
      downloadRangeAction(
        statusCode: 416,
        received: 128,
        resourceSize: 128,
      ),
      DownloadRangeAction.complete,
    );
  });

  test('416 restarts a partial file or an unknown resource size', () {
    expect(
      downloadRangeAction(
        statusCode: 416,
        received: 64,
        resourceSize: 128,
      ),
      DownloadRangeAction.restart,
    );
    expect(
      downloadRangeAction(
        statusCode: 416,
        received: 64,
        resourceSize: null,
      ),
      DownloadRangeAction.restart,
    );
  });

  test('successful range responses continue writing', () {
    expect(
      downloadRangeAction(
        statusCode: 206,
        received: 64,
        resourceSize: 128,
      ),
      DownloadRangeAction.write,
    );
  });

  test('content range reports the complete resource size', () {
    expect(contentRangeSize('bytes 64-127/128'), 128);
    expect(contentRangeSize('bytes */*'), isNull);
    expect(contentRangeSize(null), isNull);
  });
}
