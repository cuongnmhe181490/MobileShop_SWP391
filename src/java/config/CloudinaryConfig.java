/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package config;

/**
 *
 * @author Admin
 */
import com.cloudinary.Cloudinary;
import java.util.HashMap;
import java.util.Map;
public class CloudinaryConfig {
    public static Cloudinary getCloudinary() {
        Map<String, String> config = new HashMap<>();
        config.put("cloud_name", "dovcx8lxl"); // Thay bằng thông số thật của bạn
        config.put("api_key", "686417178596178");
        config.put("api_secret", "wgqV0cS4ia7kjW8fNJ-n21216hc");
        return new Cloudinary(config);
    }
}
