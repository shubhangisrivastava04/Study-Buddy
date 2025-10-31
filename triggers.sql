DELIMITER //
-- TRIGGER 1: Ensure canonical order for Friendship entries
-- This trigger runs BEFORE inserting a new row into Friendship.
-- It ensures that user_id_1 is always less than user_id_2.
-- This prevents duplicate entries.

CREATE TRIGGER before_new_friendship_insert
BEFORE INSERT ON Friendship
FOR EACH ROW
BEGIN
    -- Check if the users are trying to friend themselves (already checked by table constraint, but good for defense)
    IF NEW.user_id_1 = NEW.user_id_2 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Users cannot befriend themselves.';
    END IF;

    -- Standardize the pair: smaller ID goes into user_id_1
    IF NEW.user_id_1 > NEW.user_id_2 THEN
        -- Swap the IDs
        SET @temp_user_id = NEW.user_id_1;
        SET NEW.user_id_1 = NEW.user_id_2;
        SET NEW.user_id_2 = @temp_user_id;
    END IF;
END //

-- TRIGGER 2: Prevents overlapping study sessions for the same user
-- This trigger runs BEFORE inserting a new row into Study_Session.
-- It ensures that it doesn't overlap with any existing study sessions.

CREATE TRIGGER trg_prevent_overlap
BEFORE INSERT ON Study_Session
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Study_Session
        WHERE user_id = NEW.user_id
        AND (
            (NEW.start_time BETWEEN start_time AND end_time)
            OR (NEW.end_time BETWEEN start_time AND end_time)
            OR (start_time BETWEEN NEW.start_time AND NEW.end_time)
        )
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Overlapping study sessions are not allowed.';
    END IF;
END //

DELIMITER ;