import 'package:course_task_app/common/app_color.dart';
import 'package:course_task_app/common/app_route.dart';
import 'package:course_task_app/data/models/task.dart';
import 'package:course_task_app/data/models/user.dart';
import 'package:course_task_app/presentation/bloc/progress_task/progress_task_bloc.dart';
import 'package:course_task_app/presentation/bloc/state_employee/state_employee_cubit.dart';
import 'package:course_task_app/presentation/widgets/failed_ui.dart';
import 'package:d_button/d_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class MonitorEmployePage extends StatefulWidget {
  const MonitorEmployePage({super.key, required this.employee});
  final User employee;

  @override
  State<MonitorEmployePage> createState() => _MonitorEmployePageState();
}

class _MonitorEmployePageState extends State<MonitorEmployePage> {
  refresh() {
    context.read<StateEmployeeCubit>().fetchStatistic(widget.employee.id!);
    context
        .read<ProgressTaskBloc>()
        .add(OnFetchProgressTasks(widget.employee.id!));
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColor.primary,
            height: 150,
          ),
          RefreshIndicator(
            onRefresh: () async => refresh(),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                const Gap(30),
                buildHeader(),
                const Gap(24),
                buildAddButtonTask(),
                const Gap(40),
                buildTaskMenu(),
                const Gap(40),
                buildProgressTask(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTaskMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tasks',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            color: AppColor.textTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(20),
        BlocBuilder<StateEmployeeCubit, Map>(
          builder: (context, state) {
            return GridView.count(
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                buildItemTaskMenu(
                    "assets/queue_bg.png", "Queue", state['Queue']),
                buildItemTaskMenu(
                    "assets/review_bg.png", "Review", state['Review']),
                buildItemTaskMenu(
                    "assets/approved_bg.png", "Approved", state['Approved']),
                buildItemTaskMenu(
                    "assets/rejected_bg.png", "Rejected", state['Rejected']),
              ],
            );
          },
        )
      ],
    );
  }

  Widget buildProgressTask() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress Tasks',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            color: AppColor.textTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(20),
        BlocBuilder<ProgressTaskBloc, ProgressTaskState>(
          builder: (context, state) {
            if (state is ProgressTaskLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProgressTaskFailed) {
              return FailedUi(message: state.message);
            }
            if (state is ProgressTaskLoaded) {
              List<Task> tasks = state.tasks;
              if (tasks.isEmpty) {
                return const FailedUi(
                  message: "there is no progress",
                  icon: Icons.list,
                );
              }

              return ListView.builder(
                itemCount: tasks.length,
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Task task = tasks[index];
                  return Text(task.title ?? '');
                },
              );
            }
            return const SizedBox.shrink();
          },
        )
      ],
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        Transform.translate(
          offset: const Offset(-12, 0),
          child: const BackButton(
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Text(
            widget.employee.name ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DButtonFlat(
          child: const Text("Reset Password"),
          onClick: () {},
          radius: 12,
          mainColor: Colors.white,
        )
      ],
    );
  }

  Widget buildAddButtonTask() {
    return DButtonElevation(
      onClick: () {
        Navigator.pushNamed(
          context,
          AppRoute.addTask,
          arguments: widget.employee,
        ).then((value) => refresh());
      },
      height: 50,
      radius: 12,
      mainColor: Colors.white,
      elevation: 4,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add),
          Gap(20),
          Text("Add New Task"),
        ],
      ),
    );
  }

  Widget buildItemTaskMenu(String asset, String status, int total) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(asset),
        fit: BoxFit.cover,
      )),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            status,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Gap(6),
          Text(
            '$total tasks',
            style: GoogleFonts.montserrat(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
