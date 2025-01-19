// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'question_body.g.dart';

@JsonSerializable()
class QuestionBody {
  late String question;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String error = '';

  QuestionBody(this.question);

  QuestionBody.withError(this.error);

  factory QuestionBody.fromJson(Map<String, dynamic> json) =>
      _$QuestionBodyFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionBodyToJson(this);

  @override
  String toString() {
    return 'QuestionBody{question: $question}';
  }
}
