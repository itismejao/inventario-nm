// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Produto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProdutoAdapter extends TypeAdapter<Produto> {
  @override
  final int typeId = 0;

  @override
  Produto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Produto(
      fields[0] as int?,
      fields[2] as String?,
      fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Produto obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._id_produto)
      ..writeByte(1)
      ..write(obj._nome)
      ..writeByte(2)
      ..write(obj._ean);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProdutoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
