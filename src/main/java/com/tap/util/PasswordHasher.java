package com.tap.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordHasher {

    // Hash a plain-text password using BCrypt
    public static String hash(String password) {
        if (password == null) {
            return null;
        }
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    // Verify a plain-text password against a hashed password (supporting plain-text fallback)
    public static boolean check(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        // If the stored password matches BCrypt format ($2a$, $2y$, $2b$), use BCrypt
        if (hashedPassword.startsWith("$2a$") || hashedPassword.startsWith("$2y$") || hashedPassword.startsWith("$2b$")) {
            try {
                return BCrypt.checkpw(plainPassword, hashedPassword);
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
        // Fallback for plain-text password comparison
        return plainPassword.equals(hashedPassword);
    }
}
