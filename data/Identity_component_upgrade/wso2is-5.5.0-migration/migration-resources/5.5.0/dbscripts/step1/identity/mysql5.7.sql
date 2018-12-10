DROP INDEX IDX_AT ON IDN_OAUTH2_ACCESS_TOKEN;
DROP INDEX IDX_AUTHORIZATION_CODE ON IDN_OAUTH2_AUTHORIZATION_CODE;
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN modify REFRESH_TOKEN VARCHAR(2048);
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN modify ACCESS_TOKEN VARCHAR(2048);
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE modify AUTHORIZATION_CODE VARCHAR(2048);
ALTER TABLE IDN_OAUTH_CONSUMER_APPS modify CONSUMER_SECRET VARCHAR(2048);

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_SCOPE_VALIDATORS (
	APP_ID INTEGER NOT NULL,
	SCOPE_VALIDATOR VARCHAR (128) NOT NULL,
	PRIMARY KEY (APP_ID,SCOPE_VALIDATOR),
	FOREIGN KEY (APP_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
)ENGINE INNODB;
CREATE TABLE IF NOT EXISTS SP_AUTH_SCRIPT (
  ID         INTEGER AUTO_INCREMENT NOT NULL,
  TENANT_ID  INTEGER                NOT NULL,
  APP_ID     INTEGER                NOT NULL,
  TYPE       VARCHAR(255)           NOT NULL,
  CONTENT    BLOB    DEFAULT NULL,
  IS_ENABLED CHAR(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (ID));
CREATE TABLE IF NOT EXISTS IDN_OIDC_JTI (
  JWT_ID VARCHAR(255) NOT NULL,
  EXP_TIME TIMESTAMP NOT NULL ,
  TIME_CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (JWT_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS  IDN_OIDC_PROPERTY (
  ID INTEGER NOT NULL AUTO_INCREMENT,
  TENANT_ID  INTEGER,
  CONSUMER_KEY  VARCHAR(255) ,
  PROPERTY_KEY  VARCHAR(255) NOT NULL,
  PROPERTY_VALUE  VARCHAR(2047) ,
  PRIMARY KEY (ID),
  FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OIDC_REQ_OBJECT_REFERENCE (
  ID INTEGER NOT NULL AUTO_INCREMENT,
  CONSUMER_KEY_ID INTEGER ,
  CODE_ID VARCHAR(255) ,
  TOKEN_ID VARCHAR(255) ,
  SESSION_DATA_KEY VARCHAR(255),
  PRIMARY KEY (ID),
  FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE,
  FOREIGN KEY (TOKEN_ID) REFERENCES IDN_OAUTH2_ACCESS_TOKEN(TOKEN_ID) ON DELETE CASCADE,
  FOREIGN KEY (CODE_ID) REFERENCES IDN_OAUTH2_AUTHORIZATION_CODE(CODE_ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OIDC_REQ_OBJECT_CLAIMS (
  ID INTEGER NOT NULL AUTO_INCREMENT,
  REQ_OBJECT_ID INTEGER,
  CLAIM_ATTRIBUTE VARCHAR(255) ,
  ESSENTIAL CHAR(1) NOT NULL DEFAULT '0' ,
  VALUE VARCHAR(255) ,
  IS_USERINFO CHAR(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (ID),
  FOREIGN KEY (REQ_OBJECT_ID) REFERENCES IDN_OIDC_REQ_OBJECT_REFERENCE (ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OIDC_REQ_OBJ_CLAIM_VALUES (
  ID INTEGER NOT NULL AUTO_INCREMENT,
  REQ_OBJECT_CLAIMS_ID INTEGER ,
  CLAIM_VALUES VARCHAR(255) ,
  PRIMARY KEY (ID),
  FOREIGN KEY (REQ_OBJECT_CLAIMS_ID) REFERENCES  IDN_OIDC_REQ_OBJECT_CLAIMS(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_CERTIFICATE (
             ID INTEGER NOT NULL AUTO_INCREMENT,
             NAME VARCHAR(100),
             CERTIFICATE_IN_PEM BLOB,
             TENANT_ID INTEGER DEFAULT 0,
             PRIMARY KEY(ID),
             CONSTRAINT CERTIFICATE_UNIQUE_KEY UNIQUE (NAME, TENANT_ID)
)ENGINE INNODB;
