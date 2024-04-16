import ballerina/email;
import big_billion_cars.user;
import big_billion_cars.dbconnection;


email:SmtpConfiguration smtpConfig = {
    port: 465
};

string host = dbconnection:host;
string mail = dbconnection:mailId;
string mailPswd = dbconnection:mailSmtpPswd;


public function mailService(string userId,string vin) returns error?{
    email:SmtpClient smtpClient = check new (host, mail, mailPswd, smtpConfig);
    user:Users users = check user:getUsers(userId);
    string gmail=users.email;
    email:Message email = {
        to: gmail,
        subject: "Greetings from Big Billion Cars",
        body: "Thanks for using BBC, your car details with vehicle number:"+vin+"has created successfully ",
        // body: "Thanks for using BBC, your car detail has created successfully",
        'from: "yudhistervijay@gmail.com"
    };

    check smtpClient->sendMessage(email);
}