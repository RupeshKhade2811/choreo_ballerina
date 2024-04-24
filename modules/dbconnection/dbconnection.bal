import ballerinax/postgresql;


// This specifies that the password must be supplied in a configuration file.
configurable string dbHost = ?;
configurable string password = ?;
configurable string username = ?;
configurable string database = ?;
configurable int port = ?;

configurable string acesKeyId = ?;
configurable string secretAcesKey = ?;

configurable string mail = ?;
configurable string mailSmtpPassword = ?;


public final postgresql:Client dbClient =
                               check new (host=dbHost, username = username, password=password, port=port, database=database);


public final string imageFolder = "/tmp/";

public final string accessKeyId = acesKeyId;
public final string secretAccessKey = secretAcesKey;
public final string region = "eu-north-1";

//mail details
public final string host = "smtp.gmail.com";
public final string mailId = mail;
public final string mailSmtpPswd = mailSmtpPassword;

