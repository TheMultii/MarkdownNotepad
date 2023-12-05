import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/input_input.dart';
import 'package:markdownnotepad/helpers/validator.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';

class AccountEditProfileSectionColumn1 extends StatelessWidget {
  final LoggedInUser loggedInUser;
  final TextEditingController emailInputController,
      firstNameInputController,
      lastNameInputController,
      bioInputController,
      passwordInputController,
      passwordRepeatInputController;
  final Function() updateUserProfile;

  const AccountEditProfileSectionColumn1({
    super.key,
    required this.loggedInUser,
    required this.emailInputController,
    required this.firstNameInputController,
    required this.lastNameInputController,
    required this.bioInputController,
    required this.passwordInputController,
    required this.passwordRepeatInputController,
    required this.updateUserProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MDNInputWidget(
            inputController: emailInputController,
            labelText: 'Adres e-mail',
            onEditingComplete: () => updateUserProfile(),
            validator: (emailValidator) => MDNValidator.validateEmail(
              emailValidator,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          MDNInputWidget(
            inputController: firstNameInputController,
            labelText: 'Imię',
            onEditingComplete: () => updateUserProfile(),
            validator: (nameValidator) =>
                MDNValidator.validateName(nameValidator),
          ),
          const SizedBox(
            height: 10,
          ),
          MDNInputWidget(
            inputController: lastNameInputController,
            labelText: 'Nazwisko',
            onEditingComplete: () => updateUserProfile(),
            validator: (surnameValidator) =>
                MDNValidator.validateSurname(surnameValidator),
          ),
          const SizedBox(
            height: 10,
          ),
          MDNInputWidget(
            inputController: bioInputController,
            labelText: 'Biogram',
            onEditingComplete: () => updateUserProfile(),
            validator: (bioValidator) => MDNValidator.validateBio(bioValidator),
          ),
          const SizedBox(
            height: 10,
          ),
          MDNInputWidget(
            inputController: passwordInputController,
            labelText: 'Hasło',
            obscureText: true,
            onEditingComplete: () => updateUserProfile(),
            validator: (passwordValidator) {
              if (passwordInputController.text.isEmpty) {
                return null;
              }
              return MDNValidator.validatePassword(passwordValidator);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          MDNInputWidget(
            inputController: passwordRepeatInputController,
            labelText: 'Powtórz hasło',
            obscureText: true,
            onEditingComplete: () => updateUserProfile(),
            validator: (passwordRepeatValidator) =>
                MDNValidator.validateRepeatPassword(
              passwordRepeatValidator,
              passwordInputController.text,
            ),
          ),
        ],
      ),
    );
  }
}
