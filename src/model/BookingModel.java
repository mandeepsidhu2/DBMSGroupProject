package model;

import entity.Booking;
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

  List<Booking> getFromIteratorBookingWithHotelDetails(ResultSet resultSetFromProcedure)
      throws SQLException {
    List<Booking> list = new ArrayList<>();
    while (resultSetFromProcedure.next()) {
      Integer customerId = Integer.valueOf(resultSetFromProcedure.getString("customer"));
      Integer bookingId = Integer.valueOf(resultSetFromProcedure.getString("bookingId"));
      Integer hotelId = Integer.valueOf(resultSetFromProcedure.getString("hotel"));

      String checkinOutByStaffIdString = resultSetFromProcedure.getString("checkedInByStaffId");
      Integer checkedInByStaffId =
          checkinOutByStaffIdString == null ? null : Integer.valueOf(checkinOutByStaffIdString);

      String checkedOutByStaffIdString = resultSetFromProcedure.getString("checkedOutByStaffId");
      Integer checkedOutByStaffId =
          checkedOutByStaffIdString == null ? null : Integer.valueOf(checkedOutByStaffIdString);

      String ratingString = resultSetFromProcedure.getString("rating");
      Float rating = ratingString == null ? null : Float.valueOf(ratingString);

      String hotelName = resultSetFromProcedure.getString("name");
      String hotelStreet = resultSetFromProcedure.getString("street");
      String hotelTown = resultSetFromProcedure.getString("town");
      String hotelState = resultSetFromProcedure.getString("state");
      String hotelZip = resultSetFromProcedure.getString("zip");
      Float hotelAvgRating = Float.parseFloat(resultSetFromProcedure.getString("avgRating"));
      String hotelPhone = resultSetFromProcedure.getString("phone");
      String hotelEmail = resultSetFromProcedure.getString("email");

      Boolean isCheckedOut = resultSetFromProcedure.getString("isCheckedOut").equals("1");
      Boolean isCheckedIn = resultSetFromProcedure.getString("isCheckedIn").equals("1");
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
      Booking booking = new Booking().builder()
          // hotel details
          .name(hotelName)
          .town(hotelTown)
          .state(hotelState)
          .street(hotelStreet)
          .zip(hotelZip)
          .avgRating(hotelAvgRating)
          .phone(hotelPhone)
          .email(hotelEmail)
          //customer details
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

  public void deleteBooking(Integer bookingId) throws SQLException {
    String query = "call deleteBooking(?)";
    try {
      procedureExecutor.preparedStatement(query)
          .setStatementParam(1, bookingId.toString())
          .execute();
      procedureExecutor.cleanup();
    } catch (SQLException sqlException) {
      procedureExecutor.cleanup();
      throw sqlException;
    }


  }

  public List<Booking> getBookingsForARoom(Integer customerID) throws SQLException {
    String query = "call getUserBookings(?)";

    ResultSet resultSet = procedureExecutor.preparedStatement(query)
        .setStatementParam(1, customerID.toString())
        .execute();

    List<Booking> bookingList;
    try {
      bookingList = getFromIteratorBookingWithHotelDetails(resultSet);
      procedureExecutor.cleanup();
    } catch (Exception e) {
      procedureExecutor.cleanup();
      throw e;
    }
    return bookingList;
  }

  Integer getFromIteratorBookingId(ResultSet resultSetFromProcedure)
      throws SQLException {
    Integer bookingId = null;
    while (resultSetFromProcedure.next()) {
      bookingId = Integer.valueOf(resultSetFromProcedure.getString("bookingId"));
    }
    return bookingId;
  }

  public void updateBookingDates(Date reqStartDate, Date reqEndDate, Integer bookingId)
      throws SQLException {
    String query = "call updateBooking(?,?,?)";
    try {
      procedureExecutor.preparedStatement(query)
          .setStatementParam(1, new java.sql.Date(reqStartDate.getTime()).toString())
          .setStatementParam(2, new java.sql.Date(reqEndDate.getTime()).toString())
          .setStatementParam(3, bookingId.toString())
          .execute();
      procedureExecutor.cleanup();
    } catch (Exception e) {
      procedureExecutor.cleanup();
      throw e;
    }
  }

  public void updateBookingRating(Float rating, Integer bookingId)
      throws SQLException {
    String query = "call addRatingForBooking(?,?)";
    try {
      procedureExecutor.preparedStatement(query)
          .setStatementParam(1, bookingId.toString())
          .setStatementParam(2, rating.toString())
          .execute();
      procedureExecutor.cleanup();
    } catch (Exception e) {
      procedureExecutor.cleanup();
      throw e;
    }
  }


  public Integer bookARoom(Integer customerId, Date reqStartDate, Date reqEndDate, Integer hotelId,
      String roomCategory) throws SQLException {
    String query = "call createBooking(?,?,?,?,?,?)";
    try {
      ResultSet resultSet = procedureExecutor.preparedStatement(query)
          .setStatementParam(1, hotelId.toString())
          .setStatementParam(2, customerId.toString())
          .setStatementParam(3, new java.sql.Date(reqStartDate.getTime()).toString())
          .setStatementParam(4, new java.sql.Date(reqEndDate.getTime()).toString())
          .setStatementParam(5, roomCategory)
          .setStatementParam(6, null)
          .execute();
      Integer bookingId = getFromIteratorBookingId(resultSet);
      procedureExecutor.cleanup();
      return bookingId;
    } catch (Exception e) {
      procedureExecutor.cleanup();
      throw e;
    }
  }


}
