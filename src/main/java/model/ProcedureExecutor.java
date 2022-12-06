package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProcedureExecutor {

  private final Connection connection;
  private PreparedStatement prepareStatementForProcedure;

  private ResultSet resultSet;

  public ProcedureExecutor(Connection connection) {
    this.connection = connection;
  }

  public ProcedureExecutor preparedStatement(String statement) {
    prepareStatementForProcedure = null;

    try {
      prepareStatementForProcedure = this.connection.prepareStatement(statement);
    } catch (SQLException sqlException) {
      System.out.println(sqlException.getMessage());
      return null;
    }
    return this;

  }

  public ProcedureExecutor setStatementParam(Integer idx, String s) {
    try {
      prepareStatementForProcedure.setString(idx, s);
    } catch (SQLException sqlException) {
      System.out.println(sqlException.getMessage());
      return null;
    }
    return this;
  }

  public ResultSet execute() throws SQLException {
    ResultSet resultSet = null;
    try {
      resultSet = prepareStatementForProcedure.executeQuery();

    } catch (SQLException sqlException) {
      System.out.println(sqlException.getMessage());
      throw sqlException;
    }
    this.resultSet = resultSet;
    return resultSet;
  }

  public void cleanup() {
    try {
      if (prepareStatementForProcedure != null) {
        prepareStatementForProcedure.close();
      }
      if (resultSet != null) {
        resultSet.close();
      }
    } catch (Exception e) {
      System.out.println(e.getMessage());
    }

  }
}
