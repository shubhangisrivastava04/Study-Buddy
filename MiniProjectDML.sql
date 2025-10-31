USE study_buddy;

INSERT INTO Users (first_name, last_name, email, password_hash, institution)
VALUES
('Siri', 'Basavaraj', 'siri@example.com', 'sirib', 'PES University'),
('Shubhangi', 'Srivastava', 'shubhangi@example.com', 'shubhs', 'PES University'),
('Shuchika', 'Joy', 'shuchika@example.com', 'shuchj', 'Christ University'),
('Sinchana', 'Rathnakar', 'sinchana@example.com', 'sincr', 'MIT Manipal'),
('Deeksha', 'Bhaskar', 'deeksha@example.com', 'deeb', 'RV University');

INSERT INTO Goal (user_id, goal_title, description, target_date, status)
VALUES
(1, 'Complete AC Revision', 'Revise all major AC topics before the final exam.', '2025-11-05', 'in progress'),
(2, 'Finish Flutter UI', 'Complete Figma to Flutter conversion for app.', '2025-10-25', 'not started'),
(3, 'Read DBMS Textbook', 'Read and summarize first 5 chapters of DBMS Textbook.', '2025-11-10', 'in progress'),
(4, 'Work on ML Course', 'Finish 25 lectures from ML course', '2025-10-28', 'completed'),
(5, 'Practice Leetcode', 'Finish 50 questions on LeetCode.', '2025-11-02', 'in progress');

INSERT INTO Goal_Category (goal_id, category_name)
VALUES
(1, 'Applied Cryptography'),
(1, 'Concept Review'),

(2, 'App Development'),
(2, 'Design'),

(3, 'DBMS'),

(4, 'Machine Learning'),
(4, 'Coursework'),

(5, 'Problem Solving'),
(5, 'Coding');

INSERT INTO Study_Session (user_id, goal_id, start_time, end_time, focus_level)
VALUES
(1, 1, '2025-10-18 07:30:00', '2025-10-18 09:00:00', 9),
(2, 2, '2025-10-18 19:00:00', '2025-10-18 20:15:00', 8),
(3, 3, '2025-10-17 21:00:00', '2025-10-17 22:30:00', 7),
(4, 4, '2025-10-18 15:00:00', '2025-10-18 16:45:00', 10),
(5, 5, '2025-10-16 10:00:00', '2025-10-16 11:00:00', 6);

INSERT INTO Achievement (user_id, achievement_name, description)
VALUES
(1, 'AC Mastery', 'Completed AC revision successfully.'),
(2, 'UI Beginner', 'Created first Flutter screen from Figma prototype.'),
(3, 'DBMS Enthusiast', 'Finished summarizing first 5 chapters.'),
(4, 'ML Progress', 'Completed 25 lectures from ML course.'),
(5, 'Leetcode Solver', 'Solved 50 Leetcode questions.');

INSERT INTO Friendship (user_id_1, user_id_2, status)
VALUES
(1, 2, 'accepted'),
(2, 3, 'accepted'),
(3, 4, 'pending'),
(4, 5, 'accepted'),
(1, 5, 'accepted');
