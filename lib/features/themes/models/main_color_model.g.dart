// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_color_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MainColorsAdapter extends TypeAdapter<MainColors> {
  @override
  final int typeId = 2;

  @override
  MainColors read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MainColors.blue;
      case 1:
        return MainColors.red;
      case 2:
        return MainColors.green;
      default:
        return MainColors.blue;
    }
  }

  @override
  void write(BinaryWriter writer, MainColors obj) {
    switch (obj) {
      case MainColors.blue:
        writer.writeByte(0);
        break;
      case MainColors.red:
        writer.writeByte(1);
        break;
      case MainColors.green:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainColorsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
