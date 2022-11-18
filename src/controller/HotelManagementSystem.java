package controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Scanner;

public class HotelManagementSystem {
  Scanner reader = new Scanner(System.in);;

  /** The name of the MySQL account to use (or empty for anonymous) */
  private final String userName ;

  /** The password for the MySQL account (or empty for anonymous) */
  private final String password ;

  /** The name of the computer running MySQL */
  private final String serverName = "localhost";

  /** The port of the MySQL server (default is 3306) */
  private final int portNumber = 3306;

  /** The name of the database of sharks */
  private final String dbName = "sharkdbsidhum";

  private Connection connection = null ;
  public HotelManagementSystem(String userName,String password) throws Exception{
    this.userName=userName;
    this.password=password;
    try {
      Properties connectionProps = new Properties();
      connectionProps.put("user", this.userName);
      connectionProps.put("password", this.password);

      this.connection = DriverManager.getConnection("jdbc:mysql://"
              + this.serverName + ":" + this.portNumber + "/" + this.dbName + "?characterEncoding=UTF-8&useSSL=false",
          connectionProps);
      System.out.println("Congratulations, you are now connected to database");

    }
    catch (Exception e){
      System.out.println(e.getMessage());
      throw new Exception("Invalid username or password was entered, try again\n");
    }
  }

  /**
   * Connect to MySQL and do some stuff.
   */
  public void run() throws SQLException {
   // getUserTownAndStateInputFromUser();

  }

  public void closeConnection() throws SQLException {
    this.connection.close();
  }

}
