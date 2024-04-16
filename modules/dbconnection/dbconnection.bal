import ballerinax/postgresql;

public final postgresql:Client dbClient =
                               check new (host="hwsrv-1076442.hostwindsdns.com", username = "choreodbadmin", password="wSP675Tael", port=5438, database="wso2_choreo_db");

// public final postgresql:Client dbClient =
//                                check new (host="localhost", username = "postgres", password="12345", port=5432, database="postgres");


public final string imageFolder = "./files/";

public final string accessKeyId = "AKIA6GBMCUEKLS6JRJIO";
public final string secretAccessKey = "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";
public final string region = "eu-north-1";

//mail details
public final string host = "smtp.gmail.com";
public final string mailId = "yudhistervijay@gmail.com";
public final string mailSmtpPswd = "aarxzdxvixtaidzo";

