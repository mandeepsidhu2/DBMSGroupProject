package model;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import entity.Occupant;
import entity.Staff;

public class StaffModel {

  ProcedureExecutor procedureExecutor;

  public StaffModel(ProcedureExecutor procedureExecutor) {
    this.procedureExecutor = procedureExecutor;
  }

  private List<Staff> getFromIteratorStaffList(ResultSet resultSetFromProcedure) throws SQLException {
    List<Occupant> list = new ArrayList<>();
    while (resultSetFromProcedure.next()) {
      Integer age = Integer.valueOf(resultSetFromProcedure.getString("age"));
      String ssn = resultSetFromProcedure.getString("ssn");
      String name = resultSetFromProcedure.getString("name");

      Staff staff = new Staff().toBuilder()
              .age(age)
              .name(name)
              .ssn(ssn)
              .build();
      list.add(staff);
    }
    return list;
  }


  public List<Staff> isStaffManager(Integer staffId) throws SQLException {
    String query = "call isStaffManager(?)";
    List<Staff> staffManagerList;
    try {
      ResultSet resultSet =  procedureExecutor.preparedStatement(query)
              .setStatementParam(1, staffId.toString())
              .execute();
      staffManagerList = getFromIteratorStaffList(resultSet);
      procedureExecutor.cleanup();
    }
    catch (Exception e) {
      procedureExecutor.cleanup();
      throw e;
    }
    return staffManagerList;
  }

}
