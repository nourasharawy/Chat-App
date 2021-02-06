import 'dart:io';

import 'package:chatapp01/widgets/picker/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthForm extends StatefulWidget {
  final void Function (String email ,String password ,String username ,File image ,bool isLogin ,BuildContext ctx)submitFn;
  final bool isLoading;
  AuthForm (this.submitFn, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  bool _isLogin  = true;
  String _email = "" ;
  String _password = "" ;
  String _username = "" ;
  File _userImageFile ;
  void _pickedImage (File pickedImage){
    _userImageFile = pickedImage ;
  }
  void _submit (){
    final _isvalid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();
    print (_isLogin);
    if (!_isLogin && _userImageFile==null)
      {
        Scaffold.of(context).showSnackBar(SnackBar(
          content : Text("Please enter a picture"),
          backgroundColor : Theme.of(context).errorColor,
        ));
        return;
      }
    if (_isvalid){
      _formkey.currentState.save();
      widget.submitFn(_email.trim(), _password.trim() , _username.trim() ,_userImageFile ,_isLogin , context );
      print(_email.trim());
      print( _password.trim());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.none,
                    key: ValueKey("email"),
                    validator: (val){
                      if(val.isEmpty || !val.contains('@')){
                        return "Please enter a valid Email";
                      }
                      return null ;
                    },
                    onSaved: (val)=> _email = val,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email Address"),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: true,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.words,
                      key: ValueKey("username"),
                      validator: (val){
                        if(val.isEmpty || val.length<4){
                          return "Please enter at least 4 caracters";
                        }
                        return null ;
                      },
                      onSaved: (val)=> _username = val,
                      decoration: InputDecoration(labelText: "Username"),
                    ),
                  TextFormField(
                    key: ValueKey("password"),
                    validator: (val){
                      if(val.isEmpty || val.length<7){
                        return "Please enter at least 7 charcters";
                      }
                      return null ;
                    },
                    onSaved: (val)=> _password = val,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  SizedBox(height: 12,),
                  if(widget.isLoading)
                    CircularProgressIndicator(),
                  if(!widget.isLoading)
                  RaisedButton(
                    child:Text (_isLogin ? 'Login' : 'Sign Up') ,
                    onPressed: _submit,
                  ),
                  if(!widget.isLoading)
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(_isLogin ? 'Create a new account' : 'I already have an account'),
                    onPressed:(){
                      setState(() {
                        _isLogin = !_isLogin ;
                      });
                    },),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
