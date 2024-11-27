

import 'package:course_task_app/common/enums.dart';
import 'package:course_task_app/data/models/task.dart';
import 'package:course_task_app/data/source/task_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'need_review_event.dart';
part 'need_review_state.dart';

class NeedReviewBloc extends Bloc<NeedReviewEvent, NeedReviewState> {
  NeedReviewBloc() : super(NeedReviewState.init()) {
    on<OnFetchNeedReview>((event, emit) async {
      emit(NeedReviewState(RequestStatus.loading, []));
      List<Task>? result = await TaskSource.needReview();
      if (result == null) {
        emit(NeedReviewState(RequestStatus.failed, []));
      } else {
        emit(NeedReviewState(RequestStatus.success, result));
      }
    });
  }
}
