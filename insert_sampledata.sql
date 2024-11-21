-- Insert Data into PricingScheme
INSERT INTO PricingScheme (pricing_id, lesson_type, skill_level_type, price, valid_from)
VALUES
    ('P001', 'Individual', 'Beginner', 500.00, '2024-11-21'),
    ('P002', 'Individual', 'Intermediate', 600.00, '2024-11-21'),
    ('P003', 'Individual', 'Advanced', 700.00, '2024-11-21'),
    ('P004', 'Group', 'Beginner', 400.00, '2024-11-21'),
    ('P005', 'Group', 'Intermediate', 500.00, '2024-11-21'),
    ('P006', 'Group', 'Advanced', 600.00, '2024-11-21'),
    ('P007', 'Ensemble', 'Beginner', 300.00, '2024-11-21'),
    ('P008', 'Ensemble', 'Intermediate', 400.00, '2024-11-21'),
    ('P009', 'Ensemble', 'Advanced', 500.00, '2024-11-21');

-- Insert Data into Instructor
INSERT INTO Instructor (name, salary, canTeachEnsemble, personal_identity_number, phone_number, email, zip, city, street)
VALUES
('Emma Larsson', 45000.00, TRUE, '19900101-1234', '0701234567', 'emma.larsson@example.com', '11122', 'Stockholm', 'Sergels Torg 1'),
('Lars Svensson', 40000.00, FALSE, '19851212-5678', '0734567890', 'lars.svensson@example.com', '22233', 'Gothenburg', 'Kungsportsavenyen 10');

-- Insert Data into Instrument
INSERT INTO Instrument (instrument_number, instrument_type, instrument_brand, is_available)
VALUES
('I001', 'Piano', 'Yamaha', TRUE),
('I002', 'Guitar', 'Fender', TRUE),
('I003', 'Violin', 'Stradivarius', FALSE),
('I004', 'Flute', 'Pearl', TRUE);

-- Insert Data into Lesson
INSERT INTO Lesson (lesson_number, room_id, capacity, time, date, instructor_id, pricing_scheme_id)
VALUES
('L001', 101, 10, '2024-12-01 10:00:00', '2024-12-01',
    (SELECT instructor_id FROM Instructor WHERE name = 'Emma Larsson'),
    (SELECT pricing_scheme_id FROM PricingScheme WHERE pricing_id = 'P001')),
('L002', 102, 15, '2024-12-02 11:00:00', '2024-12-02',
    (SELECT instructor_id FROM Instructor WHERE name = 'Lars Svensson'),
    (SELECT pricing_scheme_id FROM PricingScheme WHERE pricing_id = 'P004'));

-- Insert Data into IndividualLesson
INSERT INTO IndividualLesson (lesson_id, instrument_type, skill_level)
VALUES
((SELECT lesson_id FROM Lesson WHERE lesson_number = 'L001'), 'Piano', 'Beginner');

-- Insert Data into GroupLesson
INSERT INTO GroupLesson (lesson_id, instrument_type, min_amount_students, max_amount_students, skill_level)
VALUES
((SELECT lesson_id FROM Lesson WHERE lesson_number = 'L002'), 'Guitar', 5, 15, 'Beginner');

-- Insert Data into Student
INSERT INTO Student (student_number, name, phone_number, email, personal_identity_number, zip, city, street, total_discount, rental_quota, number_of_lessons_taken)
VALUES
('S001', 'Erik Johansson', '0723456789', 'erik.johansson@example.com', '20000101-1111', '12345', 'Malmö', 'Storgatan 5', 0.00, 2, 5),
('S002', 'Sara Karlsson', '0765432109', 'sara.karlsson@example.com', '20020505-2222', '67890', 'Uppsala', 'Linnégatan 3', 10.00, 2, 8);

-- Insert Data into Student_Lesson
INSERT INTO Student_Lesson (student_id, lesson_id, enrollment_date)
VALUES
((SELECT student_id FROM Student WHERE student_number = 'S001'),
 (SELECT lesson_id FROM Lesson WHERE lesson_number = 'L001'),
 '2024-12-01 09:00:00'),

((SELECT student_id FROM Student WHERE student_number = 'S002'),
 (SELECT lesson_id FROM Lesson WHERE lesson_number = 'L002'),
 '2024-12-02 10:00:00');

-- Insert Data into Instructor_Instruments
INSERT INTO Instructor_Instruments (instructor_id, instrument_id)
VALUES
((SELECT instructor_id FROM Instructor WHERE name = 'Emma Larsson'),
 (SELECT instrument_id FROM Instrument WHERE instrument_number = 'I001')),
((SELECT instructor_id FROM Instructor WHERE name = 'Lars Svensson'),
 (SELECT instrument_id FROM Instrument WHERE instrument_number = 'I002'));

-- Insert Data into Instrument_Rental
INSERT INTO Instrument_Rental (student_id, instrument_id, start_date, end_date, rental_price)
VALUES
((SELECT student_id FROM Student WHERE student_number = 'S001'),
 (SELECT instrument_id FROM Instrument WHERE instrument_number = 'I003'),
 '2024-11-01', '2024-11-30', 300.00);

-- Insert Data into Is_Sibling_Of
INSERT INTO Is_Sibling_Of (student_id_1, student_id_2)
VALUES
((SELECT student_id FROM Student WHERE student_number = 'S001'),
 (SELECT student_id FROM Student WHERE student_number = 'S002'));

-- Insert Data into Available_Time_Slots
INSERT INTO Available_Time_Slots (start_time, end_time)
VALUES
('2024-12-01 08:00:00', '2024-12-01 09:00:00'),
('2024-12-02 09:00:00', '2024-12-02 10:00:00');

-- Insert Data into Instructor_TimeSlot
INSERT INTO Instructor_TimeSlot (instructor_id, timeslot_id)
VALUES
((SELECT instructor_id FROM Instructor WHERE name = 'Emma Larsson'),
 (SELECT timeslot_id FROM Available_Time_Slots WHERE start_time = '2024-12-01 08:00:00'));
