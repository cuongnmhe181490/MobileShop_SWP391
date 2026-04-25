package controller.storefront;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;

public class ProductImageFallbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("image/svg+xml;charset=UTF-8");
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        String brand = trim(request.getParameter("brand"));
        String name = trim(request.getParameter("name"));
        String[] palette = resolvePalette(brand);
        int variant = Math.abs((brand + "|" + name).hashCode()) % 4;
        String title = truncate(name.isEmpty() ? "MobileShop" : name, 28);
        String subtitle = brand.isEmpty() ? "MobileShop" : brand.toUpperCase();
        String initials = buildInitials(name.isEmpty() ? brand : name);

        try (PrintWriter out = response.getWriter()) {
            out.write(buildSvg(title, subtitle, initials, palette, variant));
        }
    }

    private String buildSvg(String title, String subtitle, String initials, String[] palette, int variant) {
        String background = palette[0];
        String accent = palette[1];
        String soft = palette[2];
        String deep = palette[3];
        String ivory = "#FFFDF8";

        String layout;
        switch (variant) {
            case 0:
                layout = """
                        <circle cx="780" cy="158" r="100" fill="%s" opacity="0.32"/>
                        <circle cx="162" cy="538" r="58" fill="%s" opacity="0.22"/>
                        <rect x="278" y="112" width="206" height="396" rx="42" fill="%s" transform="rotate(-8 278 112)"/>
                        <rect x="492" y="132" width="206" height="396" rx="42" fill="%s" transform="rotate(7 492 132)"/>
                        <circle cx="556" cy="170" r="18" fill="%s" opacity="0.65"/>
                        """.formatted(accent, accent, ivory, deep, accent);
                break;
            case 1:
                layout = """
                        <rect x="102" y="104" width="268" height="472" rx="54" fill="%s" opacity="0.88"/>
                        <rect x="420" y="132" width="236" height="430" rx="48" fill="%s" opacity="0.96"/>
                        <rect x="694" y="188" width="118" height="246" rx="30" fill="%s" opacity="0.4"/>
                        <circle cx="762" cy="164" r="72" fill="%s" opacity="0.18"/>
                        <circle cx="188" cy="180" r="22" fill="%s" opacity="0.45"/>
                        """.formatted(deep, ivory, accent, accent, soft);
                break;
            case 2:
                layout = """
                        <circle cx="260" cy="182" r="128" fill="%s" opacity="0.18"/>
                        <circle cx="736" cy="508" r="112" fill="%s" opacity="0.26"/>
                        <rect x="244" y="124" width="192" height="394" rx="44" fill="%s"/>
                        <rect x="454" y="144" width="246" height="368" rx="44" fill="%s"/>
                        <rect x="508" y="198" width="138" height="18" rx="9" fill="%s" opacity="0.22"/>
                        <rect x="508" y="232" width="104" height="18" rx="9" fill="%s" opacity="0.22"/>
                        <rect x="508" y="266" width="122" height="18" rx="9" fill="%s" opacity="0.22"/>
                        """.formatted(accent, soft, ivory, deep, ivory, ivory, ivory);
                break;
            default:
                layout = """
                        <rect x="118" y="142" width="664" height="360" rx="48" fill="%s" opacity="0.18"/>
                        <rect x="206" y="122" width="196" height="398" rx="44" fill="%s" transform="rotate(-6 206 122)"/>
                        <rect x="432" y="116" width="196" height="398" rx="44" fill="%s" transform="rotate(3 432 116)"/>
                        <circle cx="702" cy="206" r="88" fill="%s" opacity="0.24"/>
                        <circle cx="640" cy="480" r="46" fill="%s" opacity="0.22"/>
                        """.formatted(accent, ivory, deep, soft, accent);
                break;
        }

        return """
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 720" role="img" aria-label="%s">
                  <defs>
                    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
                      <stop offset="0%%" stop-color="%s"/>
                      <stop offset="100%%" stop-color="%s"/>
                    </linearGradient>
                  </defs>
                  <rect width="960" height="720" rx="38" fill="url(#bg)"/>
                  <rect x="60" y="58" width="150" height="42" rx="21" fill="rgba(255,255,255,0.24)"/>
                  <text x="88" y="86" font-size="24" font-weight="700" font-family="'Be Vietnam Pro', Arial, sans-serif" fill="#FFFFFF">%s</text>
                  %s
                  <text x="72" y="610" font-size="42" font-weight="800" font-family="'Be Vietnam Pro', Arial, sans-serif" fill="#1E2952">%s</text>
                  <text x="72" y="648" font-size="24" font-weight="600" font-family="'Be Vietnam Pro', Arial, sans-serif" fill="#486189">%s</text>
                  <circle cx="826" cy="612" r="58" fill="rgba(255,255,255,0.18)"/>
                  <text x="826" y="624" text-anchor="middle" font-size="28" font-weight="800" font-family="'Be Vietnam Pro', Arial, sans-serif" fill="#FFFFFF">%s</text>
                </svg>
                """.formatted(
                escapeXml(title),
                background,
                soft,
                escapeXml(subtitle),
                layout,
                escapeXml(title),
                escapeXml(subtitle),
                escapeXml(initials)
        );
    }

    private String[] resolvePalette(String brand) {
        switch (brand.toLowerCase()) {
            case "apple":
                return new String[]{"#EEF3FF", "#B8C9FF", "#DCE5FF", "#243253"};
            case "samsung":
                return new String[]{"#EDF2FF", "#9FB2FF", "#D7DFFF", "#213462"};
            case "xiaomi":
                return new String[]{"#FFF2E6", "#FFB86B", "#FFE0BC", "#3C2D22"};
            case "oppo":
                return new String[]{"#ECFFF6", "#9CE2C0", "#D8F7E8", "#24385A"};
            case "realme":
                return new String[]{"#FFF9DD", "#FFD75B", "#FFF0A8", "#28314F"};
            case "google":
                return new String[]{"#EEF5FF", "#88B5FF", "#D6E6FF", "#273C63"};
            case "huawei":
                return new String[]{"#FFF0EC", "#FF9A8B", "#FFD4CB", "#332A2C"};
            default:
                return new String[]{"#EEF4FF", "#B4C7F7", "#D8E3FB", "#263556"};
        }
    }

    private String buildInitials(String value) {
        String normalized = trim(value);
        if (normalized.isEmpty()) {
            return "MS";
        }
        String[] parts = normalized.split("\\s+");
        StringBuilder builder = new StringBuilder();
        for (String part : parts) {
            if (!part.isEmpty() && Character.isLetterOrDigit(part.charAt(0))) {
                builder.append(Character.toUpperCase(part.charAt(0)));
            }
            if (builder.length() == 2) {
                break;
            }
        }
        if (builder.length() == 0) {
            return "MS";
        }
        if (builder.length() == 1) {
            builder.append('P');
        }
        return builder.toString();
    }

    private String truncate(String value, int maxLength) {
        if (value.length() <= maxLength) {
            return value;
        }
        return value.substring(0, Math.max(0, maxLength - 3)) + "...";
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private String escapeXml(String value) {
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&apos;");
    }
}
