CREATE TABLE Bus(
    BusId INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(128),
    LicensePlate VARCHAR(16) NOT NULL,
    Deleted BIT NOT NULL DEFAULT 0
);

CREATE TABLE Seat(
    SeatId INT AUTO_INCREMENT PRIMARY KEY,
    BusId INT NOT NULL,
    Price INT NOT NULL DEFAULT 0,
    Deleted BIT NOT NULL DEFAULT 0,
    Name VARCHAR(128) NOT NULL,
    FOREIGN KEY (BusId) REFERENCES Bus(BusId)
);


INSERT INTO Bus(Name, LicensePlate, Deleted) VALUES ('Sdasad', '41A23435', 0)

INSERT INTO Bus(BusId, Name, LicensePlate, Deleted) VALUES (1, 'Sdasad', '41A23435', 0),
(2, 'Sdasad', '43278322', 0),
(3, 'Sdasad', '23434322', 0),
(4, 'Sdasad', '23423234', 0),
(5, 'Sdasad', '23423423', 0),
(7, 'Sdasad', '34534532', 0),
(10, 'Sdasad', '34534534', 0),
(11, 'Sdasad', '23425464', 0),
(12, 'Sdasad', '34657432', 0),
(13, 'Sdasad', '43543434', 0),
(14, 'From the nam', '47A82783', 0);

INSERT INTO Seat(SeatId, BusId, Price, Deleted, Name) 
VALUES
(21, 1, 250000, 0, 'A1'),
(22, 1, 250000, 0, 'A2'),
(23, 1, 250000, 0, 'A3'),
(24, 1, 250000, 0, 'A4'),
(25, 1, 450000, 0, 'A5'),
(26, 1, 250000, 0, 'A6'),
(27, 1, 250000, 0, 'A7'),
(28, 1, 250000, 0, 'A8'),
(29, 1, 250000, 0, 'A9'),
(30, 1, 250000, 0, 'A10'),
(31, 1, 250000, 0, 'A11'),
(32, 2, 26000, 0, 'A11'),
(33, 2, 250000, 0, 'A11'),
(34, 2, 250000, 0, 'A11'),
(35, 2, 250000, 0, 'A11'),
(36, 2, 250000, 0, 'A11'),
(37, 2, 250000, 0, 'A11'),
(38, 2, 250000, 0, 'A11'),
(39, 2, 250000, 0, 'A11'),
(40, 2, 250000, 0, 'A11'),
(41, 2, 250000, 0, 'A11'),
(42, 3, 250000, 0, 'A11'),
(43, 3, 250000, 0, 'A11'),
(44, 3, 250000, 0, 'A11'),
(45, 3, 250000, 0, 'A11'),
(46, 3, 250000, 0, 'A11'),
(47, 3, 250000, 0, 'A11'),
(48, 3, 250000, 0, 'A11'),
(49, 3, 250000, 0, 'A11'),
(50, 3, 250000, 0, 'A11'),
(51, 3, 250000, 0, 'A11'),
(52, 3, 250000, 0, 'A11'),
(53, 3, 250000, 0, 'A11'),
(54, 3, 250000, 0, 'A11'),
(55, 3, 250000, 0, 'A11'),
(56, 4, 26000, 0, 'A11'),
(57, 4, 26000, 0, 'A11'),
(58, 4, 26000, 0, 'A11'),
(59, 4, 26000, 0, 'A11'),
(60, 4, 26000, 0, 'A11'),
(61, 4, 26000, 0, 'A11'),
(62, 4, 26000, 0, 'A11');
