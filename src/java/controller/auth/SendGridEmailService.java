/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.auth;
import com.sendgrid.*;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.*;
import java.io.IOException;


/**
 *
 * @author ADMIN
 */
public class SendGridEmailService {
    // THAY API KEY CỦA BẠN VÀO ĐÂY (Lấy từ trang chủ SendGrid)
    private static final String API_KEY = "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"; 

    // ĐÂY PHẢI LÀ EMAIL BẠN VỪA VERIFY TRÊN SENDGRID
    private static final String SYSTEM_EMAIL = "thanhaiphuc@gmail.com"; 

    public boolean sendResetPasswordEmail(String toEmail, String resetLink, String userName) {
        // Tên hiển thị là MobileShop, gửi từ email đã Verify
        Email from = new Email(SYSTEM_EMAIL, "MobileShop System");
        Email to = new Email(toEmail);
        String subject = "[MobileShop] Xác nhận đặt lại mật khẩu";
        
        // Nội dung HTML chuyên nghiệp
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

        SendGrid sg = new SendGrid(API_KEY);
        Request request = new Request();
        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());
            
            // Thực hiện gọi API
            Response response = sg.api(request);
            
            // In ra console để dễ debug
            System.out.println("SendGrid Status Code: " + response.getStatusCode());
            
            // 202 Accepted là thành công
            return response.getStatusCode() == 202;
            
        } catch (IOException ex) {
            System.err.println("Lỗi khi gọi SendGrid API: " + ex.getMessage());
            return false;
        }
    }
}
