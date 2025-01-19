// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'answer_body.g.dart';

@JsonSerializable()
class AnswerBody {
  late String answer;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String error = '';

  AnswerBody(this.answer);

  AnswerBody.withError(this.error);

  factory AnswerBody.fromJson(Map<String, dynamic> json) =>
      _$AnswerBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerBodyToJson(this);

  @override
  String toString() {
    return 'AnswerBody{answer: $answer}';
  }
}
