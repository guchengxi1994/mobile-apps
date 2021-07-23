part of 'convert_bloc.dart';

enum ConvertStatus { init, changing, changed }

class ConvertState extends Equatable {
  final ConvertStatus status;
  final String originImgPath;
  final String convertedImgPath;
  final bool isChanging;
  const ConvertState(
      {this.status = ConvertStatus.init,
      this.originImgPath = '',
      this.convertedImgPath = '',
      this.isChanging = false});

  @override
  List<Object> get props =>
      [status, originImgPath, convertedImgPath, isChanging];

  ConvertState copyWith(ConvertStatus? status, String? originImgPath,
      String? convertedImgPath, bool? isChanging) {
    return ConvertState(
        status: status ?? this.status,
        originImgPath: originImgPath ?? this.originImgPath,
        convertedImgPath: convertedImgPath ?? this.convertedImgPath,
        isChanging: isChanging ?? this.isChanging);
  }
}
