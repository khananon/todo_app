import 'dart:convert';

class ToDo{
  String? id;
  String? todoText;
   bool isDone;

   ToDo({
    required this.id, 
    required this.todoText, 
    this.isDone=false,

   });
    factory ToDo.fromJson(String json) {
  Map<String, dynamic> map = jsonDecode(json);
  return ToDo(
    id: map['id'],
    todoText: map['todoText'],
    isDone: map['isDone'],
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone,
    };
  }
   
   static List<ToDo> todoList(){
return [ 
 
];
   }
   
   
   }