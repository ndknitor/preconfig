-- On database proxy
CREATE TABLE Bus (
    BusId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(128) DEFAULT NULL DEFAULT '',
    LicensePlate VARCHAR(16) NOT NULL DEFAULT '',
    Deleted BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (BusId)
)
ENGINE=FEDERATED
DEFAULT CHARSET=utf8mb4
CONNECTION='mysql://<username>:<password>@<server-ip>:3306/<database>/<table>';

-- On host table
CREATE TABLE Seat (
    SeatId INT NOT NULL AUTO_INCREMENT,
    BusId INT NOT NULL,
    Price INT NOT NULL DEFAULT 0,
    Deleted BIT NOT NULL DEFAULT 0,
    Name VARCHAR(128) NOT NULL,
    PRIMARY KEY (SeatId),
    FOREIGN KEY (BusId) REFERENCES Bus(BusId)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;
