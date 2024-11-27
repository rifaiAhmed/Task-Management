import 'package:course_task_app/common/app_color.dart';
import 'package:course_task_app/common/app_info.dart';
import 'package:course_task_app/common/app_route.dart';
import 'package:course_task_app/common/enums.dart';
import 'package:course_task_app/presentation/bloc/login/login_cubit.dart';
import 'package:course_task_app/presentation/widgets/app_button.dart';
import 'package:d_input/d_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final edtEmail = TextEditingController();
    final edtPass = TextEditingController();
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          buildHeader(),
          Column(
            children: [
              // const Gap(20),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    DInput(
                      controller: edtEmail,
                      fillColor: Colors.white,
                      radius: BorderRadius.circular(12),
                      hint: 'email',
                    ),
                    const Gap(30),
                    DInputPassword(
                      controller: edtPass,
                      fillColor: Colors.white,
                      radius: BorderRadius.circular(12),
                      hint: 'password',
                    ),
                    const Gap(30),
                    BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state.requestStatus == RequestStatus.failed) {
                          AppInfo.failed(context, 'Login Failed');
                        }
                        if (state.requestStatus == RequestStatus.success) {
                          AppInfo.success(context, 'Login Success');
                          Navigator.pushNamed(context, AppRoute.home);
                        }
                      },
                      builder: (context, state) {
                        if (state.requestStatus == RequestStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return AppButton.primary('LOGIN', () {
                          context.read<LoginCubit>().clickLogin(edtEmail.text, edtPass.text);
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AspectRatio buildHeader() {
    return AspectRatio(
      aspectRatio: 0.8,
      child: Stack(
        children: [
          Positioned.fill(
              bottom: 100,
              child: Image.asset(
                'assets/login_bg.png',
                fit: BoxFit.cover,
              )),
          Positioned.fill(
            top: 200,
            bottom: 80,
            child: DecoratedBox(
                decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColor.scafold,
                  Colors.transparent,
                ],
              ),
            )),
          ),
          Positioned(
            left: 30,
            right: 30,
            bottom: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 120,
                  width: 120,
                ),
                const Gap(20),
                RichText(
                    text: TextSpan(
                        text: 'Monitoring\n',
                        style: TextStyle(
                          color: AppColor.defaultText,
                          fontSize: 30,
                          height: 1.4,
                        ),
                        children: const [
                      TextSpan(
                        text: 'With ',
                      ),
                      TextSpan(
                        text: 'Tusk',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]))
              ],
            ),
          )
        ],
      ),
    );
  }
}
