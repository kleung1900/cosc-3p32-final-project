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
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (FriendID) REFERENCES Users(UserID)
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
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Messages (
    MsgID INT PRIMARY KEY,
    UserID INT,
    generationTime TIMESTAMP,
    Text TEXT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
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

CREATE TABLE ChannelMembers (
    MemberID INT PRIMARY KEY,
    ChannelID INT,
    UserID INT,
    isAdmin BOOLEAN,
    FOREIGN KEY (ChannelID) REFERENCES Channels(ChannelID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
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
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
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
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
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


