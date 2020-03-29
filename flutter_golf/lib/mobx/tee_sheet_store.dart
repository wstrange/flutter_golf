import 'package:mobx/mobx.dart';
import '../model/model.dart';
import 'package:flutter_golf/svc/services.dart';

part 'tee_sheet_store.g.dart';

class TeeSheetStore = _TeeSheetStore with _$TeeSheetStore;

abstract class _TeeSheetStore with Store {
  @observable
  Course course; // the course to view

  @observable
  DateTime date; // the date for this teeSheet

  @action
  void setDate(DateTime d) {
    date = d;
    getTeeTimeList();
  }

  static final Duration _oneDay = const Duration(days: 1);

  FireStore svc;

  @observable
  ObservableList<TeeTime> teeTimeList = ObservableList<TeeTime>();

  _TeeSheetStore(this.course, this.date, this.svc) {
    //svc.teeTimeService.getTeeTimeList(course.id, date);
    svc.teeTimeService
        .subscribeTeeTimeListUpdates(course.id, date, teeTimeList);
  }

  @action
  refreshTeeTimeStream() {
    var stream =
        svc.teeTimeService.getTeeTimeByCourseAndDateStream(course.id, date);
    //teeTimeStream = ObservableStream(stream);
  }

  // Advance the date by one day
  @action
  void incrementDate() {
    date = date.add(_oneDay);
    getTeeTimeList();
  }

  @action
  void decrementDate() {
    date = date.subtract(_oneDay);
    getTeeTimeList();
  }

//  @action
//  getTeeTimes() {
//    print("Get tee times action course $course date $date");
//
//    teeTimes =
//        ObservableStream(svc.teeTimeService.getTeeTimeStream(course.id, date));
//  }

  @action
  Future<void> getTeeTimeList() async {
    print("Refereh  tee time list for $course at $date");
    // var t = await svc.teeTimeService.getTeeTimeList(course.id, date);
    // teeTimeList.clear();
    // teeTimeList.addAll(t);
    svc.teeTimeService
        .subscribeTeeTimeListUpdates(course.id, date, teeTimeList);
  }

  @override
  void dispose() async {
    // todo: How do we dispose of the tee time service, or should we?
    // how to cancel a stream
  }
}
