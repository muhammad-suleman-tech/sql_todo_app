import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqlite_todo_app/modals/todo_modal.dart';

import '../db/db_helper.dart';


class AddStudentData extends StatefulWidget {
  const AddStudentData({Key? key}) : super(key: key);

  @override
  State<AddStudentData> createState() => _AddStudentDataState();
}

class _AddStudentDataState extends State<AddStudentData> {

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  late String name;
  late int age;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      // backgroundColor: LinearGradient(colors: Color(0xffeb5834),Color(0xffeb5834),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      hintText: 'Student Name'
                  ),
                  validator: (String? value){
                    if( value == null || value.isEmpty){
                      return 'Please provide student Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Student Age'
                  ),
                  validator: (String? value){
                    if( value == null || value.isEmpty){
                      return 'Please provide student Age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10,),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () async {
                    if( formKey.currentState!.validate()){
                      // create the object of modal class and pass with the parameters
                      var student = Student(name: nameController.text, age: int.parse(ageController.text));

                      var dbHelper =  DatabaseHelper.instance;
                      int result = await dbHelper.saveStudent(student);

                      if( result > 0 ){
                        Fluttertoast.showToast(msg: 'Data Saved');
                        setState(() {
                          nameController.clear(); ageController.clear();
                        });
                      } else {
                        Fluttertoast.showToast(msg: 'Error Data is Not Saved');
                      }
                    }
                  }, child: const Text('Save')),
                ),
                const SizedBox(height: 10,),

                FutureBuilder(
                  future: DatabaseHelper.instance.getAllStudent(),
                    builder: (context,snapshot) {
                      if(snapshot.hasData){
                          if(snapshot.data!.isEmpty){
                            return const Center(
                                child: Text("No Data Available"));
                          } else {
                            List<Student> students = snapshot.data!;
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: students.length,
                                itemBuilder: (context,index){
                                Student student = students[index];
                                return Container(
                                    color: Colors.lightBlueAccent[100],
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  margin : const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                            Text(student.name),
                                            const SizedBox(height: 20,),
                                              Text(student.age.toString())
                                      ],)),
                                      Column(
                                        children: [
                                          IconButton(onPressed: () async {
                                              nameController.text = student.name;
                                              ageController.text = student.age.toString();
                                              await DatabaseHelper.instance.deleteStudent(student);
                                              setState(() {

                                              });

                                          }, icon: const Icon(Icons.edit,color: Colors.green,)),
                                          IconButton(onPressed: (){
                                            showDialog(
                                              barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                              return  AlertDialog(
                                                title: const Text("Confirmation !"),
                                                content: const Text("Are you sure you want to delete ?"),
                                                actions: [
                                                  TextButton(onPressed: () async {
                                                    int result = await DatabaseHelper.instance.deleteStudent(student);
                                                    if(result > 0 ){
                                                      Fluttertoast.showToast(msg: "Item Deleted");
                                                      setState(() {

                                                      }); Navigator.of(context).pop();
                                                    }
                                                  }, child: const Text("Yes")),

                                                  TextButton(onPressed: (){
                                                    Navigator.of(context).pop();
                                                  }, child: const Text("No")),
                                                ],
                                              );
                                            } );
                                          }, icon: const Icon(Icons.delete,color: Colors.red,))
                                        ],
                                      )
                                    ],
                                )
                                );
                                }
                            );
                          }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
