package model;

import entity.HotelWithAmenities;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class HotelModel {

  ProcedureExecutor procedureExecutor;

  public HotelModel(ProcedureExecutor procedureExecutor) {
    this.procedureExecutor = procedureExecutor;
  }

  List<HotelWithAmenities> getFromIteratorHotelWithAmenities(ResultSet resultSetFromProcedure)
      throws SQLException {
    List<HotelWithAmenities> list = new ArrayList<>();
    while (resultSetFromProcedure.next()) {
      Integer id = Integer.valueOf(resultSetFromProcedure.getString("id"));
      String name = resultSetFromProcedure.getString("name");
      String street = resultSetFromProcedure.getString("street");
      String town = resultSetFromProcedure.getString("town");
      String state = resultSetFromProcedure.getString("state");
      String zip = resultSetFromProcedure.getString("zip");
      Float avgRating = Float.parseFloat(resultSetFromProcedure.getString("avgRating"));
      String phone = resultSetFromProcedure.getString("phone");
      String email = resultSetFromProcedure.getString("email");

      String amenitiesName = resultSetFromProcedure.getString("amenities");
      String amenitiesDescription = resultSetFromProcedure.getString("amenitiesDescription");
      Integer totalAvailableRooms = Integer.valueOf(
          resultSetFromProcedure.getString("totalAvailableRooms"));

      HotelWithAmenities hotel = new HotelWithAmenities().builder().id(id).name(name)
          .avgRating(avgRating).email(email)
          .phone(phone).town(town).state(state).zip(zip).state(state).street(street)
          .amenities(amenitiesName).amenitiesDescription(amenitiesDescription)
          .totalAvailableRooms(totalAvailableRooms)
          .build();
      list.add(hotel);
    }
    return list;
  }

  public List<HotelWithAmenities> getAllAvailableHotelsWithAmenities(Date availableHotelsForDate) {
    String query = "call getAvailableHotels(?)";
    ResultSet resultSet = procedureExecutor.preparedStatement(query)
        .setStatementParam(1, new java.sql.Date(availableHotelsForDate.getTime()).toString())
        .execute();
    List<HotelWithAmenities> hotelWithAmenities;
    try {
      hotelWithAmenities = getFromIteratorHotelWithAmenities(resultSet);
    } catch (Exception e) {
      System.out.println(e.getMessage());
      return null;
    }
    procedureExecutor.cleanup();
    return hotelWithAmenities;
  }

}
