package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProcedureExecutor {

  private final Connection connection;
  private PreparedStatement prepareStatementForProcedure;

  public ProcedureExecutor(Connection connection) {
    this.connection = connection;
  }

  public ProcedureExecutor preparedStatement(String statement) {
    prepareStatementForProcedure = null;

    try {
      prepareStatementForProcedure = this.connection.prepareStatement(statement);
    } catch (SQLException sqlException) {
      System.out.println("Cannot fetch data " + sqlException.getMessage());
      return null;
    }
    return this;

  }

  public ProcedureExecutor setStatementParam(Integer idx, String s) {
    try {
      prepareStatementForProcedure.setString(idx, s);
    } catch (SQLException sqlException) {
      System.out.println("Cannot fetch data " + sqlException.getMessage());
      return null;
    }
    return this;
  }

  public ResultSet execute() {
    ResultSet resultSet = null;
    try {
      resultSet = prepareStatementForProcedure.executeQuery();
      prepareStatementForProcedure.close();

    } catch (SQLException sqlException) {
      System.out.println("Cannot fetch data " + sqlException.getMessage());
      return null;
    }
    return resultSet;
  }
}
