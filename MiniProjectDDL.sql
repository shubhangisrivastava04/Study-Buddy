CREATE TABLE Users (
    user_id         INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    password_hash   VARCHAR(255) NOT NULL,
    join_date       DATETIME DEFAULT CURRENT_TIMESTAMP,
    institution     VARCHAR(100)
);

CREATE TABLE Goal (
    goal_id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    goal_title      VARCHAR(100) NOT NULL,
    description     TEXT,
    target_date     DATE,
    status          ENUM('not started', 'in progress', 'completed') DEFAULT 'not started',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_goal_user
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE Goal_Category (
    goal_id         INT NOT NULL,
    category_name   VARCHAR(50) NOT NULL,
    PRIMARY KEY (goal_id, category_name),

    CONSTRAINT fk_category_goal
        FOREIGN KEY (goal_id) REFERENCES Goal(goal_id)
        ON DELETE CASCADE
);

CREATE TABLE Study_Session (
    session_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    goal_id         INT NULL,
    start_time      DATETIME NOT NULL,
    end_time        DATETIME NOT NULL,
    focus_level     INT CHECK (focus_level BETWEEN 1 AND 10),

    CONSTRAINT fk_session_user
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_session_goal
        FOREIGN KEY (goal_id) REFERENCES Goal(goal_id)
        ON DELETE SET NULL,

    CONSTRAINT chk_time_order CHECK (end_time > start_time)
);

CREATE TABLE Achievement (
    achievement_id  INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    achievement_name VARCHAR(100) NOT NULL,
    description     TEXT,
    earned_on       DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_achievement_user
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE Friendship (
    friendship_id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id_1       INT NOT NULL,
    user_id_2       INT NOT NULL,
    status          ENUM('pending', 'accepted', 'blocked') DEFAULT 'pending',
    created_on      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_friend_user1
        FOREIGN KEY (user_id_1) REFERENCES Users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_friend_user2
        FOREIGN KEY (user_id_2) REFERENCES Users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT uq_friend_pair UNIQUE (user_id_1, user_id_2),
    CONSTRAINT chk_no_self_friend CHECK (user_id_1 <> user_id_2)
);

CREATE OR REPLACE VIEW Session_Duration AS
SELECT 
    session_id,
    user_id,
    goal_id,
    TIMESTAMPDIFF(MINUTE, start_time, end_time) AS duration_minutes
FROM Study_Session;