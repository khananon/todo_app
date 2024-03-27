import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/screen/constants/colors.dart';
import 'package:todo_app/widgets/todo_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



class Home extends StatefulWidget {
   Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var todoList=ToDo.todoList();
  List<ToDo> foundToDo=[];// Initializes an empty list foundToDo to store filtered to-dos.
  final todoController = TextEditingController();// Initializes a text editing controller for the new to-do input field.

  @override
  void initState() {
   foundToDo=todoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
    
      title: 'ToDo App',
      home: Scaffold(
        backgroundColor:  const Color.fromARGB(255, 31, 31, 31),
        appBar:BuildAppBar(),


        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
                
                ),
              child: Column( 
                children: [ 
                  searchBox(),
                  Expanded(//this for All ToDdoos and todo list 
                    child: ListView(
                      
                      children: [ 
                        Container( 
                         
                          margin:EdgeInsets.only( 
                            top: 50,
                            bottom:  20, 
                    
                          ),
                          child: Text( 
                            'All ToDos', 
                            style: TextStyle(fontSize :30,  
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 84, 83, 83)
                            ),
                          ),
                        ),
                        for(ToDo toDo in foundToDo)
                        ToDoItem(todo: toDo,//TodoItem is for the row layout we create diffrent  
                                            //class for this Row todo_item.dart and to put todo task 
                                            //we create Todo.dart class
                        onToDoChanged: handleTODoChange,
                        onDeleteItem: deleteToDoItem,
                        ),
                           
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align( 
              alignment: Alignment.bottomCenter,
              child: Row(children: [ 
                Expanded(child: Container( 
                  margin:EdgeInsets.only( 
                    bottom: 20,
                    right:20,
                    left:20,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  decoration: BoxDecoration( 
                    color: Colors.white, 
                    boxShadow: [ BoxShadow(
                      color: Colors.grey,
                    offset:Offset(1.0, 1.0), 
                    blurRadius: 10.0, 
                    spreadRadius: 0.0,
                     ),
                    ],
                    borderRadius: BorderRadius.circular(10), 

                  ) ,
                  child: TextField( 
                    controller: todoController,
                    decoration: InputDecoration( 
                      hintText: 'Add a new todo item' ,
                      border: InputBorder.none
                    ),
                  ),
                ),
                ),
                Container( 
                  margin: EdgeInsets.only( 
                    bottom: 20,
                    right: 20, 

                  ),
                  child: ElevatedButton( 
                    child: Text('+',style: TextStyle(fontSize: 30,color: Colors.white,),),
                    onPressed: () {
                      addTodoItem(todoController.text);
                    },
                    style: ElevatedButton.styleFrom( 
                   primary: tdblue,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                        shape: RoundedRectangleBorder( 
                          borderRadius: BorderRadius.circular(10),
                        ),
                  
                    ),
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void handleTODoChange(ToDo todo){
    setState((){
       todo.isDone=!todo.isDone;
    }

    );
  }
  void deleteToDoItem(String id){
    setState(() {
      todoList.removeWhere((item) => item.id==id);
    });
    
  }void addTodoItem(String  todo){
    setState(() {
     todoList.add(ToDo(id:DateTime.now().microsecondsSinceEpoch.toString() , todoText: todo));  
    });
   todoController.clear();
  }
  void runFilter(String enterKeyword){
    List<ToDo>results=[];
    if(enterKeyword.isEmpty){
      results=todoList;
      
    }else{
      results=todoList.where((item) => item.todoText!.toLowerCase().contains(enterKeyword.toLowerCase())).toList();
    }
    setState(() {
      foundToDo=results;
    });
  }
  Future<void> loadToDoList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? todoListJson = prefs.getStringList('todoList');
  if (todoListJson != null) {
    setState(() {
      todoList = todoListJson.map((e) => ToDo.fromJson(e)).toList();
    });
  }
}



Future<void> saveToDoList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> todoListJson = todoList.map((e) => jsonEncode(e.toJson())).toList();
  await prefs.setStringList('todoList', todoListJson);
}



  Widget searchBox() {
    return Container( 
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration( 
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              
              child: TextField(
                 onChanged: (value) {
        runFilter(value);
      },
                
                decoration: InputDecoration( 
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon( 
                    Icons.search,
                    color: tdBlack,
                    size:20
                  ),
                  
                  prefixIconConstraints: BoxConstraints( 
                    maxHeight: 20, 
                    minWidth: 25, 

                  ),
                  border: InputBorder.none,
                  hintText: 'Search', 
                  hintStyle: TextStyle(color: tdGray ),
                ),
                
              ),
              
              
            );
  }

  AppBar BuildAppBar() {
    return AppBar(
        
        backgroundColor: const Color.fromARGB(255, 64, 64, 64),
        
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Icon(Icons.menu,color: Color.fromARGB(255, 146, 144, 144),size: 30,),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/Avtar.png'),
            ),
          ),
        ],),
      );
  }
}
