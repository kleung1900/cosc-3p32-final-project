CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Name VARCHAR(255),
    Phone VARCHAR(20),
    Email VARCHAR(255),
    Location VARCHAR(255),
    Bio TEXT,
    AvailabilityStatus BOOLEAN,
    UserName VARCHAR(255) UNIQUE,
    UserStatus VARCHAR(50),
    TempStatusMsg VARCHAR(255)
);

CREATE TABLE Friends (
    UserID INT,
    FriendID INT,
    isFavs BOOLEAN,
    PRIMARY KEY (UserID, FriendID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (FriendID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE GroupChat (
    GroupID INT PRIMARY KEY,
    GroupName VARCHAR(255)
);

CREATE TABLE GroupMembers (
    GroupID INT,
    UserID INT,
    PRIMARY KEY (GroupID, UserID),
    FOREIGN KEY (GroupID) REFERENCES GroupChat(GroupID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE Messages (
    MsgID INT PRIMARY KEY,
    UserID INT,
    generationTime TIMESTAMP,
    Text TEXT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE GroupMessages (
    GroupID INT,
    MsgID INT,
    PRIMARY KEY (GroupID, MsgID),
    FOREIGN KEY (GroupID) REFERENCES GroupChat(GroupID),
    FOREIGN KEY (MsgID) REFERENCES Messages(MsgID)
);

CREATE TABLE Channels (
    ChannelID INT PRIMARY KEY,
    ChannelName VARCHAR(255)
);

CREATE TABLE ChannelMemebers (
	MemberID  INT,
	ChannelID INT,
	MemberRole INT,
    PRIMARY KEY (ChannelID,MemberID),
	FOREIGN KEY (ChannelID) REFERENCES Channels(ChannelID),
	FOREIGN KEY (MemberID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (MemberRole) REFERENCES ChannelRoleTypes(RoleTypeID)
);
CREATE TABLE ChannelRoleTypes(
	RoleTypeID INT PRIMARY KEY,
	RoleTypeName VARCHAR(100) NOT NULL
	canPost BOOLEAN,
	canKick BOOLEAN,
	canAssignRole BOOLEAN
);


CREATE TABLE Posts (
    PostID INT PRIMARY KEY,
    Text TEXT,
    PosteTimestamp TIMESTAMP,
    Counter INT
);

CREATE TABLE ChannelPosts (
    PostID INT,
    ChannelID INT,
    UserID INT,
    PRIMARY KEY (PostID, ChannelID, UserID),
    FOREIGN KEY (PostID) REFERENCES Posts(PostID),
    FOREIGN KEY (ChannelID) REFERENCES Channels(ChannelID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE PostReactions (
    PostReactionID INT PRIMARY KEY,
    ReactionName VARCHAR(255)
);

CREATE TABLE ReactionsToPosts (
    PostID INT,
    PostReactionID INT,
    UserID INT,
    PRIMARY KEY (PostID, PostReactionID, UserID),
    FOREIGN KEY (PostID) REFERENCES Posts(PostID),
    FOREIGN KEY (PostReactionID) REFERENCES PostReactions(PostReactionID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE MessageStatusTypes (
    MsgStatusID INT PRIMARY KEY,
    MsgStatusType VARCHAR(50)
);

CREATE TABLE MessagePostStatus (
    MsgID INT,
    MsgStatusID INT,
    UserID INT,
    isread BOOLEAN,
    PRIMARY KEY (MsgID, MsgStatusID, UserID),
    FOREIGN KEY (MsgID) REFERENCES Messages(MsgID),
    FOREIGN KEY (MsgStatusID) REFERENCES MessageStatusTypes(MsgStatusID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE PostStatusTypes (
    PostStatusID INT PRIMARY KEY,
    PostStatusType VARCHAR(50)
);

CREATE TABLE ChannelPostStatus (
    PostID INT,
    PostStatusID INT,
    UserID INT,
    Count INT,
    PRIMARY KEY (PostID, PostStatusID, UserID),
    FOREIGN KEY (PostID) REFERENCES Posts(PostID),
    FOREIGN KEY (PostStatusID) REFERENCES PostStatusTypes(PostStatusID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE MessageReactions (
    MsgReactionID INT PRIMARY KEY,
    ReactionName VARCHAR(255)
);

CREATE TABLE ReactionsToMessage (
    MsgID INT,
    MsgReactionID INT,
    UserID INT,
    PRIMARY KEY (MsgID, MsgReactionID, UserID),
    FOREIGN KEY (MsgID) REFERENCES Messages(MsgID),
    FOREIGN KEY (MsgReactionID) REFERENCES MessageReactions(MsgReactionID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE MessageReply (
    MsgID INT,
    ReplyMsgID INT,
    PRIMARY KEY (MsgID, ReplyMsgID),
    FOREIGN KEY (MsgID) REFERENCES Messages(MsgID),
    FOREIGN KEY (ReplyMsgID) REFERENCES Messages(MsgID)
);

-- Insert test Users
INSERT INTO Users VALUES (5443270,'Kevin Leung', '','kl13hn@brocku.ca','','',TRUE,'kl13hn','','');
INSERT INTO Users VALUES (5555555,'Test', '','test@brocku.ca','','',TRUE,'tester','','');
INSERT INTO Users VALUES (2222222,'Test', '','test2@brocku.ca','','',TRUE,'tester2','','');
-- Insert test Channels
INSERT INTO Channels VALUES (1,'Test Channel');

-- Insert Test ChannelRoleTypes
INSERT INTO ChannelRoleTypes VALUES (1,'Owner',TRUE,TRUE,TRUE);
INSERT INTO ChannelRoleTypes VALUES (2,'Member',False,False,False);
INSERT INTO ChannelRoleTypes VALUES (3,'Mod',TRUE,False,False);
INSERT INTO ChannelRoleTypes VALUES (4,'Admin',TRUE,TRUE,False);

--Insert Test ChannelMembers
INSERT INTO ChannelMembers VALUES (1,5443270,1);
INSERT INTO ChannelMembers VALUES (1,5555555,2);
INSERT INTO ChannelMembers VALUES (1,2222222,3);

-- a. Retrieve the list of all users.
SELECT * FROM Users;

-- b. Retrieve the list of all online users.
SELECT * FROM Users WHERE AvailabilityStatus = TRUE;

-- c. Given a user (by phone number or unique ID or username), retrieve all information of the user.
-- By phone number
SELECT * FROM Users WHERE Phone = '6477787345';
-- By UserID
SELECT * FROM Users WHERE UserID = hamzawaheed;
-- By username
SELECT * FROM Users WHERE UserName = 'hamzawaheed';

-- d. Given a user (by phone number, unique ID, or username) retrieve all his/her chats (private chats, normal groups and channels).
-- Groups and Channels for a user by UserID
SELECT GroupID, GroupName FROM GroupChat
JOIN GroupMembers ON GroupChat.GroupID = GroupMembers.GroupID
WHERE UserID = hamzawaheed;
SELECT ChannelID, ChannelName FROM Channels
JOIN ChannelMembers ON Channels.ChannelID = ChannelMembers.ChannelID
WHERE UserID = hamzawaheed;

-- e. For a given chat, retrieve its metadata (chat title, bio, join link if applicable, etc.)
-- For a group
SELECT GroupName FROM GroupChat WHERE GroupID = 3p32project;
-- For a channel
SELECT ChannelName FROM Channels WHERE ChannelID = 3p32channel;

-- f. For a given chat, retrieve all its users.
-- Users in a group chat
SELECT Users.UserID, Users.Name FROM Users
JOIN GroupMembers ON Users.UserID = GroupMembers.UserID
WHERE GroupID = 3p32project;
-- Users in a channel
SELECT Users.UserID, Users.Name FROM Users
JOIN ChannelMembers ON Users.UserID = ChannelMembers.UserID
WHERE ChannelID = 3p32channel;

-- g. For a given chat, retrieve all its online users.
-- Online users in a group chat
SELECT Users.UserID, Users.Name FROM Users
JOIN GroupMembers ON Users.UserID = GroupMembers.UserID
WHERE GroupID = 3p32project AND Users.AvailabilityStatus = TRUE;
-- Online users in a channel
SELECT Users.UserID, Users.Name FROM Users
JOIN ChannelMembers ON Users.UserID = ChannelMembers.UserID
WHERE ChannelID = 3p32channel AND Users.AvailabilityStatus = TRUE;

-- h. For a Given chat, retrieve its creator
SELECT u.name
FROM Users u JOIN ChannelMembers c ON u.UserID = c.MemberID
WHERE u.MemberRole = 1;

-- i. For a given chat, retrieve all its admins (including the creator)
SELECT u.name
FROM Users u JOIN ChannelMembers c ON u.UserID = c.MemberID
WHERE u.MemberRole != 2;

--j. For a given chat admin, retrieve their permissions
SELECT u.name, cm.ChannelID, crt.canPost, crt.canKick, crt.canAssignRole
FROM Users u JOIN ChannelMembers cm ON u.UserID = cm.MemberID
JOIN ChannelRoleTypes crt ON cm.MemberRole = crt.RoleTypeiD


