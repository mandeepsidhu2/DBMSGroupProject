package view;

public class View {

  public void firstMessageToUser() {
    System.out.println("Welcome to the portal!");
    System.out.println("What would you like to do?\n (1) Login as a user");
    System.out.println("(2) Login as hotel staff");
    System.out.println("Press 1 or 2");
  }

  public void printExpectedIntegerMessage() {
    System.out.println("Invalid integer entered!");
  }

}
