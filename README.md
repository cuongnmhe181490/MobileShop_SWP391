# MobileShop Project

## Hướng dẫn cài đặt cho lập trình viên (Setup Guide)

Để dự án có thể chạy được với các tính năng Gửi Mail và Upload ảnh, bạn cần làm theo các bước sau:

1. **Tạo file cấu hình cá nhân**:
   - Vào thư mục `src/java/`.
   - Tìm file `config.properties.example`.
   - Copy và đổi tên thành `config.properties`.

2. **Điền thông tin API Key**:
   - Mở file `config.properties` vừa tạo.
   - Điền các mã Key từ tài khoản **SendGrid** và **Cloudinary** của bạn vào.
   - Lưu file lại.

3. **Lưu ý quan trọng**:
   - File `config.properties` đã được liệt kê trong `.gitignore` để đảm bảo an toàn. **Tuyệt đối không được xóa nó khỏi .gitignore** để tránh bị lộ mật khẩu và key khi đẩy lên GitHub/GitLab.

4. **Chạy dự án**:
   - Sử dụng NetBeans hoặc IDE tương đương.
   - Chọn **Clean and Build** dự án trước khi chạy.
