CREATE DATABASE todo_list_db;

USE todo_list_db;

CREATE TABLE Tasks (
    TaskID INT AUTO_INCREMENT PRIMARY KEY,
    TaskDescription VARCHAR(255) NOT NULL,
    DueDate DATE,
    Status VARCHAR(50) DEFAULT 'To Do'
);

INSERT INTO Tasks (TaskDescription, DueDate) VALUES ('Buy groceries', '2025-05-16');
INSERT INTO Tasks (TaskDescription, DueDate, Status) VALUES ('Finish MySQL project proposal', '2025-05-18', 'In Progress');
INSERT INTO Tasks (TaskDescription) VALUES ('Call the doctor');
INSERT INTO Tasks (TaskDescription, Status) VALUES ('Read a chapter of the book', 'Completed');

SELECT * FROM Tasks;

-- Filtering
SELECT * FROM Tasks WHERE Status = 'To Do';
SELECT * FROM Tasks WHERE DueDate = '2025-05-16';

-- Updating
UPDATE Tasks SET Status = 'Completed' WHERE TaskDescription = 'Buy groceries';
UPDATE Tasks SET DueDate = '2025-05-19' WHERE TaskID = 2;

-- Deleting
DELETE FROM Tasks WHERE TaskID = 4;
-- Be careful with this!
-- DELETE FROM Tasks; -- This would delete all rows!