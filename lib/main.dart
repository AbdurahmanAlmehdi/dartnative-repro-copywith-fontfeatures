import 'package:dartnative/dartnative.dart';

import 'dartnative_plugin_registrant.dart';

void main() {
  DartNativePluginRegistrant.registerAll();
  runApp(const CopyWithRepro());
}

const _ink = TextStyle(fontSize: 14, color: Color(0xFF111111));
const _red = TextStyle(fontSize: 14, color: Color(0xFFC62828));
const _head = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF111111));

// The app's number style: tabular figures so amounts line up in a column.
const _base = TextStyle(
  fontSize: 22,
  color: Color(0xFF111111),
  fontFeatures: [FontFeature.tabularFigures()],
);

const _amounts = ['1,111.10', '88.88', '7,000.07', '11.11', '404.04'];

String _features(List<FontFeature>? f) =>
    f == null ? 'null' : '[${f.map((e) => '${e.feature}=${e.value}').join(', ')}]';

class CopyWithRepro extends StatelessWidget {
  const CopyWithRepro({super.key});

  Widget _column(String label, TextStyle style) => Expanded(
        child: Container(
          color: const Color(0xFFF1F1F1),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(label, style: _head),
              const SizedBox(height: 6),
              for (final a in _amounts) Text(a, style: style),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final copied = _base.copyWith(fontWeight: FontWeight.w400);
    final merged = _base.merge(const TextStyle(fontWeight: FontWeight.w400));
    return Scaffold(
      brightness: Brightness.light,
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(title: const Text('copyWith drops fontFeatures')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expected (Flutter): base.copyWith(fontWeight: …) keeps base.fontFeatures. '
              'Below, both columns would have tabular figures and line up digit for digit.',
              style: _ink,
            ),
            const SizedBox(height: 4),
            const Text(
              'Actual: copyWith returns fontFeatures == null (and has no fontFeatures '
              'parameter); merge keeps them.',
              style: _red,
            ),
            const SizedBox(height: 12),
            Text('base.fontFeatures = ${_features(_base.fontFeatures)}', style: _ink),
            Text('base.copyWith(fontWeight: w400).fontFeatures = ${_features(copied.fontFeatures)}',
                style: _ink),
            Text('base.merge(TextStyle(fontWeight: w400)).fontFeatures = '
                '${_features(merged.fontFeatures)}', style: _ink),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _column('base', _base),
                const SizedBox(width: 12),
                _column('base.copyWith(…)', copied),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Note: on iOS the base column shows proportional digits too (11.11 is '
              'narrower than 88.88), so tnum is not drawn even before copyWith. '
              'The values printed above show the copyWith loss on its own.',
              style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
            ),
          ],
        ),
      ),
    );
  }
}
