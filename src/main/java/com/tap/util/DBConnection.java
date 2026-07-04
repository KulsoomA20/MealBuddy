package com.tap.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	
	private static String URL;
	private static String USERNAME;
	private static String PASSWORD;
	private static Connection con;

	static {
		// Look for cloud environment variables (e.g. Railway MySQL)
		String dbHost = System.getenv("MYSQLHOST");
		String dbPort = System.getenv("MYSQLPORT");
		String dbName = System.getenv("MYSQLDATABASE");
		String dbUser = System.getenv("MYSQLUSER");
		String dbPass = System.getenv("MYSQLPASSWORD");

		if (dbHost != null && dbPort != null && dbName != null) {
			URL = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName;
			USERNAME = dbUser != null ? dbUser : "root";
			PASSWORD = dbPass != null ? dbPass : "";
		} else {
			// Local fallback
			URL = "jdbc:mysql://localhost:3306/dao_project";
			USERNAME = "root";
			PASSWORD = "root";
		}
	}
	
	public static Connection getConnection(){
		
		try {
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			con = DriverManager.getConnection(URL,USERNAME, PASSWORD);
//			System.out.println("Connection established");
			
		} 
		catch (ClassNotFoundException e) {
			e.printStackTrace();
		} 
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return con;
	}

}
