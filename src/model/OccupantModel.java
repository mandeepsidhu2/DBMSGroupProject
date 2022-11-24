package model;

import entity.HotelAvailability;
import entity.Occupant;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OccupantModel {

  ProcedureExecutor procedureExecutor;

  public OccupantModel(ProcedureExecutor procedureExecutor) {
    this.procedureExecutor = procedureExecutor;
  }

  private List<Occupant> getFromIteratorOccupantList(ResultSet resultSetFromProcedure)
      throws SQLException {
    List<Occupant> list = new ArrayList<>();
    while (resultSetFromProcedure.next()) {
      Integer age = Integer.valueOf(resultSetFromProcedure.getString("age"));
      String ssn = resultSetFromProcedure.getString("ssn");
      String  name = resultSetFromProcedure.getString("name");

      Occupant occupant = new Occupant().toBuilder()
          .age(age)
          .name(name)
          .ssn(ssn)
          .build();
      list.add(occupant);
    }
    return list;
  }

  public List<Occupant> getOccupantDetailsForBooking(Integer bookingId) throws SQLException {
    String query= "call getOccupantDetailsForBooking(?)";
    List<Occupant> occupantList;
    try{
      ResultSet resultSet= procedureExecutor.preparedStatement(query)
          .setStatementParam(1, bookingId.toString())
          .execute();
      occupantList=getFromIteratorOccupantList(resultSet);
      procedureExecutor.cleanup();
    }catch (Exception e){
      throw e;
    }
    return occupantList;
  }

  public void deleteOccupantFromBooking(String ssn,Integer bookingId) throws SQLException {
    String query= "call deleteOccupantFromBooking(?,?)";
    try{
      ResultSet resultSet= procedureExecutor.preparedStatement(query)
          .setStatementParam(1, ssn)
          .setStatementParam(2,bookingId.toString())
          .execute();
      procedureExecutor.cleanup();
    }catch (Exception e){
      throw e;
    }
  }


  public void addOccupantToABooking(Integer bookingId,String occupantSSN,String occupantName,Integer occupantAge){
    String query= "call addOccupantToBooking(?,?,?,?)";
    try{
      procedureExecutor.preparedStatement(query)
          .setStatementParam(1, bookingId.toString())
          .setStatementParam(2, occupantSSN)
          .setStatementParam(3, occupantName)
          .setStatementParam(4, occupantAge.toString())
          .execute();
    }catch (Exception e){
      throw e;
    }
  }


}
