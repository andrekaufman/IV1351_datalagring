package se.kth.soundgood.model;

import java.time.LocalDate;

public class Rental {
    private int id;
    private int instrumentId;
    private int studentId;
    private double price;
    private LocalDate startDate;
    private LocalDate endDate;

    public Rental(int id, int instrumentId, int studentId, double price, LocalDate startDate, LocalDate endDate) {
        this.id = id;
        this.instrumentId = instrumentId;
        this.studentId = studentId;
        this.price = price;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public int getId() {
        return id;
    }

    public int getInstrumentId() {
        return instrumentId;
    }

    public int getStudentId() {
        return studentId;
    }

    public double getPrice() {
        return price;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    @Override
    public String toString() {
        return "Rental ID: " + id + ", Instrument ID: " + instrumentId + 
               ", Student ID: " + studentId + ", Price: " + price + 
               ", Start Date: " + startDate + ", End Date: " + (endDate == null ? "Ongoing" : endDate);
    }
}
