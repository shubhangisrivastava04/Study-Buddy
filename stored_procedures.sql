DELIMITER //
-- PROCEDURE 1: LogGoalCompletion
-- Marks a specific goal as 'completed' and automatically creates a corresponding achievement record for the user.
CREATE PROCEDURE LogGoalCompletion(
    IN p_user_id INT,
    IN p_goal_id INT
)
BEGIN
    DECLARE v_goal_title VARCHAR(100);

    -- 1. Get the goal title before updating
    SELECT goal_title INTO v_goal_title
    FROM Goal
    WHERE goal_id = p_goal_id AND user_id = p_user_id;

    -- Check if the goal exists and belongs to the user
    IF v_goal_title IS NOT NULL THEN
        -- 2. Update the Goal status
        UPDATE Goal
        SET status = 'completed'
        WHERE goal_id = p_goal_id;

        -- 3. Insert the Achievement record
        INSERT INTO Achievement (user_id, achievement_name, description)
        VALUES (p_user_id, CONCAT(v_goal_title), CONCAT(v_goal_title));

        SELECT 'Goal marked as completed and achievement granted.' AS Message;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Goal not found or does not belong to the specified user.';
    END IF;
END //

-- PROCEDURE 2: ManageFriendship
-- Manages the status of a friendship between two users by handling the canonical ID order internally.
CREATE PROCEDURE ManageFriendship(
    IN p_user_id_a INT,
    IN p_user_id_b INT,
    IN p_new_status ENUM('pending', 'accepted', 'blocked')
)
BEGIN
    DECLARE v_user_1 INT;
    DECLARE v_user_2 INT;

    -- Standardize the user IDs (smaller first)
    IF p_user_id_a < p_user_id_b THEN
        SET v_user_1 = p_user_id_a;
        SET v_user_2 = p_user_id_b;
    ELSE
        SET v_user_1 = p_user_id_b;
        SET v_user_2 = p_user_id_a;
    END IF;

    -- Update the status for the standardized pair
    UPDATE Friendship
    SET status = p_new_status
    WHERE user_id_1 = v_user_1
      AND user_id_2 = v_user_2;

    -- Inform the user
    IF ROW_COUNT() > 0 THEN
        SELECT CONCAT('Friendship status between User ', v_user_1, ' and User ', v_user_2, ' updated to: ', p_new_status) AS Message;
    ELSE
        SELECT 'Friendship record not found.' AS Message;
    END IF;
END //

DELIMITER ;