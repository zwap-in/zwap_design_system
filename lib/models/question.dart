/// The question type in base of the dynamic data
enum QuestionType{
  InputDropdown,
  InputText,
  InputArea,
  InputNumber
}

/// The question element object
class QuestionElement{

  /// The title displayed on this question
  final String questionTitle;

  /// The alert title displayed on this question
  final String questionAlert;

  /// The question type
  final QuestionType questionType;

  /// The default value of this question input
  final String questionDefaultValue;

  /// The title value to save the question
  final String questionTitleValue;

  /// The placeholder for this question input
  final String questionPlaceholder;

  /// The list of the options to show inside question with questionType == InputDropdown
  final List<String>? questionOptions;

  final String? regexValidate;

  QuestionElement({
    required this.questionTitle,
    required this.questionTitleValue,
    required this.questionPlaceholder,
    required this.questionDefaultValue,
    required this.questionAlert,
    required this.questionType,
    this.questionOptions,
    this.regexValidate
  }){
    if(this.questionType == QuestionType.InputDropdown){
      assert(this.questionOptions != null && this.questionOptions!.length != 0, "Input dropdown must have question options");
      assert(this.regexValidate == null, "Regex validation must be null on input dropdown");
    }
    else{
      assert(this.questionOptions == null || this.questionOptions!.length == 0, "Input dropdown cannot have question options");
      assert(this.regexValidate != null, "Regex validation must be not null on input type not equal to dropdown");
    }
  }

  factory QuestionElement.fromJson(Map<String, dynamic> json) {
    return QuestionElement(
        questionTitle: json['question_title'],
        questionAlert: json['question_alert'],
        questionType: json['question_type'],
        questionDefaultValue: json['question_default_value'],
        questionPlaceholder: json['question_placeholder'],
        questionTitleValue: json['question_title_value'],
        questionOptions: json.containsKey("question_options") ? json['question_options'] : null
    );
  }
}

/// Use this element with any profile data form
class ProfileQuestions{

  /// The question one inside this element
  final QuestionElement questionOne;

  /// The optional question two inside this element
  QuestionElement? questionTwo;

  ProfileQuestions({
    required this.questionOne,
    this.questionTwo
  });

  factory ProfileQuestions.fromJson(Map<String, dynamic> json){
    return ProfileQuestions(
        questionOne: QuestionElement.fromJson(json['question_one']),
        questionTwo: json.containsKey("question_two") ? QuestionElement.fromJson(json['question_two']) : null
    );
  }
}
