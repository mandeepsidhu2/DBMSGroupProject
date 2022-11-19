package model;

import entity.Hotel;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HotelModel {

  ProcedureExecutor procedureExecutor;

  public HotelModel(ProcedureExecutor procedureExecutor) {
    this.procedureExecutor = procedureExecutor;
  }

  List<Hotel> getFromIterator(ResultSet resultSetFromProcedure) throws SQLException {
    List<Hotel> list = new ArrayList<>();
    while (resultSetFromProcedure.next()) {
      String name = resultSetFromProcedure.getString("name");
      String street = resultSetFromProcedure.getString("street");
      String town = resultSetFromProcedure.getString("town");
      String state = resultSetFromProcedure.getString("state");
      String zip = resultSetFromProcedure.getString("zip");
      Float avgRating = Float.parseFloat(resultSetFromProcedure.getString("avgRating"));
      String phone = resultSetFromProcedure.getString("phone");
      String email = resultSetFromProcedure.getString("email");

      Hotel hotel = new Hotel().toBuilder().name(name).avgRating(avgRating).email(email)
          .phone(phone).town(town).state(state).zip(zip).state(state).street(street)
          .build();
      list.add(hotel);
    }
    return list;
  }

}
