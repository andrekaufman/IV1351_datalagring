package se.kth.soundgood.integration;

import java.sql.*;

public class RentalDAO {
    private Connection connection;

    public RentalDAO() throws SQLException {
        connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/soundgooddb", "postgres", "postgres");
        connection.setAutoCommit(false);
    }

    /**
     * Retrieves active rentals for a student.
     *
     * @param studentId The ID of the student
     * @return A ResultSet containing the active rentals for the student
     * @throws SQLException If a database access error occurs
     */
    public ResultSet lockActiveRentalsByStudent(int studentId) throws SQLException {
        String query = "SELECT * FROM instrument_rental WHERE student_id = ? AND end_date IS NULL FOR UPDATE";
        PreparedStatement stmt = connection.prepareStatement(query);
        stmt.setInt(1, studentId);
        return stmt.executeQuery();
    }

    /**
     * Retrieves active rentals for an instrument.
     *
     * @param instrumentId The instrument ID
     * @return A ResultSet containing the active rental for the instrument (if it exists)
     * @throws SQLException If a database access error occurs
     */
    public ResultSet lockActiveRentalByInstrument(int instrumentId) throws SQLException {
        String query = "SELECT * FROM instrument_rental WHERE instrument_id = ? AND end_date IS NULL FOR UPDATE";
        PreparedStatement stmt = connection.prepareStatement(query);
        stmt.setInt(1, instrumentId);
        return stmt.executeQuery();
    }

    /**
     * Inserts a new rental record for the specified student and instrument
     *
     * @param studentId Student ID of the one that's renting the instrument
     * @param instrumentId Instrument ID of specified instrument
     * @throws SQLException If a database access error occurs
     */
    public void insertRental(int studentId, int instrumentId) throws SQLException {
        String query = "INSERT INTO instrument_rental (student_id, instrument_id, start_date) VALUES (?, ?, CURRENT_DATE)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, instrumentId);
            stmt.executeUpdate();
            connection.commit();
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        }
    }

    /**
     * Ends an active rental by setting the end date to the current date
     *
     * @param studentId ID of the student returning the instrument.
     * @param instrumentId ID of the instrument being returned.
     * @throws SQLException If no active rental is found or a database access error occurs.
     */
    public void endRental(int studentId, int instrumentId) throws SQLException {
        String query = "UPDATE instrument_rental SET end_date = CURRENT_DATE WHERE student_id = ? AND instrument_id = ? AND end_date IS NULL";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, instrumentId);
            int rowsUpdated = stmt.executeUpdate();
    
            if (rowsUpdated == 0) {
                throw new SQLException("No active rental found for the given student and instrument.");
            }
    
            connection.commit();
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        }
    }
}
