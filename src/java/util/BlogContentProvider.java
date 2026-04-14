package util;

import entity.BlogPost;
import java.util.ArrayList;
import java.util.List;

public final class BlogContentProvider {

    private BlogContentProvider() {
    }

    public static List<BlogPost> getAllPosts() {
        List<BlogPost> posts = new ArrayList<>();
        posts.add(new BlogPost(
                "camera-flagship-2026",
                "Tư vấn camera",
                "Chọn camera flagship năm 2026 như thế nào để không mua nhầm",
                "Đi từ nhu cầu chụp thật tế đến zoom, chống rung và khả năng giữ giá để chọn đúng model.",
                "14/04/2026",
                "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=1200&q=80"
        ));
        posts.add(new BlogPost(
                "may-gon-nhe-pin-ben",
                "Thiết kế & trải nghiệm",
                "Máy gọn nhẹ nhưng vẫn pin tốt: nên ưu tiên thông số nào trước",
                "Kích thước, độ sáng màn hình, nhiệt độ máy và dung lượng pin cần được cân bằng thay vì chỉ nhìn một chỉ số.",
                "12/04/2026",
                "https://images.unsplash.com/photo-1523206489230-c012c64b2b48?auto=format&fit=crop&w=1200&q=80"
        ));
        posts.add(new BlogPost(
                "phu-kien-mo-ban",
                "Phụ kiện",
                "Ốp lưng, sạc và wearables nên mua cùng đợt mở bán hay chờ sau",
                "Danh sách phụ kiện nên mua ngay, món nào có thể đợi và cách tránh mua trùng nhu cầu.",
                "10/04/2026",
                "https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=1200&q=80"
        ));
        return posts;
    }
}
