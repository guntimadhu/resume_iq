part of 'analysis_history.dart';

class AnalysisHistoryAdapter extends TypeAdapter<AnalysisHistory> {
  @override
  final int typeId = 0;

  @override
  AnalysisHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalysisHistory(
      id: fields[0] as String,
      jobTitle: fields[1] as String,
      date: fields[2] as DateTime,
      atsScore: fields[3] as int,
      matchingKeywords: (fields[4] as List).cast<String>(),
      missingKeywords: (fields[5] as List).cast<String>(),
      suggestions: (fields[6] as List).cast<String>(),
      sectionAnalysis: (fields[7] as Map).cast<String, String>(),
      resumeTextSnapshot: fields[8] as String,
      jdTextSnapshot: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AnalysisHistory obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobTitle)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.atsScore)
      ..writeByte(4)
      ..write(obj.matchingKeywords)
      ..writeByte(5)
      ..write(obj.missingKeywords)
      ..writeByte(6)
      ..write(obj.suggestions)
      ..writeByte(7)
      ..write(obj.sectionAnalysis)
      ..writeByte(8)
      ..write(obj.resumeTextSnapshot)
      ..writeByte(9)
      ..write(obj.jdTextSnapshot);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalysisHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
