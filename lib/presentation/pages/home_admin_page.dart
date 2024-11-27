import 'package:course_task_app/common/app_color.dart';
import 'package:course_task_app/common/app_info.dart';
import 'package:course_task_app/common/app_route.dart';
import 'package:course_task_app/common/enums.dart';
import 'package:course_task_app/data/models/task.dart';
import 'package:course_task_app/data/models/user.dart';
import 'package:course_task_app/data/source/user_source.dart';
import 'package:course_task_app/presentation/bloc/employee/employee_bloc.dart';
import 'package:course_task_app/presentation/bloc/need_review/need_review_bloc.dart';
import 'package:course_task_app/presentation/bloc/user/user_cubit.dart';
import 'package:course_task_app/presentation/widgets/failed_ui.dart';
import 'package:d_button/d_button.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  getNeedReview() {
    context.read<NeedReviewBloc>().add(OnFetchNeedReview());
  }

  getEmployee() {
    context.read<EmployeeBloc>().add(OnFetchEmployee());
  }

  refresh() {
    getNeedReview();
    getEmployee();
  }

  deleteEmployee(User employee) {
    DInfo.dialogConfirmation(
      context,
      "Delete",
      "Yes to confirm",
    ).then((bool ? yes) {
      if (yes ?? false) {
        UserSource.delete(employee.id!).then((success) {
          if (success) {
            AppInfo.success(context, "Success Delete user");
            getEmployee();
          } else {
            AppInfo.failed(context, 'Failed delete user');
          }
        });
      }
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              buildHeader(),
              Positioned(
                  left: 20,
                  right: 20,
                  bottom: 0,
                  child: buildButtonAddEmployee()),
            ],
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: () async => refresh(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Gap(10),
                buildNeedReview(),
                const Gap(40),
                buildEmployee(),
                const Gap(40),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget buildItemEmployee(User employee) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 6,
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ),
          const Gap(16),
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              'assets/profile.png',
              height: 40,
              width: 40,
            ),
          ),
          const Gap(16),
          Expanded(
            child: Text(
              employee.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColor.textTitle,
              ),
            ),
          ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == "Monitor") {
                Navigator.pushNamed(
                  context,
                  AppRoute.monitorEmployee,
                  arguments: employee,
                ).then((value) => refresh());
              }
              if (value == "Delete") {
                deleteEmployee(employee);
              }
            },
            itemBuilder: (context) => ["Monitor", "Delete"].map((e) {
              return PopupMenuItem(
                value: e,
                child: Text(e),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildEmployee() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Employee',
          style: GoogleFonts.montserrat(
            color: AppColor.textTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        BlocBuilder<EmployeeBloc, EmployeeState>(
          builder: (context, state) {
            if (state is EmployeeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is EmployeeFailed) {
              return const FailedUi(
                message: 'Something wrong',
                margin: EdgeInsets.only(top: 20),
              );
            }
            if (state is EmployeeLoaded) {
              List<User> employees = state.employees;
              if (employees.isEmpty) {
                return const FailedUi(
                  margin: EdgeInsets.only(top: 20),
                  message: 'There is no employee',
                  icon: Icons.list,
                );
              }
              return ListView.builder(
                itemCount: employees.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  User employee = employees[index];
                  return buildItemEmployee(employee);
                },
              );
            }
            return const SizedBox.shrink();
          },
        )
      ],
    );
  }

  Widget buildNeedReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Need To Be Reviewed',
          style: GoogleFonts.montserrat(
            color: AppColor.textTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        BlocBuilder<NeedReviewBloc, NeedReviewState>(
          builder: (context, state) {
            if (state.requestStatus == RequestStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.requestStatus == RequestStatus.failed) {
              return const FailedUi(
                message: 'Something wrong',
                margin: EdgeInsets.only(top: 20),
              );
            }
            if (state.requestStatus == RequestStatus.success) {
              List<Task> tasks = state.tasks;
              if (tasks.isEmpty) {
                return const FailedUi(
                  margin: EdgeInsets.only(top: 20),
                  message: 'There is no need review',
                  icon: Icons.list,
                );
              }
              return Column(
                  children: List.generate(tasks.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildItemNeeDReview(tasks[index]),
                );
              }));
            }
            return const SizedBox.shrink();
          },
        )
      ],
    );
  }

  Widget buildItemNeeDReview(Task task) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.detailTask,
          arguments: task.id,
        ).then((value) => refresh());
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                'assets/profile.png',
                height: 40,
                width: 40,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.textTitle,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    task.user?.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.textBody,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.navigate_next,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonAddEmployee() {
    return DButtonElevation(
        onClick: () {
          Navigator.pushNamed(context, AppRoute.addEmployee).then((value) => {
                // refresh
              });
        },
        elevation: 4,
        height: 50,
        radius: 12,
        mainColor: Colors.white,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            Gap(4),
            Text('Add New Employee'),
          ],
        ));
  }

  Widget buildHeader() {
    return Container(
      height: 160,
      color: AppColor.primary,
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      alignment: Alignment.topCenter,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoute.profile);
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  'assets/profile.png',
                  height: 40,
                  width: 40,
                )),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                BlocBuilder<UserCubit, User>(
                  builder: (context, state) {
                    return Text(
                      state.name ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            child: Text(
              DateFormat('d MMMM, yyyy').format(DateTime.now()),
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
