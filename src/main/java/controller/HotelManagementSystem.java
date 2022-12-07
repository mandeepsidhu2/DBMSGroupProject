package controller;

import entity.Booking;
import entity.HotelAvailability;
import entity.HotelWithAmenities;
import entity.Occupant;
import entity.Staff;
import entity.User;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.Scanner;
import java.util.stream.Collectors;
import model.BookingModel;
import model.HotelModel;
import model.OccupantModel;
import model.ProcedureExecutor;
import model.StaffModel;
import model.UserModel;

public class HotelManagementSystem {

  /**
   * The name of the MySQL account to use (or empty for anonymous)
   */
  private final String userName;
  /**
   * The password for the MySQL account (or empty for anonymous)
   */
  private final String password;
  /**
   * The name of the computer running MySQL
   */
  private final String serverName = "localhost";
  /**
   * The port of the MySQL server (default is 3306)
   */
  private final int portNumber = 3306;
  /**
   * The name of the database of sharks
   */
  private final String dbName = "final_project";
  private final UserModel userModel;
  private final HotelModel hotelModel;

  private final BookingModel bookingModel;

  private final OccupantModel occupantModel;
  private final StaffModel staffModel;

  Scanner reader = new Scanner(System.in);
  private User currentUserContext;
  private Connection connection = null;

  public HotelManagementSystem(String userName, String password) throws Exception {
    currentUserContext = null;

    this.userName = userName;
    this.password = password;
    try {
      Properties connectionProps = new Properties();
      connectionProps.put("user", this.userName);
      connectionProps.put("password", this.password);

      this.connection = DriverManager.getConnection("jdbc:mysql://"
              + this.serverName + ":" + this.portNumber + "/" + this.dbName
              + "?characterEncoding=UTF-8&useSSL=false",
          connectionProps);
      System.out.println("Congratulations, you are now connected to database");
      ProcedureExecutor procedureExecutor = new ProcedureExecutor(connection);
      userModel = new UserModel(procedureExecutor);
      hotelModel = new HotelModel(procedureExecutor);
      bookingModel = new BookingModel(procedureExecutor);
      occupantModel = new OccupantModel(procedureExecutor);
      staffModel = new StaffModel(procedureExecutor);
    } catch (Exception e) {
      System.out.println(e.getMessage());
      throw new Exception("Invalid username or password was entered, try again\n");
    }
  }

  public void closeConnection() throws SQLException {
    this.connection.close();
  }

  private void printBookingDetails(Booking booking) {
    String startDate = new SimpleDateFormat("dd-MM-yyyy").format(booking.getStartDate());
    String endDate = new SimpleDateFormat("dd-MM-yyyy").format(booking.getEndDate());

    System.out.println(booking.getBookingId() + "             " + booking.getHotelId() + "      "
        + startDate + "    " + endDate + "      " + booking.getName() + ", " + booking.getTown()
        + ", " + booking.getState());
  }


  public void manageUserBookings() {
    List<Booking> bookingList = null;
    try {
      bookingList = this.bookingModel.getBookingsForARoom(this.currentUserContext.getCustomerId());
    } catch (Exception e) {
      System.out.println("Unable to fetch bookings");
      loggedInUserJourney();
      return;
    }
    if (bookingList.size() == 0) {
      System.out.println("No bookings to display");
      loggedInUserJourney();
      return;
    }
    List<Booking> futureBookings = bookingList.stream()
        .filter(b -> !b.getIsCheckedIn() && !b.getIsCheckedOut()).collect(
            Collectors.toList());
    Collections.sort(futureBookings, Comparator.comparingInt(Booking::getBookingId));

    List<Booking> checkedInBookings = bookingList.stream()
        .filter(b -> b.getIsCheckedIn() && !b.getIsCheckedOut()).collect(
            Collectors.toList());
    List<Booking> pastBookings = bookingList.stream()
        .filter(b -> b.getIsCheckedIn() && b.getIsCheckedOut()).collect(
            Collectors.toList());

    if (pastBookings.size() > 0) {
      System.out.println("Past bookings:");
      System.out.println("BookingId | HotelId | StartDate   | EndDate   | Hotel Details");
      for (Booking booking : pastBookings) {
        printBookingDetails(booking);
      }
    }

    if (checkedInBookings.size() > 0) {
      System.out.println("Checked in bookings:");
      System.out.println("BookingId | HotelId | StartDate   | EndDate   | Hotel Details");
      for (Booking booking : checkedInBookings) {
        printBookingDetails(booking);
      }
    }

    if (futureBookings.size() > 0) {
      System.out.println("Future bookings:");
      System.out.println("BookingId | HotelId | StartDate   | EndDate   | Hotel Details");
      for (Booking booking : futureBookings) {
        printBookingDetails(booking);
      }
    }

    if (futureBookings.size() > 0 || pastBookings.size() > 0) {
      System.out.println(
          "Enter a booking id you would like to modify, any other key to exit");
      Integer bookingId;
      try {
        bookingId = inputAnIntFromUser();
        if (futureBookings.stream().filter(booking -> booking.getBookingId()
            .equals(bookingId)).collect(Collectors.toList()).size() == 0 &&
            pastBookings.stream().filter(booking -> booking.getBookingId()
                .equals(bookingId)).collect(Collectors.toList()).size() == 0
        ) {
          throw new IllegalArgumentException("Invalid booking id entered");
        }
      } catch (Exception e) {
        System.out.println("Invalid input");
        loggedInUserJourney();
        return;
      }
      if (futureBookings.stream().filter(booking -> booking.getBookingId()
          .equals(bookingId)).collect(Collectors.toList()).size() != 0) {
        Booking bookingToModify = futureBookings.stream().filter(booking -> booking.getBookingId()
            .equals(bookingId)).collect(Collectors.toList()).get(0);
        modifyFutureBooking(bookingToModify);
      } else if (pastBookings.stream().filter(booking -> booking.getBookingId()
          .equals(bookingId)).collect(Collectors.toList()).size() != 0) {
        Booking bookingToModify = pastBookings.stream().filter(booking -> booking.getBookingId()
            .equals(bookingId)).collect(Collectors.toList()).get(0);
        modifyPastBooking(bookingToModify);
      }
      return;
    }
  }

  private void cancelBooking(Integer bookingId) {
    try {
      this.bookingModel.deleteBooking(bookingId);
    } catch (Exception e) {
      System.out.println("Unable to delete booking due to error " + e.getMessage());
      return;
    }
    System.out.println("The booking has been deleted successfully");
  }

  private void deleteOccupantFromBooking(Integer bookingId) {
    System.out.println("Enter the ssn of the occupant you want to delete");
    String ssn = reader.nextLine();
    try {
      this.occupantModel.deleteOccupantFromBooking(ssn, bookingId);
      System.out.println("Occupant deleted!!");
    } catch (Exception e) {
      System.out.println("Unable to delete occupant due to error -> " + e.getMessage());
      return;
    }
  }

  private void updateBookingDates(Integer bookingId) {
    System.out.println("Enter the new start date(yyyy-MM-dd)");
    String startDateString = reader.nextLine();
    Date startDate = null;
    try {
      startDate = new SimpleDateFormat("yyyy-MM-dd").parse(startDateString);
    } catch (Exception e) {
      System.out.println("Invalid start date entered!");
      return;
    }

    System.out.println(
        "Enter the new end date(in yyyy-MM-dd format)...");
    String endDateString = reader.nextLine();
    Date endDate = null;
    try {
      endDate = new SimpleDateFormat("yyyy-MM-dd").parse(endDateString);
    } catch (Exception e) {
      System.out.println("Invalid end date entered!");
      return;
    }
    try {
      this.bookingModel.updateBookingDates(startDate, endDate, bookingId);
    } catch (Exception e) {
      System.out.println("Unable to modify booking due to error-> " + e.getMessage());
      return;
    }
    System.out.println("The booking has been updated");
  }

  private void modifyPastBooking(Booking booking) {
    System.out.println("\n");
    System.out.println("Details for booking id -> " + booking.getBookingId());
    System.out.println(
        "Booking start date (dd-MM-yyyy)-> " + new SimpleDateFormat("dd-MM-yyyy").format(
            booking.getStartDate()));
    System.out.println(
        "Booking end date (dd-MM-yyyy)-> " + new SimpleDateFormat("dd-MM-yyyy").format(
            booking.getEndDate()));
    System.out.println("What rating would you like to give for your stay");
    Float rating = inputAnFloatFromUser();
    try {
      this.bookingModel.updateBookingRating(rating, booking.getBookingId());
      System.out.println("Rating added, thanks for the feedback");

    } catch (Exception e) {
      System.out.println("Unable to add rating due to error ->" + e.getMessage());
    }
    manageUserBookings();
  }

  private void modifyFutureBooking(Booking booking) {
    System.out.println("\n");
    System.out.println("Details for booking id -> " + booking.getBookingId());
    System.out.println(
        "Booking start date (dd-MM-yyyy)-> " + new SimpleDateFormat("dd-MM-yyyy").format(
            booking.getStartDate()));
    System.out.println(
        "Booking end date (dd-MM-yyyy)-> " + new SimpleDateFormat("dd-MM-yyyy").format(
            booking.getEndDate()));

    List<Occupant> occupantList;
    try {
      occupantList = this.occupantModel.getOccupantDetailsForBooking(booking.getBookingId());
      if (occupantList.size() > 0) {
        System.out.println("Details of occupants are: ");
        System.out.println("Occupant Name | Occupant SSN | Occupant Age");
        for (Occupant occupant : occupantList) {
          System.out.println(
              occupant.getName() + "               " + occupant.getSsn() + "               "
                  + occupant.getAge());
        }
      } else {
        System.out.println("Occupants have currently not been added");
      }

    } catch (Exception e) {
      System.out.println("Error in fetching occupant list" + e.getMessage());
    }

    System.out.println();
    System.out.println("What operation would you like to perform");
    System.out.println("(1)Cancel this this booking");
    System.out.println("(2)Add more occupants");
    System.out.println("(3)Delete occupants");
    System.out.println("(4)Update booking");
    System.out.println("(5)Go back");
    Integer option;
    try {
      option = inputAnIntFromUser();
    } catch (Exception e) {
      System.out.println("Invalid option entered");
      modifyFutureBooking(booking);
      return;
    }
    switch (option) {
      case 1:
        cancelBooking(booking.getBookingId());
        manageUserBookings();
        break;
      case 2:
        addOccupantsToBooking(booking.getBookingId());
        manageUserBookings();
        break;
      case 3:
        deleteOccupantFromBooking(booking.getBookingId());
        manageUserBookings();
        break;
      case 4:
        updateBookingDates(booking.getBookingId());
        manageUserBookings();
        break;
      case 5:
        manageUserBookings();
        break;
    }

  }

  private void getHotelAvailabilityForAHotelForInputDates(HotelWithAmenities hotel, Date startDate,
      Date endDate) {
    List<HotelAvailability> hotelAvailabilities;
    try {
      hotelAvailabilities = this.hotelModel.
          getCategoryWiseHotelAvailabilitiesMapForDate(hotel, startDate, endDate);
    } catch (Exception e) {
      displayHotelDetailPage(hotel);
      return;
    }

    if (hotelAvailabilities.size() == 0) {
      System.out.println("Sorry no availabilities for given dates! Try a different hotel");
      displayHotelDetailPage(hotel);
      return;
    }
    System.out.println("Room Option |  Room Type  |  Rooms available");
    Integer idx = 0;
    System.out.println();

    for (HotelAvailability hotelAvailability : hotelAvailabilities) {
      System.out.println(
          "(" + (idx + 1) + ") | " + hotelAvailability.getRoomCategory() + "     |     "
              + hotelAvailability.getAvailableRooms());
      idx++;
    }
    System.out.println("Select the room type you would like to book between 1 and " + idx + ""
        + "\nPress any other key to go back to hotel list");
    Integer optionSelected = -1;
    try {
      optionSelected = inputAnIntFromUser();
    } catch (Exception ex) {
      displayHotelDetailPage(hotel);
      return;
    }
    if (optionSelected < 0 || optionSelected > hotelAvailabilities.size()) {
      System.out.println("Invalid option selected, try again");
      displayHotelDetailPage(hotel);
      return;
    }

    Integer idxOfHotelAvailabilityInArray = optionSelected - 1;
    Integer bookingId = null;
    try {
      bookingId = this.bookingModel.bookARoom(this.currentUserContext.getCustomerId(), startDate,
          endDate,
          hotel.getId(),
          hotelAvailabilities.get(idxOfHotelAvailabilityInArray).getRoomCategory()
      );
    } catch (Exception e) {
      System.out.println("Unable to book a room due to error-> " + e.getMessage());
      System.out.println("Please try again");
      displayHotelDetailPage(hotel);
      return;
    }
    System.out.println("Congratulations booking created!!");
    System.out.println("To add occupants to the booking, press y, any other key to add later");
    System.out.println("[Occupants can be added in manage bookings section]");
    String userInput = reader.nextLine();
    if (userInput.equals("y")) {
      addOccupantsToBooking(bookingId);
    }
    manageUserBookings();

  }

  void addOccupantsToBooking(Integer bookingId) {
    System.out.println("Enter occupant ssn");
    String ssn = reader.nextLine();

    System.out.println("Enter occupant name");
    String name = reader.nextLine();

    System.out.println("Enter occupant age");
    Integer age = inputAnIntFromUser();

    try {
      this.occupantModel.addOccupantToABooking(bookingId, ssn, name, age);
    } catch (Exception e) {
      System.out.println("Unable to add more occupants");
      manageUserBookings();
      return;
    }
    System.out.println("Occupant added");

    System.out.println("To continue occupants to the booking, press y, any other key to add later");
    System.out.println("[Occupants can be added in manage bookings section]");
    String userInput = reader.nextLine();
    if (userInput.equals("y")) {
      addOccupantsToBooking(bookingId);
      return;
    }
  }

  private void displayHotelDetailPage(HotelWithAmenities hotel) {
    System.out.println("Welcome to hotel " + hotel.getName());
    System.out.println(hotel.getStreet() + ", " + hotel.getTown() + ", " + hotel.getState());

    System.out.println(
        "Enter the start date for the booking you want to create(in YYYY-MM-DD format)...");
    String startDateString = reader.nextLine();
    Date startDate = null;
    try {
      startDate = new SimpleDateFormat("yyyy-MM-dd").parse(startDateString);
    } catch (Exception e) {
      System.out.println("Invalid start date entered!");
      displayHotelDetailPage(hotel);
      return;
    }

    System.out.println(
        "Enter the end date for the booking you want to create(in YYYY-MM-DD format)...");
    String endDateString = reader.nextLine();
    Date endDate = null;
    try {
      endDate = new SimpleDateFormat("yyyy-MM-dd").parse(endDateString);
    } catch (Exception e) {
      System.out.println("Invalid end date entered!");
      displayHotelDetailPage(hotel);
      return;
    }
    getHotelAvailabilityForAHotelForInputDates(hotel, startDate, endDate);

  }

  public void viewUserHotelOptions(Boolean getAvailabilityToday) {
    Date dateToQuery = new Date();
    if (!getAvailabilityToday) {
      System.out.println("Please enter date in format YYYY-MM-DD");
      String dateInput = reader.nextLine();
      try {
        dateToQuery = new SimpleDateFormat("yyyy-MM-dd").parse(dateInput);
      } catch (Exception e) {
        System.out.println("Invalid date enetred!");
        viewUserHotelOptions(false);
        return;
      }
    }
    List<HotelWithAmenities> hotelWithAmenities = null;
    try {
      hotelWithAmenities = hotelModel.getAllAvailableHotelsWithAmenities(
          dateToQuery);
    } catch (Exception e) {
      viewUserHotelOptions(getAvailabilityToday);
      System.out.println("Unable to load hotel details");
      return;
    }
    String s = "Id |Name        | AvgRating  |  Email        |  Phone          | Available Rooms | State| Town  | Street         | Amenities                   | Amenities Description";
    s = String.join("\u0332", s.split("", -1));
    System.out.println(s);
    for (HotelWithAmenities hotel : hotelWithAmenities) {
      String rating = hotel.getAvgRating() == 0 ? "N.A." : hotel.getAvgRating().toString();
      System.out.println(
          hotel.getId() + " | " + hotel.getName() + " | " + rating + " | " + hotel.getEmail()
              + " | "
              + hotel.getPhone() + " |  " + hotel.getTotalAvailableRooms() + " | "
              + hotel.getState()
              + "  | "
              + hotel.getTown() + " | " + hotel.getStreet() + " | " + hotel.getAmenities() + " | "
              + hotel.getAmenitiesDescription());
    }
    System.out.println("Enter a hotel id to view further details or press any other key to exit");
    Integer optionSelected;
    try {
      optionSelected = inputAnIntFromUser();
      if (hotelWithAmenities.stream()
          .filter(hotelWithAmenities1 -> hotelWithAmenities1.getId().equals(optionSelected))
          .collect(
              Collectors.toList()).size() == 0) {
        throw new IllegalArgumentException("Invalid hotel id selected");
      }
    } catch (IllegalArgumentException e) {
      System.out.println(e.getMessage());
      viewUserHotelOptions(getAvailabilityToday);
      return;
    } catch (Exception e) {
      System.out.println("Going back to previous menu");
      loggedInUserJourney();
      return;
    }
    displayHotelDetailPage(hotelWithAmenities.stream()
        .filter(hotelWithAmenities1 -> hotelWithAmenities1.getId().equals(optionSelected)).collect(
            Collectors.toList()).get(0));
  }

  private Integer inputAnIntFromUser() {
    int action;
    try {
      action = reader.nextInt();
      // consume the \n after the int
      reader.nextLine();
      return action;
    } catch (Exception e) {
      System.out.println("Invalid integer entered!");
      reader.nextLine();
      throw e;
    }
  }

  private Float inputAnFloatFromUser() {
    float action;
    try {
      action = reader.nextFloat();
      // consume the \n after the int
      reader.nextLine();
      return action;
    } catch (Exception e) {
      System.out.println("Invalid integer entered!");
      reader.nextLine();
      throw e;
    }
  }

  public void loggedInUserJourney() {
    List<Integer> options = Arrays.asList(1, 2, 3, 4);
    System.out.println("\nWhat would you like to do?");
    System.out.println("(1) View your bookings");
    System.out.println("(2) View currently available hotels");
    System.out.println("(3) Get availability by date");
    System.out.println("(4) Logout");
    System.out.println("Press 1, 2 , 3 or 4");
    Integer option = inputAnIntFromUser();
    if (!options.contains(option)) {
      System.out.println("Invalid option selected!");
      loggedInUserJourney();
      return;
    }
    switch (option) {
      case 1:
        manageUserBookings();
        break;
      case 2:
        viewUserHotelOptions(true);
        break;
      case 3:
        viewUserHotelOptions(false);
        break;
      case 4:
        this.currentUserContext = null;
        startUserLoginProcess();
        System.out.println("Logged out!");
        break;
    }
  }


  public User startUserSignupProcess(String ssn) throws SQLException {
    System.out.println("Enter name");
    String name = reader.nextLine();

    System.out.println("Enter phone");
    String phone = reader.nextLine();

    System.out.println("Enter email");
    String email = reader.nextLine();

    System.out.println("Enter age");
    Integer age = inputAnIntFromUser();

    User userToCreate = new User().toBuilder().age(age).email(email).phone(phone).name(name)
        .ssn(ssn).build();
    userModel.createUser(userToCreate);
    System.out.println("Signed up... ");
    return this.userModel.getUserBySSN(ssn);
  }

  public void startUserLoginProcess() {
    System.out.println("Enter ssn or press x to go back");
    String ssn = reader.nextLine();
    if (ssn.equals("x")) {
      run();
      return;
    }
    try {
      User user = userModel.getUserBySSN(ssn);
      if (user == null) {
        System.out.println("User doesn't exist please signup first");
        user = startUserSignupProcess(ssn);
      }
      System.out.println("Congratulations, you are now logged in as " + user.getName());
      this.currentUserContext = user;
      loggedInUserJourney();
    } catch (Exception e) {
      System.out.println("Unable to load the user, try again");
      startUserLoginProcess();
    }
  }

  public void startHotelStaffProcess() {
    System.out.println("Welcome to hotel-staff portal.\n" +
        "Here you can handle all the bookings for customers at your hotel.\n");
    int hotelId = 0, staffId = 0;
    System.out.println("Enter the hotel id:");
    try {
      hotelId = inputAnIntFromUser();
    } catch (Exception e) {
      System.out.println("Entry not a digit");
      startHotelStaffProcess();
      return;
    }
    System.out.println("Enter the staff id:");
    try {
      staffId = inputAnIntFromUser();
    } catch (Exception e) {
      System.out.println("Entry not a digit");
      startHotelStaffProcess();
      return;
    }

    List<Staff> staffData = null;
    try {
      staffData = staffModel.getStaffData(staffId);
    } catch (Exception e) {
      System.out.println("Error extracting data from the data server. Try again!" + e.getMessage());
      startHotelStaffProcess();
    }
    if (staffData.size() == 0) {
      System.out.println("No such staff exists");
      startHotelStaffProcess();
      return;
    } else if (staffData.get(0).getHotelId() != hotelId) {
      System.out.println("The entered staff-id does not work at the specified hotel.");
      startHotelStaffProcess();
      return;
    } else if (staffData.get(0).getHotelId() == hotelId && staffData.get(0).getIsManager() == 1) {
      System.out.println("Taking you to manager's options panel.");
      startManagerStaffProcess(staffId, hotelId);
      startHotelStaffProcess();
      return;
    } else {
      System.out.println("Taking you to regular-hotel staff options panel.");
      startRegularStaffProcess(staffId, hotelId);
      startHotelStaffProcess();
      return;
    }

  }

  public void startRegularStaffProcess(Integer staffId, Integer hotelId) {
    System.out.println("Welcome staff id:" + staffId +
        "\nPress 1 to view bookings." +
        "\nPress 2 to checkin a booking made at the hotel." +
        "\nPress 3 to checkout the guests from the hotel" +
        "\nPress 4 to exit out of this menu." +
        "\nPress 5 to go back to user-type selection menu.");
    int choice;
    try {
      choice = inputAnIntFromUser();
    } catch (Exception e) {
      System.out.println(e.getMessage());
      startRegularStaffProcess(staffId, hotelId);
      return;
    }
    switch (choice) {
      case 1:
        try {
          getHotelBookingsPrinted(hotelId);
        } catch (Exception e) {
          System.out.println("Unable to connect to the database.");
          return;
        }
        startRegularStaffProcess(staffId, hotelId);
        return;
      case 2:
        checkInBookingJourney(staffId, hotelId);
        startRegularStaffProcess(staffId, hotelId);
        return;
      case 3:
        checkOutBookingJourney(staffId, hotelId);
        startRegularStaffProcess(staffId, hotelId);
        return;
      case 4:
        break;
      case 5:
        run();
        return;
      default:
        startRegularStaffProcess(staffId, hotelId);
        return;
    }
  }

  public void startManagerStaffProcess(Integer staffId, Integer hotelId) {
    System.out.println("Welcome staff id:" + staffId +
        "\nPress 1 to view bookings." +
        "\nPress 2 to checkin a booking made at the hotel." +
        "\nPress 3 to checkout the guests from the hotel" +
        "\nPress 4 to add staff members for the hotel working force" +
        "\nPress 5 to delete non-manager staff members from the hotel working force" +
        "\nPress 6 to see all staff members for your hotel" +
        "\nPress 7 to go back to user-type selection menu");
    int choice;
    try {
      choice = inputAnIntFromUser();
    } catch (Exception e) {
      System.out.println(e.getMessage());
      startManagerStaffProcess(staffId, hotelId);
      return;
    }

    switch (choice) {
      case 1:
        try {
          getHotelBookingsPrinted(hotelId);
        } catch (Exception e) {
          System.out.println("Unable to connect to the database.");
//          return;
        }
        startManagerStaffProcess(staffId, hotelId);
        return;
      case 2:
        checkInBookingJourney(staffId, hotelId);
        startManagerStaffProcess(staffId, hotelId);
        return;
      case 3:
        checkOutBookingJourney(staffId, hotelId);
        startManagerStaffProcess(staffId, hotelId);
        return;
      case 4:
        addStaffJourney(hotelId);
        startManagerStaffProcess(staffId, hotelId);
        return;
      case 5:
        deleteStaffJourney(staffId);
        startManagerStaffProcess(staffId, hotelId);
        return;
      case 6:
        try {
          getStaffForHotelPrinted(hotelId);
        } catch (Exception e) {
          System.out.println("Unable to connect to the database.");
        }
        startManagerStaffProcess(staffId, hotelId);
        return;
      case 7:
        run();
        return;

      default:
        startManagerStaffProcess(staffId, hotelId);
        return;
    }
  }

  private void getStaffForHotelPrinted(Integer hotelId) throws SQLException {
    List<Staff> staffList = new ArrayList<>();
    staffList = staffModel.getStaffListForHotel(hotelId);
    System.out.println("Heres a list of available staff members at this hotel:");
    System.out.println();
    System.out.println("Staff-Id" + " | " + "Name" + " | " + "Phone" +
        " | " + "Email" + " | " + "SSN" + " | " + "Is-Manager" +
        "Contract Start Date" + " | " + "Contract End Date" + " | " + "Hotel Id"
    );
    for (Staff s : staffList) {
      System.out.println(s.getStaffId() + " | " + s.getName() + " | " + s.getPhone() + " | " +
          s.getEmail() + " | " + s.getSsn() + " | " + s.getIsManager() +
          " | " + s.getContractStartDate() + " | " + s.getContractEndDate() + " | " + s.getHotelId()
      );
    }
  }

  public void deleteStaffJourney(Integer managerId) {
    System.out.println("Enter id of the staff to be deleted.");
    Integer staffId = 0;
    try {
      staffId = inputAnIntFromUser();
    } catch (Exception e) {
      System.out.println("Retry!");
      return;
    }
    try {
      staffModel.deleteStaffMember(managerId, staffId);
      System.out.println("Staff deleted successfully");
      return;
    } catch (Exception e) {
      System.out.println("Unable to delete staff.");
      return;
    }

  }

  public void addStaffJourney(Integer hotelId) {
    System.out.println("Enter new staff name");
    String name = reader.nextLine();
    System.out.println("Enter staff's phone no:");
    String phone = reader.nextLine();
    System.out.println("Enter staff's email id:");
    String email = reader.nextLine();
    System.out.println("Enter staff's SSN no:");
    String ssn = reader.nextLine();
    System.out.println("Enter staff's start date in the format yyyy-MM-dd:");
    String startDate = reader.nextLine();
    System.out.println("Enter staff's end date as per initial contract in the format yyyy-MM-dd:");
    String endDate = reader.nextLine();
    try {
      staffModel.createStaffMember(name, phone, email, ssn, startDate, endDate, hotelId);
      System.out.println("Staff creation successful");
      return;
    } catch (Exception e) {
      System.out.println("Creating new staff failed");
      return;
    }


  }


  public void checkOutBookingJourney(Integer staffId, Integer hotelId) {
    Integer bookingId = -1;
    try {
      System.out.println("Enter the booking id of the order to be checked-out:");
      bookingId = inputAnIntFromUser();
    } catch (Exception e) {
      System.out.println("Entry not a digit");
      startRegularStaffProcess(staffId, hotelId);
      return;
    }
    try {
      bookingModel.checkOutBooking(bookingId, staffId);
      System.out.println("Check out Successful");
    } catch (Exception e) {
      System.out.println(e.getMessage());
    }
  }

  public void checkInBookingJourney(Integer staffId, Integer hotelId) {
    Integer bookingId = -1;
    try {
      System.out.println("Enter the booking id of the order to be checked-in:");
      bookingId = inputAnIntFromUser();
    } catch (Exception e) {
      System.out.println("Invalid Integer entered");
      startRegularStaffProcess(staffId, hotelId);
      return;
    }
    try {
      bookingModel.checkInBooking(bookingId, staffId);
      System.out.println("Check in Successful");
    } catch (Exception e) {
      System.out.println(e.getMessage());
    }
  }

  public void getHotelBookingsPrinted(Integer hotelId) throws SQLException {
    List<Booking> bookingsList = new ArrayList<>();
    bookingsList = bookingModel.getBookingsForHotel(hotelId);
    System.out.println("Heres a list of available bookings for this hotel:");
    System.out.println();
    System.out.println("Customer-Id" + " | " + "Booking-Id" + " | " + "Hotel-Id" +
        " | " + "Check-in Staff Id" + " | " + "Check-out Staff Id" + " | " + "IsChecked-in?" +
        "IsChecked-out" + " | " + "Start Date" + " | " + "End Date" + " | " + "Rating"
        + " | " + "Rating Description" + " | " + "Room No"
    );
    for (Booking b : bookingsList) {
      System.out.println(
          b.getCustomerId() + " | " + b.getBookingId() + " | " + b.getHotelId() + " | " +
              b.getCheckedInByStaffId() + " | " + b.getCheckedOutByStaffId() + " | "
              + b.getIsCheckedIn() +
              " | " + b.getIsCheckedOut() + " | " + b.getStartDate() + " | " + b.getEndDate()
              + " | " +
              b.getRating() + " | " + b.getRatingDescription() + " | " + b.getRoomNo());
    }
  }

  /**
   * Connect to MySQL and do some stuff.
   */
  public void run() {
    List<Integer> ops = Arrays.asList(1, 2, 3);
    System.out.println("Welcome to the portal!");
    System.out.println("What would you like to do?\n(1) Login as a user");
    System.out.println("(2) Login as hotel staff");
    System.out.println("(3) Press 3 to exit");
    System.out.println("Press 1, 2 or 3");

    Integer optionSelected = -1;
    try {
      optionSelected = inputAnIntFromUser();
    } catch (Exception ex) {
      System.out.println("Invalid input");
      run();
      return;
    }
    if (!ops.contains(optionSelected)) {
      System.out.println("Invalid input");
      run();
      return;
    }
    switch (optionSelected) {
      case 1:
        startUserLoginProcess();
        break;
      case 2:
        startHotelStaffProcess();
        break;
      case 3:
        System.exit(0);
        return;
    }


  }


}
