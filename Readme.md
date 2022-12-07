We are using maven as the dependency management tool for this project.
We are using 2 dependencies.

(1) Lombok: https://projectlombok.org/setup/maven
Lombok is an annotation-based library in Java which allows us to remove boilerplate and repetitive code. For example, with annotations it automatically generates getters, setters, empty and default constructors and an object builder as well. MySQL connector is required for ur JAVA application to interface with the database.

(2) Mysql connector: https://mvnrepository.com/artifact/mysql/mysql-connector-java
MySQL Connector/J is a JDBC Type 4 driver, which means that it is pure Java implementation of the MySQL protocol and does not rely on the MySQL client libraries.MySQL connector is required for ur JAVA application to interface with the database.

Steps to run the project:
    
(1) Go to the `create_schema.sql` file in the root of the project structure

(2) Run the entire file in MySQLWorkbench, it creates the schema, procedures, function, triggers
        and adds the necessary seed data.

(3) We are using Oracle Open JDK version 11.0.16 for our project.

(4) Kindly make sure that JAVA has been correctly installed on your system before proceeding
        to run the jar file.

(5) Copy the jar file to a location of your choice and run it using the command:
             `java -jar DBMSGroupAssignment.jar`

(6) You will be asked enter the username and password for your database, 
enter the details to proceed forward.
    