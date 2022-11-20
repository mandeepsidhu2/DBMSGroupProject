package model;

import entity.Booking;
import entity.HotelAvailability;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class BookingModel {

  ProcedureExecutor procedureExecutor;

  public BookingModel(ProcedureExecutor procedureExecutor) {
    this.procedureExecutor = procedureExecutor;
  }

  List<Booking> getFromIteratorHotelWithAmenities(ResultSet resultSetFromProcedure)
      throws SQLException {
    List<Booking> list = new ArrayList<>();
    while (resultSetFromProcedure.next()) {
      Integer customerId = Integer.valueOf(resultSetFromProcedure.getString("customer"));
      Integer bookingId = Integer.valueOf(resultSetFromProcedure.getString("bookingId"));
      Integer hotelId = Integer.valueOf(resultSetFromProcedure.getString("hotel"));
      Integer checkedInByStaffId = Integer.valueOf(
          resultSetFromProcedure.getString("checkedInByStaffId"));
      Integer checkedOutByStaffId = Integer.valueOf(
          resultSetFromProcedure.getString("checkedOutByStaffId"));
      Boolean isCheckedOut = Boolean.valueOf(resultSetFromProcedure.getString("isCheckedOut"));
      Boolean isCheckedIn = Boolean.valueOf(resultSetFromProcedure.getString("isCheckedIn"));
      Integer rating = Integer.valueOf(resultSetFromProcedure.getString("rating"));
      Integer roomNo = Integer.valueOf(resultSetFromProcedure.getString("roomNo"));
      String ratingDescription = resultSetFromProcedure.getString("ratingDescription");
      Date startDate = null, endDate = null;
      try {
        startDate = new SimpleDateFormat("yyyy-MM-dd").parse(
            resultSetFromProcedure.getString("startDate"));
        endDate = new SimpleDateFormat("yyyy-MM-dd").parse(
            resultSetFromProcedure.getString("endDate"));
      } catch (Exception e) {
        System.out.println("error in parsing " + e.getMessage());
      }
      Booking booking = new Booking().toBuilder()
          .bookingId(bookingId).customerId(customerId).hotelId(hotelId)
          .checkedInByStaffId(checkedInByStaffId)
          .checkedOutByStaffId(checkedOutByStaffId).isCheckedIn(isCheckedIn)
          .isCheckedOut(isCheckedOut)
          .rating(rating).roomNo(roomNo).ratingDescription(ratingDescription).startDate(startDate)
          .endDate(endDate)
          .build();
      list.add(booking);
    }
    return list;
  }

  public List<Booking> getBookingsForARoom(Integer customerID) throws SQLException {
    String query = "call getUserBookings(?)";

    ResultSet resultSet = procedureExecutor.preparedStatement(query)
        .setStatementParam(1, customerID.toString())
        .execute();

    List<Booking> bookingList;
    try {
      bookingList = getFromIteratorHotelWithAmenities(resultSet);
    } catch (Exception e) {
      throw e;
    }
    procedureExecutor.cleanup();
    return bookingList;
  }
  public void bookARoom(Integer customerId, Date reqStartDate, Date reqEndDate, Integer hotelId,
      String roomCategory) {
    String query = "call createBooking(?,?,?,?,?,?)";
    try {
      procedureExecutor.preparedStatement(query)
          .setStatementParam(1, hotelId.toString())
          .setStatementParam(2, customerId.toString())
          .setStatementParam(3, new java.sql.Date(reqStartDate.getTime()).toString())
          .setStatementParam(4, new java.sql.Date(reqEndDate.getTime()).toString())
          .setStatementParam(5, roomCategory)
          .setStatementParam(6, null)
          .execute();
      procedureExecutor.cleanup();
    } catch (Exception e) {
      throw e;
    }

  }
}
