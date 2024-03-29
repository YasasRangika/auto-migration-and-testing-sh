ALTER TABLE AM_SUBSCRIPTION_KEY_MAPPING MODIFY ACCESS_TOKEN VARCHAR(512);
ALTER TABLE AM_APPLICATION_REGISTRATION MODIFY TOKEN_SCOPE VARCHAR(1500);
ALTER TABLE AM_APPLICATION ADD TOKEN_TYPE VARCHAR(10);
ALTER TABLE AM_API_SCOPES ADD PRIMARY KEY (API_ID, SCOPE_ID);
DELETE FROM AM_ALERT_TYPES_VALUES WHERE ALERT_TYPE_ID = (SELECT ALERT_TYPE_ID FROM AM_ALERT_TYPES WHERE ALERT_TYPE_NAME = 'AbnormalRefreshAlert' AND STAKE_HOLDER = 'subscriber');
DELETE FROM AM_ALERT_TYPES WHERE ALERT_TYPE_NAME = 'AbnormalRefreshAlert' AND STAKE_HOLDER = 'subscriber';

CREATE TABLE IF NOT EXISTS `AM_CERTIFICATE_METADATA` (
  `TENANT_ID` INT(11) NOT NULL,
  `ALIAS` VARCHAR(45) NOT NULL,
  `END_POINT` VARCHAR(100) NOT NULL,
  CONSTRAINT PK_ALIAS PRIMARY KEY (`ALIAS`),
  CONSTRAINT END_POINT_CONSTRAINT UNIQUE (`END_POINT`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AM_APPLICATION_GROUP_MAPPING (
    APPLICATION_ID INTEGER NOT NULL,
    GROUP_ID VARCHAR(512)NOT NULL,
    TENANT VARCHAR(255),
    PRIMARY KEY (APPLICATION_ID,GROUP_ID,TENANT),
    FOREIGN KEY (APPLICATION_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AM_USAGE_UPLOADED_FILES (
  TENANT_DOMAIN varchar(255) NOT NULL,
  FILE_NAME varchar(255) NOT NULL,
  FILE_TIMESTAMP TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FILE_PROCESSED tinyint(1) DEFAULT FALSE,
  FILE_CONTENT MEDIUMBLOB DEFAULT NULL,
  PRIMARY KEY (TENANT_DOMAIN, FILE_NAME, FILE_TIMESTAMP)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AM_API_LC_PUBLISH_EVENTS (
    ID INTEGER(11) NOT NULL AUTO_INCREMENT,
    TENANT_DOMAIN VARCHAR(500) NOT NULL,
    API_ID VARCHAR(500) NOT NULL,
    EVENT_TIME TIMESTAMP NOT NULL,
    PRIMARY KEY (ID)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AM_LABELS (
  LABEL_ID VARCHAR(50),
  NAME VARCHAR(255),
  DESCRIPTION VARCHAR(1024),
  TENANT_DOMAIN VARCHAR(255),
  UNIQUE (NAME,TENANT_DOMAIN),
  PRIMARY KEY (LABEL_ID)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AM_LABEL_URLS (
  LABEL_ID VARCHAR(50),
  ACCESS_URL VARCHAR(255),
  PRIMARY KEY (LABEL_ID,ACCESS_URL),
  FOREIGN KEY (LABEL_ID) REFERENCES AM_LABELS(LABEL_ID) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AM_APPLICATION_ATTRIBUTES (
  APPLICATION_ID int(11) NOT NULL,
  NAME varchar(255) NOT NULL,
  VALUE varchar(1024) NOT NULL,
  TENANT_ID int(11) NOT NULL,
  PRIMARY KEY (APPLICATION_ID,NAME),
  FOREIGN KEY (APPLICATION_ID) REFERENCES AM_APPLICATION (APPLICATION_ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
