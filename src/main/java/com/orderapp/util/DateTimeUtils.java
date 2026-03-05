package com.orderapp.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Utility class for formatting dates in JSP
 */
public class DateTimeUtils {
    
    private static final DateTimeFormatter DEFAULT_FORMATTER = 
        DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    
    /**
     * Format a LocalDateTime for display in JSP
     * @param dateTime the LocalDateTime to format
     * @return formatted string or empty string if null
     */
    public static String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(DEFAULT_FORMATTER);
    }
    
    /**
     * Format a LocalDateTime with a custom pattern
     * @param dateTime the LocalDateTime to format
     * @param pattern the pattern to use
     * @return formatted string or empty string if null
     */
    public static String formatDateTime(LocalDateTime dateTime, String pattern) {
        if (dateTime == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
        return dateTime.format(formatter);
    }
}
