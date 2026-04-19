import os

files = [
    r"d:\PROJECT_MobileShops Copy - Copy\web\admin-hero-list.jsp",
    r"d:\PROJECT_MobileShops Copy - Copy\web\config-hero-add.jsp",
    r"d:\PROJECT_MobileShops Copy - Copy\web\config-hero-edit.jsp",
    r"d:\PROJECT_MobileShops Copy - Copy\web\brand-list.jsp",
    r"d:\PROJECT_MobileShops Copy - Copy\web\config-brand-add.jsp",
    r"d:\PROJECT_MobileShops Copy - Copy\web\config-brand-edit.jsp",
    r"d:\PROJECT_MobileShops Copy - Copy\web\admin-top-product-list.jsp",
    r"d:\PROJECT_MobileShops Copy - Copy\web\config-top-product-add.jsp",
    r"d:\PROJECT_MobileShops Copy - Copy\web\config-top-product-edit.jsp",
    r"d:\PROJECT_MobileShops Copy - Copy\web\admin-trade-in-list.jsp",
    r"d:\PROJECT_MobileShops Copy - Copy\web\config-trade-in-edit.jsp"
]

for filepath in files:
    if not os.path.exists(filepath): 
        print(f"File not found: {filepath}")
        continue
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
        
    start_idx = content.find('<div class="sidebar">')
    if start_idx == -1: 
        print(f"Skipping {filepath}: No <div class='sidebar'> found.")
        continue
    
    div_count = 0
    end_idx = -1
    pos = start_idx
    while pos < len(content):
        next_open = content.find('<div', pos)
        next_close = content.find('</div>', pos)
        
        if next_open != -1 and next_open < next_close:
            div_count += 1
            pos = next_open + 4
        elif next_close != -1:
            div_count -= 1
            pos = next_close + 6
            if div_count == 0:
                end_idx = pos
                break
        else:
            break
            
    if end_idx != -1:
        hero_act = ' class="active"' if 'hero' in filepath else ''
        brand_act = ' class="active"' if 'brand' in filepath else ''
        top_act = ' class="active"' if 'top-product' in filepath else ''
        trade_act = ' class="active"' if 'trade-in' in filepath else ''
        
        new_sidebar = f"""<div class="sidebar">
            <h4>MobileShop</h4>
            <div class="nav-list">
                <a href="${{ctx}}/HeroListServlet"{hero_act}>Biểu ngữ chính</a>
                <a href="${{ctx}}/BrandListServlet"{brand_act}>Thương hiệu</a>
                <a href="${{ctx}}/TopProductListServlet"{top_act}>Sản phẩm bán chạy</a>
                <a href="${{ctx}}/TradeInConfigServlet"{trade_act}>Cấu hình Trade-in</a>
            </div>
        </div>"""
        
        content = content[:start_idx] + new_sidebar + content[end_idx:]
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {filepath}")
    else:
        print(f"Could not find matching closing div in {filepath}")
