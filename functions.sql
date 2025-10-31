DELIMITER //
-- FUNCTION 1: GetTotalStudyTimeMinutes
-- Calculates the total accumulated study time in minutes for a given user.
CREATE FUNCTION GetTotalStudyTimeMinutes(p_user_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_minutes INT DEFAULT 0;

    SELECT COALESCE(SUM(duration_minutes), 0)
    INTO total_minutes
    FROM Session_Duration
    WHERE user_id = p_user_id;

    RETURN total_minutes;
END //

-- FUNCTION 2: GetUserFriendCount
-- Returns the count of ACCEPTED friends for a specific user.
CREATE FUNCTION GetUserFriendCount(p_user_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE friend_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO friend_count
    FROM Friendship
    WHERE status = 'accepted'
      AND (user_id_1 = p_user_id OR user_id_2 = p_user_id);

    RETURN friend_count;
END //

DELIMITER ;
