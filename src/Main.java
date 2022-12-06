import controller.HotelManagementSystem;
import java.util.Scanner;

public class Main {

  public static void main(String[] args) throws Exception {
    HotelManagementSystem hotelManagementSystem = createAppConnection();
    hotelManagementSystem.run();
    System.out.println("\nClosing the connection to database");
    hotelManagementSystem.closeConnection();
    System.out.println("CLOSED CONNECTION");
  }

  private static HotelManagementSystem createAppConnection() {
    Scanner reader = new Scanner(System.in);

  //     System.out.println("Please enter the username for the database");
  //      String username = reader.nextLine();
      String username = "root";
      String password = "hello123";
  //    System.out.println("Please enter the password for the database");
  //    String password = reader.nextLine();

    HotelManagementSystem app;
    try {
      app = new HotelManagementSystem(username, password);
    } catch (Exception e) {
      System.out.println(e.getMessage());
      app = createAppConnection();
    }
    return app;

  }
}
