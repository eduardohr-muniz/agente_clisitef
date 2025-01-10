import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class WbaLogs extends LogOutput {
  File? _logFile;
  String? _logName;

  bool get isAvaliable => _logFile != null;
  bool get isNotAvaliable => !isAvaliable;

  Logger logger({required String logName, bool saveOnDirectory = false, int? clearLogInDays}) {
    if (saveOnDirectory == false) return Logger();
    getApplicationDocumentsDirectory().then((directory) {
      final daysToKeep = clearLogInDays;

      final today = DateTime.now();
      final fileDate = '${today.year}_${today.month}_${today.day}';
      logName = '${logName}_log_$fileDate.txt';
      _logName = logName;

      _logFile = File('${directory.path}/$logName');

      _logFile!.exists().then((value) {
        if (!value) {
          _logFile!.createSync();
        }
      });

      _clearOldLogs(directory, daysToKeep);
    });

    return Logger(
      output: this,
      filter: ProductionFilter(),
      printer: SimplePrinter(printTime: true),
    );
  }

  Future<void> _clearOldLogs(Directory directory, int? daysToKeep) async {
    if (daysToKeep == null) return;
    final files = directory.listSync().whereType<File>();
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));

    for (var file in files) {
      // Verifica se o arquivo é um log relacionado e se é mais antigo que o limite
      if (file.path.contains((_logName ?? 'logger').split('_log_')[0])) {
        final fileName = file.uri.pathSegments.last;
        final fileDateStr = RegExp(r'_log_(\d{4})_(\d{1,2})_(\d{1,2})\.txt').firstMatch(fileName)?.groups([1, 2, 3]);

        if (fileDateStr != null) {
          final fileDate = DateTime(
            int.parse(fileDateStr[0]!),
            int.parse(fileDateStr[1]!),
            int.parse(fileDateStr[2]!),
          );

          if (fileDate.isBefore(cutoffDate)) {
            file.deleteSync();
          }
        }
      }
    }
  }

  @override
  Future<void> output(OutputEvent event) async {
    if (isNotAvaliable) return;
    // Mapeamento de ícones para níveis de log
    final levelIcons = {
      Level.debug: '🐛',
      Level.info: 'ℹ️',
      Level.warning: '⚠️',
      Level.error: '❌',
      Level.fatal: '🚨',
    };

    // Adiciona o ícone correspondente ao nível
    final logContent = event.lines.map((line) {
      final icon = levelIcons[event.level] ?? ''; // Ícone padrão vazio
      return '$icon $line';
    }).join('\n');

    // Salva o log com os ícones no arquivo
    _logFile!.writeAsStringSync('$logContent\n', mode: FileMode.writeOnlyAppend);
  }
}
