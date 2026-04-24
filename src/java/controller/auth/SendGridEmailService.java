/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.auth;
import com.sendgrid.*;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;


/**
 *
 * @author ADMIN
 */
public class SendGridEmailService {
    private String getApiKey() {
        Properties prop = new Properties();
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("config.properties")) {
            if (input == null) {
                System.out.println("Lỗi: Không tìm thấy file config.properties!");
                return null;
            }
            prop.load(input);
            return prop.getProperty("SENDGRID_API_KEY");
            
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    } 

    private static final String SYSTEM_EMAIL = "thanhaiphuc@gmail.com"; 

    public boolean sendResetPasswordEmail(String toEmail, String resetLink, String userName) {
        Email from = new Email(SYSTEM_EMAIL, "MobileShop System");
        Email to = new Email(toEmail);
        String subject = "[MobileShop] Xác nhận đặt lại mật khẩu";
        
        String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 5px; max-width: 600px; margin: 0 auto;'>"
                + "<div style='text-align: center; margin-bottom: 20px;'>"
                + "<h2 style='color: #0056b3; margin: 0;'>MobileShop Security</h2>"
                + "</div>"
                + "<p style='font-size: 16px; color: #333;'>Xin chào <strong>" + userName + "</strong>,</p>"
                + "<p style='color: #555;'>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn tại hệ thống MobileShop.</p>"
                + "<p style='color: #555;'>Vui lòng nhấn vào nút bên dưới để tiến hành đổi mật khẩu. Liên kết này có hiệu lực trong <strong>10 phút</strong>:</p>"
                + "<div style='text-align: center; margin: 30px 0;'>"
                + "<a href='" + resetLink + "' style='background-color: #007bff; color: white; padding: 12px 25px; text-decoration: none; border-radius: 4px; font-weight: bold; display: inline-block;'>Đặt lại mật khẩu</a>"
                + "</div>"
                + "<hr style='border: none; border-top: 1px solid #eee;' />"
                + "<p style='color: #888; font-size: 12px; margin-top: 20px;'>Nếu bạn không yêu cầu thay đổi này, hãy bỏ qua email này để đảm bảo an toàn cho tài khoản. Vui lòng không phản hồi lại email này.</p>"
                + "</div>";

        Content content = new Content("text/html", htmlContent);
        Mail mail = new Mail(from, subject, to, content);

        String apiKey = getApiKey();

        if (apiKey == null || apiKey.isEmpty()) {
            System.err.println("Lỗi: Không tìm thấy API Key. Vui lòng kiểm tra file config.properties!");
            return false; 
        }

        SendGrid sg = new SendGrid(apiKey);
        Request request = new Request();
        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());
            
            Response response = sg.api(request);
            
            System.out.println("SendGrid Status Code: " + response.getStatusCode());
            
            return response.getStatusCode() == 202;
            
        } catch (IOException ex) {
            System.err.println("Lỗi khi gọi SendGrid API: " + ex.getMessage());
            return false;
        }
    }
    
    public boolean sendBanNotificationEmail(String toEmail, String userName, String reason) {
        Email from = new Email(SYSTEM_EMAIL, "MobileShop System");
        Email to = new Email(toEmail);
        String subject = "[MobileShop] THÔNG BÁO TÀI KHOẢN BỊ KHÓA";
        
        String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ffcccc; border-radius: 5px; max-width: 600px; margin: 0 auto; background-color: #fffafb;'>"
                + "<div style='text-align: center; margin-bottom: 20px;'>"
                + "<h2 style='color: #dc3545; margin: 0;'>⚠️ Thông Báo Khóa Tài Khoản</h2>"
                + "</div>"
                + "<p style='font-size: 16px; color: #333;'>Xin chào <strong>" + userName + "</strong>,</p>"
                + "<p style='color: #555;'>Chúng tôi rất tiếc phải thông báo rằng tài khoản của bạn tại hệ thống MobileShop đã bị khóa bởi Quản trị viên.</p>"
                + "<div style='background-color: #ffeeee; padding: 15px; border-left: 4px solid #dc3545; margin: 20px 0;'>"
                + "<p style='margin: 0; color: #555;'><strong>Lý do khóa:</strong> <span style='color: #dc3545; font-weight: bold;'>" + reason + "</span></p>"
                + "</div>"
                + "<p style='color: #555;'>Khi tài khoản bị khóa, bạn sẽ tự động bị đăng xuất và không thể đăng nhập lại vào hệ thống.</p>"
                + "<hr style='border: none; border-top: 1px solid #eee; margin-top: 30px;' />"
                + "<p style='color: #888; font-size: 12px; margin-top: 20px;'>Nếu bạn cho rằng đây là một sự nhầm lẫn, vui lòng gửi yêu cầu hỗ trợ để được xử lý.</p>"
                + "</div>";

        Content content = new Content("text/html", htmlContent);
        Mail mail = new Mail(from, subject, to, content);
        String apiKey = getApiKey();

        if (apiKey == null || apiKey.isEmpty()) return false; 
        try {
            SendGrid sg = new SendGrid(apiKey);
            Request request = new Request();
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());
            return sg.api(request).getStatusCode() == 202;
        } catch (IOException ex) {
            return false;
        }
    }
}
