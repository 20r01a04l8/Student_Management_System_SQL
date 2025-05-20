CREATE TABLE students (
    student_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    subject1 NUMBER CHECK (subject1 BETWEEN 0 AND 100),
    subject2 NUMBER CHECK (subject2 BETWEEN 0 AND 100),
    subject3 NUMBER CHECK (subject3 BETWEEN 0 AND 100)
);
CREATE OR REPLACE PROCEDURE add_student (
    p_id IN NUMBER,
    p_name IN VARCHAR2,
    p_sub1 IN NUMBER,
    p_sub2 IN NUMBER,
    p_sub3 IN NUMBER
) IS
BEGIN
    INSERT INTO students VALUES (p_id, p_name, p_sub1, p_sub2, p_sub3);
    DBMS_OUTPUT.PUT_LINE('Student added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
CREATE OR REPLACE PROCEDURE update_student (
    p_id IN NUMBER,
    p_sub1 IN NUMBER,
    p_sub2 IN NUMBER,
    p_sub3 IN NUMBER
) IS
BEGIN
    UPDATE students
    SET subject1 = p_sub1,
        subject2 = p_sub2,
        subject3 = p_sub3
    WHERE student_id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No such student found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Student updated successfully.');
    END IF;
END;
CREATE OR REPLACE PROCEDURE delete_student (
    p_id IN NUMBER
) IS
BEGIN
    DELETE FROM students WHERE student_id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No such student found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Student deleted successfully.');
    END IF;
END;
CREATE OR REPLACE FUNCTION calculate_gpa (
    p_id IN NUMBER
) RETURN NUMBER IS
    v_avg NUMBER;
BEGIN
    SELECT (subject1 + subject2 + subject3)/3 INTO v_avg
    FROM students
    WHERE student_id = p_id;

    RETURN ROUND(v_avg/25, 2); -- GPA out of 4
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student not found.');
        RETURN NULL;
END;
CREATE OR REPLACE TRIGGER trg_validate_marks
BEFORE INSERT OR UPDATE ON students
FOR EACH ROW
BEGIN
    IF :NEW.subject1 < 0 OR :NEW.subject2 < 0 OR :NEW.subject3 < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Marks cannot be negative.');
    END IF;
END;


BEGIN
    add_student(101, 'Alice', 85, 78, 92);
    add_student(102, 'Bob', 74, 88, 90);
    add_student(103, 'Charlie', 67, 71, 79);
    add_student(104, 'Diana', 95, 89, 94);
    add_student(105, 'Ethan', 56, 63, 60);
    add_student(106, 'Fatima', 91, 87, 90);
    add_student(107, 'George', 80, 70, 85);
    add_student(108, 'Hannah', 68, 73, 77);
    add_student(109, 'Ibrahim', 82, 76, 88);
    add_student(110, 'Julia', 90, 93, 95);
END;
/

BEGIN
    update_student(101, 88, 90, 93); -- Updates Alice
    update_student(103, 70, 75, 80); -- Updates Charlie
END;
/

BEGIN 
    DELETE_STUDENT(1);
END;
/

SELECT * FROM students WHERE student_id IN (101, 103);


SELECT * FROM students;

Drop table students;