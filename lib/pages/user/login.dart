import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket/pages/ticket/list_page.dart';
import 'package:ticket/utils/handle_api_call_exception.dart';
import 'package:ticket/utils/show_loading_dialog.dart';
import 'package:ticket/view_model/ticket_list_page_vm.dart';
import 'package:ticket/view_model/user_vm.dart';

const spacing = SizedBox(
  height: 16,
);

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwrodController = TextEditingController();
  late UserVM userProvider;
  bool obscured = true;

  @override
  void initState() {
    userProvider = Provider.of<UserVM>(context, listen: false);
    Future.microtask(() async {
      context.read<UserVM>().reset();
      context.read<TicketListPageVM>().reset();
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwrodController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) return "Email is required.";
    if (!EmailValidator.validate(email)) return "Invalid email.";
    return null;
  }

  String? _validatePassword(String? password) {
    return password == null || password.isEmpty
        ? "Password is required."
        : null;
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    showLoadingDialog(context: context, text: 'Loging in...');

    userProvider
        .login(
      email: _emailController.text,
      password: _passwrodController.text,
    )
        .then((message) {
      Navigator.pop(context); // pop loading dialog
      goToTicketListPage();
    }).catchError((err) {
      Navigator.pop(context); // pop loading dialog
      handleApiCallException(context: context, e: err, willPop: false);
    });
  }

  void goToTicketListPage() {
    Navigator.pushReplacementNamed(context, TicketListPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      height: 64.0,
                      width: 64.0,
                      'assets/images/flutter_logo.png',
                    ),
                    spacing,
                    const Text(
                      'Ticket Tracking',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    spacing,
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        hintText: 'Enter email',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateEmail,
                    ),
                    spacing,
                    TextFormField(
                      controller: _passwrodController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        hintText: 'Enter password',
                        suffixIcon: IconButton(
                          icon: obscured
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              obscured = !obscured;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: _validatePassword,
                      obscureText: obscured,
                    ),
                    spacing,
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      child: const Text('LOGIN'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
