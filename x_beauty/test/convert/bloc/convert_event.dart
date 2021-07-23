part of 'convert_bloc.dart';

abstract class ConvertEvent extends Equatable {
  const ConvertEvent();

  @override
  List<Object> get props => [];
}

class ConvertInitEvent extends ConvertEvent {}

class ConvertChangingEvent extends ConvertEvent {
  final String filePath;
  final int type;
  const ConvertChangingEvent({required this.filePath, required this.type});
}

class ConvertChangedEvent extends ConvertEvent {}

class ConvertChoseImgEvent extends ConvertEvent {
  final String chosenImgPath;
  const ConvertChoseImgEvent({required this.chosenImgPath});
}
