import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

class SoundService {
  SoundService._();

  static final AudioPlayer _player = AudioPlayer();
  static Uint8List? _beepBytes;

  static Future<void> playBeep() async {
    _beepBytes ??= _generateBeepWav();
    await _player.play(BytesSource(_beepBytes!));
  }

  static Uint8List _generateBeepWav({
    int sampleRate = 44100,
    double durationSeconds = 0.18,
    double frequency = 880,
  }) {
    final numSamples = (sampleRate * durationSeconds).toInt();
    final dataLength = numSamples * 2;
    final fileLength = 44 + dataLength;

    final buffer = ByteData(fileLength);

    void writeString(int offset, String value) {
      for (var i = 0; i < value.length; i++) {
        buffer.setUint8(offset + i, value.codeUnitAt(i));
      }
    }

    writeString(0, 'RIFF');
    buffer.setUint32(4, fileLength - 8, Endian.little);
    writeString(8, 'WAVE');
    writeString(12, 'fmt ');
    buffer.setUint32(16, 16, Endian.little);
    buffer.setUint16(20, 1, Endian.little);
    buffer.setUint16(22, 1, Endian.little);
    buffer.setUint32(24, sampleRate, Endian.little);
    buffer.setUint32(28, sampleRate * 2, Endian.little);
    buffer.setUint16(32, 2, Endian.little);
    buffer.setUint16(34, 16, Endian.little);
    writeString(36, 'data');
    buffer.setUint32(40, dataLength, Endian.little);

    for (var i = 0; i < numSamples; i++) {
      final t = i / sampleRate;
      final envelope = exp(-3 * i / numSamples);
      final sample =
          (32767 * 0.3 * sin(2 * pi * frequency * t) * envelope).toInt();
      buffer.setInt16(44 + i * 2, sample, Endian.little);
    }

    return buffer.buffer.asUint8List();
  }
}
