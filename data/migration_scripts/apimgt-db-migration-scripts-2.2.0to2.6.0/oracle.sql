ALTER TABLE AM_APPLICATION ADD TOKEN_TYPE VARCHAR2(100)
/
ALTER TABLE AM_API_SCOPES ADD PRIMARY KEY (API_ID, SCOPE_ID)
/
DELETE FROM AM_ALERT_TYPES_VALUES WHERE ALERT_TYPE_ID = (SELECT ALERT_TYPE_ID FROM AM_ALERT_TYPES WHERE ALERT_TYPE_NAME = 'AbnormalRefreshAlert' AND STAKE_HOLDER = 'subscriber')
/
DROP TABLE AM_ALERT_TYPES;
/
DROP SEQUENCE AM_ALERT_TYPES_SEQ;
/
CREATE TABLE  AM_ALERT_TYPES (
            ALERT_TYPE_ID INTEGER,
            ALERT_TYPE_NAME VARCHAR(255) NOT NULL ,
	    STAKE_HOLDER VARCHAR(100) NOT NULL,
            PRIMARY KEY (ALERT_TYPE_ID))
/
CREATE SEQUENCE AM_ALERT_TYPES_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER AM_ALERT_TYPES_TRIG
            BEFORE INSERT
            ON AM_ALERT_TYPES
            REFERENCING NEW AS NEW
            FOR EACH ROW
               BEGIN
                   SELECT AM_ALERT_TYPES_SEQ.nextval INTO :NEW.ALERT_TYPE_ID FROM dual;
               END;
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalResponseTime', 'publisher')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalBackendTime', 'publisher')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalRequestsPerMin', 'subscriber')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalRequestPattern', 'subscriber')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('UnusualIPAccess', 'subscriber')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('FrequentTierLimitHitting', 'subscriber')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('ApiHealthMonitor', 'publisher')
/
CREATE TABLE AM_LABELS (
  LABEL_ID VARCHAR2(50),
  NAME VARCHAR2(255) NOT NULL,
  DESCRIPTION VARCHAR2(1024),
  TENANT_DOMAIN VARCHAR2(255),
  UNIQUE (NAME,TENANT_DOMAIN),
  PRIMARY KEY (LABEL_ID)
)
/
CREATE TABLE AM_LABEL_URLS (
  LABEL_ID VARCHAR2(50),
  ACCESS_URL VARCHAR2(255),
  PRIMARY KEY (LABEL_ID,ACCESS_URL),
  FOREIGN KEY (LABEL_ID) REFERENCES AM_LABELS(LABEL_ID) ON DELETE CASCADE
)
/
CREATE TABLE AM_APPLICATION_ATTRIBUTES (
  APPLICATION_ID INTEGER,
  NAME VARCHAR2(255),
  VALUE VARCHAR2(1024),
  TENANT_ID INTEGER,
  PRIMARY KEY (APPLICATION_ID,NAME),
  FOREIGN KEY (APPLICATION_ID) REFERENCES AM_APPLICATION (APPLICATION_ID) ON DELETE CASCADE
)
/
