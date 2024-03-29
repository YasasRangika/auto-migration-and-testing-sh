ALTER TABLE AM_APPLICATION_REGISTRATION ALTER COLUMN TOKEN_SCOPE TYPE VARCHAR(1500);
ALTER TABLE AM_APPLICATION ADD TOKEN_TYPE VARCHAR(10);
ALTER TABLE AM_API_SCOPES ADD PRIMARY KEY (API_ID, SCOPE_ID);
DELETE FROM AM_ALERT_TYPES_VALUES WHERE ALERT_TYPE_ID = (SELECT ALERT_TYPE_ID FROM AM_ALERT_TYPES WHERE ALERT_TYPE_NAME = 'AbnormalRefreshAlert' AND STAKE_HOLDER = 'subscriber');
DROP TABLE IF EXISTS AM_ALERT_TYPES;
DROP SEQUENCE IF EXISTS  AM_ALERT_TYPES_SEQ;
CREATE SEQUENCE AM_ALERT_TYPES_SEQ START WITH 1 INCREMENT BY 1;
CREATE TABLE IF NOT EXISTS AM_ALERT_TYPES (
            ALERT_TYPE_ID INTEGER DEFAULT NEXTVAL('am_alert_types_seq'),
            ALERT_TYPE_NAME VARCHAR(255) NOT NULL ,
	    STAKE_HOLDER VARCHAR(100) NOT NULL,           
            PRIMARY KEY (ALERT_TYPE_ID)
);
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalResponseTime', 'publisher');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalBackendTime', 'publisher');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalRequestsPerMin', 'subscriber');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalRequestPattern', 'subscriber');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('UnusualIPAccess', 'subscriber');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('FrequentTierLimitHitting', 'subscriber');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('ApiHealthMonitor', 'publisher');

DROP TABLE IF EXISTS AM_CERTIFICATE_METADATA;
CREATE TABLE AM_CERTIFICATE_METADATA (
  TENANT_ID INTEGER NOT NULL,
  ALIAS VARCHAR(45) NOT NULL,
  END_POINT VARCHAR(45) NOT NULL,
  CONSTRAINT PK_ALIAS PRIMARY KEY (ALIAS)
);

DROP TABLE IF EXISTS AM_APPLICATION_GROUP_MAPPING;
CREATE TABLE AM_APPLICATION_GROUP_MAPPING (
    APPLICATION_ID INTEGER NOT NULL,
    GROUP_ID VARCHAR(512) NOT NULL,
    TENANT VARCHAR(255),
    PRIMARY KEY (APPLICATION_ID,GROUP_ID,TENANT),
    FOREIGN KEY (APPLICATION_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS AM_USAGE_UPLOADED_FILES;
CREATE TABLE AM_USAGE_UPLOADED_FILES (
  TENANT_DOMAIN VARCHAR(255) NOT NULL,
  FILE_NAME VARCHAR(255) NOT NULL,
  FILE_TIMESTAMP TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FILE_PROCESSED INTEGER DEFAULT 0,
  FILE_CONTENT BYTEA DEFAULT NULL,
  PRIMARY KEY (TENANT_DOMAIN, FILE_NAME, FILE_TIMESTAMP)
);

DROP TABLE IF EXISTS AM_API_LC_PUBLISH_EVENTS;
DROP SEQUENCE IF EXISTS AM_API_LC_PUBLISH_EVENTS_PK_SEQ;
CREATE SEQUENCE AM_API_LC_PUBLISH_EVENTS_PK_SEQ;
CREATE TABLE IF NOT EXISTS AM_API_LC_PUBLISH_EVENTS (
    ID INTEGER NOT NULL DEFAULT NEXTVAL('AM_API_LC_PUBLISH_EVENTS_PK_SEQ'),
    TENANT_DOMAIN VARCHAR(500) NOT NULL,
    API_ID VARCHAR(500) NOT NULL,
    EVENT_TIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ID)
);

DROP TABLE IF EXISTS AM_APPLICATION_ATTRIBUTES;
CREATE TABLE IF NOT EXISTS AM_APPLICATION_ATTRIBUTES (
  APPLICATION_ID INTEGER NOT NULL,
  NAME VARCHAR(255) NOT NULL,
  VALUE VARCHAR(1024) NOT NULL,
  TENANT_ID INTEGER NOT NULL,
  PRIMARY KEY (APPLICATION_ID,NAME),
  FOREIGN KEY (APPLICATION_ID) REFERENCES AM_APPLICATION (APPLICATION_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS AM_LABELS;
CREATE TABLE IF NOT EXISTS AM_LABELS (
  LABEL_ID VARCHAR(50),
  NAME VARCHAR(255),
  DESCRIPTION VARCHAR(1024),
  TENANT_DOMAIN VARCHAR(255),
  UNIQUE (NAME,TENANT_DOMAIN),
  PRIMARY KEY (LABEL_ID)
);

DROP TABLE IF EXISTS AM_LABEL_URLS;
CREATE TABLE IF NOT EXISTS AM_LABEL_URLS (
  LABEL_ID VARCHAR(50),
  ACCESS_URL VARCHAR(255),
  PRIMARY KEY (LABEL_ID,ACCESS_URL),
  FOREIGN KEY (LABEL_ID) REFERENCES AM_LABELS(LABEL_ID) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE INDEX IDX_AUTHORIZATION_CODE ON IDN_OAUTH2_AUTHORIZATION_CODE (AUTHORIZATION_CODE,CONSUMER_KEY_ID);

ALTER TABLE AM_SUBSCRIBER
    ALTER COLUMN DATE_SUBSCRIBED TYPE TIMESTAMP,
    ALTER COLUMN DATE_SUBSCRIBED SET NOT NULL,
    ALTER COLUMN CREATED_TIME TYPE TIMESTAMP,
    ALTER COLUMN UPDATED_TIME TYPE TIMESTAMP;

ALTER TABLE AM_APPLICATION
    ALTER COLUMN CREATED_TIME TYPE TIMESTAMP,
    ALTER COLUMN UPDATED_TIME TYPE TIMESTAMP;

ALTER TABLE AM_API
    ALTER COLUMN CREATED_TIME TYPE TIMESTAMP,
    ALTER COLUMN UPDATED_TIME TYPE TIMESTAMP;

ALTER TABLE AM_SUBSCRIPTION
    ALTER COLUMN LAST_ACCESSED TYPE TIMESTAMP,
    ALTER COLUMN CREATED_TIME TYPE TIMESTAMP,
    ALTER COLUMN UPDATED_TIME TYPE TIMESTAMP;

ALTER TABLE AM_API_LC_EVENT
    ALTER COLUMN EVENT_DATE TYPE TIMESTAMP,
    ALTER COLUMN EVENT_DATE SET NOT NULL;

ALTER TABLE AM_API_COMMENTS
    ALTER COLUMN DATE_COMMENTED TYPE TIMESTAMP,
    ALTER COLUMN DATE_COMMENTED SET NOT NULL;

