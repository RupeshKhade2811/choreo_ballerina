import ballerinax/postgresql;



public final postgresql:Client dbClient =
                               check new (host="localhost", username = "postgres", password="12345", port=5432, database="postgres");


public final string imageFolder = "./files/";

public final string accessKeyId = "xxxxxxxxxxxxxxxxxxxxxx";
public final string secretAccessKey = "zxxxxxxxxxxxx";
public final string region = "eu-north-1";

//mail details
public final string host = "smtp.gmail.com";
public final string mailId = "yudhistervijay@gmail.com";
public final string mailSmtpPswd = "aarxzdxvixtaidzo";

