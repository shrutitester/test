class ResponseModel{
  int? userId;
  int? id;
  String? title;
  bool? completed;

  ResponseModel({this.userId,this.id,this.title, this.completed});

  factory ResponseModel.fromJson(Map<String, dynamic> json){
    return  ResponseModel(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        completed: json['completed']

    );
  }



}
