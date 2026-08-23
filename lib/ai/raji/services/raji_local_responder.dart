import '../models/raji_context.dart';
import '../models/raji_message.dart';

/// A child-safe response path for devices without a reachable Raji server.
/// A hosted model is still used whenever it is available.
class RajiLocalResponder {
  RajiLocalResponder._();

  static RajiMessage respond({
    required String message,
    required RajiContext context,
  }) {
    final query = message.trim().toLowerCase();
    final name = context.nickname.trim().isEmpty ? 'hiriyyaa' : context.nickname;

    final response = switch (true) {
      _ when _containsAny(query, const ['hibboo', 'riddle']) =>
        'Hibboo tokko siif qaba, $name! Guyyaa fi halkan keessa na argita, garuu na qabachuu hin dandeessu. Ani maal? Mee yaali.',
      _ when _containsAny(query, const ['qubee', 'alphabet', 'letter']) =>
        'Qubee irraa haa jalqabnu, $name. A jechuun Aannan. Mee jecha A irraa jalqabu tokko jedhuu dandeessaa?',
      _ when _containsAny(query, const ['lakkoofsa', 'number', 'count']) =>
        'Lakkoofsa waliin haa taphannu. 1, 2, 3 jechuun lakkaa\'i. Amma lakkoofsa itti aanu jechuun maal?',
      _ when _containsAny(query, const ['seenaa', 'story']) =>
        'Seenaa gabaabaa: Sareen xiqqaan hiriyyaa isaa waliin nyaata qooddate. Wal qooduun hojii gaarii dha. Ati yeroo dhiyootti eenyu waliin wal qoodde?',
      _ when _containsAny(query, const ['help', 'gargaarsa', 'maal gochuu']) =>
        'Ani Raji dha, $name. Qubee, lakkoofsa, hibboo, seenaa, ykn tapha irratti si gargaaruu nan danda\'a. Maal irraa jalqabna?',
      _ =>
        'Galatoomi, $name! Ani si dhaggeeffachaa jira. Qubee, lakkoofsa, hibboo, ykn seenaa keessaa waan barbaaddu na gaafadhu.',
    };

    return RajiMessage(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      role: RajiMessageRole.assistant,
      text: response,
      timestamp: DateTime.now(),
      suggestions: const [
        'Hibboo naaf kenni',
        'Qubee na barsiisi',
        'Lakkoofsa haa lakkoofnu',
      ],
    );
  }

  static bool _containsAny(String value, List<String> terms) =>
      terms.any(value.contains);
}
