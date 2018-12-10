ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD USER_ACCESS_TOKEN_EXPIRE_TIME BIGINT DEFAULT 3600000;
ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD APP_ACCESS_TOKEN_EXPIRE_TIME BIGINT DEFAULT 3600000;
ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD REFRESH_TOKEN_EXPIRE_TIME BIGINT DEFAULT 84600000;

ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ALTER COLUMN ACCESS_TOKEN VARCHAR(512);
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ALTER COLUMN REFRESH_TOKEN VARCHAR(512);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OAUTH2_SCOPE_BINDING]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OAUTH2_SCOPE_BINDING (
  SCOPE_ID INTEGER NOT NULL,
  SCOPE_BINDING VARCHAR(255),
  FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE(SCOPE_ID) ON DELETE CASCADE
);

ALTER TABLE IDN_IDENTITY_USER_DATA ALTER COLUMN DATA_VALUE VARCHAR(2048);
