part of 'progress_task_bloc.dart';

@immutable
sealed class ProgressTaskEvent {}

class OnFetchProgressTasks extends ProgressTaskEvent {
  final int userID;

  OnFetchProgressTasks(this.userID);
}
