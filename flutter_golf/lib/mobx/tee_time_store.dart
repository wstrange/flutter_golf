import 'package:flutter_golf/model/model.dart';
import 'package:flutter_golf/svc/services.dart';
import 'package:mobx/mobx.dart';

part 'tee_time_store.g.dart';

//class UserStore = _UserStore with _$UserStore;

class TeeTimeStore = _TeeTimeStore with _$TeeTimeStore;

// Represents the the state of a tee time
abstract class _TeeTimeStore with Store {
  TeeTimeService _svc;
  String _teeTimeId;

  //ObservableList<Booking> teeTimeBookingsList = ObservableList();
  // Listen for booking updates
  ObservableStream<List<Booking>> teeTimeBookingsStream;

  ObservableStream<TeeTime> teeTimeStream;

  _TeeTimeStore(this._svc, this._teeTimeId) {
    teeTimeBookingsStream =
        ObservableStream(_svc.getBookingsStreamForTeeTimeId(_teeTimeId));
    teeTimeStream =
        ObservableStream(_svc.getTeeTimeByCourseAndDateStream(_teeTimeId));
  }

  @action
  createBooking(User user) async {
    await _svc.bookTeeTime(teeTime, user);
  }

  @action
  getTeeTime(String teeTimeId) async {
    var t = await _svc.getTeeTimeById(teeTimeId);
    teeTime = t;
  }

  // Add a guest to the booking
  // this will need to be done server side...
  // Its really a booking request..
  @action
  void addGuest(Booking booking, {int numGuests: 1}) {
    // update booking object
    var nb = booking.rebuild((b) => b..numberGuests += 1);
    // update teetime - one less spot
    teeTime = teeTime.rebuild((t) => t..availableSpots -= 1);
  }

  // get all the bookings for this tee time
//  @action
//  Future<void> getBookings() async {
//    var bookings = await _svc.getBookingsForTeeTime(teeTime);
//    teeTimeBookingsList.clear();
//    teeTimeBookingsList.addAll(bookings);
//  }
}
