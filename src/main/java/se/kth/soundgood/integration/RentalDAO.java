package se.kth.soundgood.integration;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RentalDAO {
    private final Connection connection;

    public RentalDAO(Connection connection) {
        this.connection = connection;
    }

public int readActiveRentalCountForStudent(int studentId) throws SQLException {
    String query = "SELECT instrument_id FROM instrument_rental WHERE student_id = ? AND end_date IS NULL FOR UPDATE";
    try (PreparedStatement stmt = connection.prepareStatement(query)) { //try blocks in DAO classes = no need for close(), finally..
        stmt.setInt(1, studentId);
        ResultSet rs = stmt.executeQuery();

        int rentalCount = 0;
        while (rs.next()) {
            rentalCount++;
        }
        return rentalCount;
    }
}

    public List<Integer> readActiveRentalsByStudent(int studentId) throws SQLException {
        String query = "SELECT instrument_id FROM instrument_rental WHERE student_id = ? AND end_date IS NULL";
        List<Integer> rentals = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                rentals.add(rs.getInt("instrument_id"));
            }
        }
        return rentals;
    }

    public boolean readInstrumentRentalStatus(int instrumentId) throws SQLException {
        String query = "SELECT 1 FROM instrument_rental WHERE instrument_id = ? AND end_date IS NULL";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, instrumentId);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); //will be true if the instrument is currently rented
        }
    }

    public void createRental(int studentId, int instrumentId) throws SQLException {
        String query = "INSERT INTO instrument_rental (student_id, instrument_id, start_date) VALUES (?, ?, CURRENT_DATE)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) { 
            stmt.setInt(1, studentId);
            stmt.setInt(2, instrumentId);
            stmt.executeUpdate();
        }
    }

    public int updateRentalEnd(int studentId, int instrumentId) throws SQLException {
        String query = "UPDATE instrument_rental SET end_date = CURRENT_DATE WHERE student_id = ? AND instrument_id = ? AND end_date IS NULL";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, instrumentId);
            return stmt.executeUpdate();
        }
    }
}
