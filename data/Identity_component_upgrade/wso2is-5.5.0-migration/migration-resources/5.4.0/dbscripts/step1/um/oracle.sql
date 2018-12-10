ALTER TABLE UM_PERMISSION ADD CONSTRAINT RES_ACT_TENANT_CONSTRAINT UNIQUE (UM_RESOURCE_ID,UM_ACTION,UM_TENANT_ID)
/

CREATE INDEX SYSTEM_ROLE_IND_BY_RN_TI ON UM_SYSTEM_ROLE(UM_ROLE_NAME, UM_TENANT_ID)
/