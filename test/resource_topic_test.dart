import 'package:flutter_test/flutter_test.dart';
import 'package:yks_study_app/models/learning_workspace.dart';

void main() {
  const linked = ResourceTask(
    id: 't',
    resourceId: 'r',
    title: 'Kitaptan çalışma',
    startUnit: 1,
    endUnit: 10,
    estimatedMinutes: 30,
    topicId: 'personal-topic',
    topicName: 'Kişisel konum',
  );
  test('konu bağı JSON ve arşivleme boyunca korunur', () {
    final restored = ResourceTask.fromJson(linked.toJson()).withArchived(true);
    expect(restored.topicId, 'personal-topic');
    expect(restored.topicName, 'Kişisel konum');
    expect(restored.archived, isTrue);
  });
  test('konusuz eski görev okunur, yarım veya geçersiz bağ reddedilir', () {
    final old = linked.toJson()
      ..remove('topicId')
      ..remove('topicName');
    expect(ResourceTask.fromJson(old).topicId, isNull);
    for (final invalid in [
      {...old, 'topicId': 't'},
      {...old, 'topicName': 'Konu'},
      {...old, 'topicId': 12, 'topicName': 'Konu'},
      {...old, 'topicId': 't', 'topicName': '  '},
    ]) {
      expect(() => ResourceTask.fromJson(invalid), throwsFormatException);
    }
  });
}
