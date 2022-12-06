package model;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import entity.Staff;

public class StaffModel {

  ProcedureExecutor procedureExecutor;

  public StaffModel(ProcedureExecutor procedureExecutor) {
    this.procedureExecutor = procedureExecutor;
  }

  private List<Staff> getFromIteratorStaffList(ResultSet resultSetFromProcedure) throws SQLException {
    List<Staff> list = new ArrayList<>();
    while (resultSetFromProcedure.next()) {
      Integer staffId = Integer.valueOf(resultSetFromProcedure.getString("staffId"));
      String name = resultSetFromProcedure.getString("name");
      String phone = resultSetFromProcedure.getString("phone");
      String email = resultSetFromProcedure.getString("email");
      String ssn = resultSetFromProcedure.getString("ssn");
      Integer isManager = Integer.valueOf(resultSetFromProcedure.getString("ismanager"));
      String contractStartDate = resultSetFromProcedure.getString("contractStartDate");
      String contractEndDate = resultSetFromProcedure.getString("contractEndDate");
      Integer hotelId = Integer.valueOf(resultSetFromProcedure.getString("hotelId"));

      Staff staff = new Staff().toBuilder()
              .staffId(staffId)
              .name(name)
              .phone(phone)
              .email(email)
              .ssn(ssn)
              .isManager(isManager)
              .contractStartDate(contractStartDate)
              .contractEndDate(contractEndDate)
              .hotelId(hotelId)
              .build();
      list.add(staff);
    }
    return list;
  }


  public List<Staff> getStaffData(Integer staffId) throws SQLException {
    String query = "call getStaffById(?)";
    List<Staff> staffDataList;
    try {
      System.out.println("heree1");
      ResultSet resultSet =  procedureExecutor.preparedStatement(query)
              .setStatementParam(1, staffId.toString())
              .execute();
      staffDataList = getFromIteratorStaffList(resultSet);
      procedureExecutor.cleanup();
    }
    catch (Exception e) {
      procedureExecutor.cleanup();
      throw e;
    }
    return staffDataList;
  }

  public void createStaffMember(String name, String phone, String email,
                                String ssn, String startDate, String endDate, Integer hotelId)
          throws SQLException {
    String query = "call createStaff(?,?, ?, ?, ?, ?, ?, ?)";
    List<Staff> staffDataList;
    try {
      ResultSet resultSet =  procedureExecutor.preparedStatement(query)
              .setStatementParam(1, name.toString())
              .setStatementParam(2, phone.toString())
              .setStatementParam(3, email.toString())
              .setStatementParam(4, ssn.toString())
              .setStatementParam(5, "0")
              .setStatementParam(6, startDate.toString())
              .setStatementParam(7, endDate.toString())
              .setStatementParam(8, hotelId.toString())
              .execute();
      procedureExecutor.cleanup();
    }
    catch (Exception e) {
      procedureExecutor.cleanup();
      throw e;
    }
  }

  public void deleteStaffMember(Integer managerId, Integer staffId) throws SQLException {
    String query = "call deleteStaff(?, ?)";
    List<Staff> staffDataList;
    try {
      ResultSet resultSet =  procedureExecutor.preparedStatement(query)
              .setStatementParam(1, managerId.toString())
              .setStatementParam(2, staffId.toString())
              .execute();
      procedureExecutor.cleanup();
    }
    catch (Exception e) {
      procedureExecutor.cleanup();
      throw e;
    }
  }
}
