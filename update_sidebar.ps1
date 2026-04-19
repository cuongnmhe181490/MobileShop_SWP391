$files = @(
    "d:\PROJECT_MobileShops Copy - Copy\web\admin-hero-list.jsp",
    "d:\PROJECT_MobileShops Copy - Copy\web\config-hero-add.jsp",
    "d:\PROJECT_MobileShops Copy - Copy\web\config-hero-edit.jsp",
    "d:\PROJECT_MobileShops Copy - Copy\web\brand-list.jsp",
    "d:\PROJECT_MobileShops Copy - Copy\web\config-brand-add.jsp",
    "d:\PROJECT_MobileShops Copy - Copy\web\config-brand-edit.jsp",
    "d:\PROJECT_MobileShops Copy - Copy\web\admin-top-product-list.jsp",
    "d:\PROJECT_MobileShops Copy - Copy\web\config-top-product-add.jsp",
    "d:\PROJECT_MobileShops Copy - Copy\web\config-top-product-edit.jsp",
    "d:\PROJECT_MobileShops Copy - Copy\web\admin-trade-in-list.jsp",
    "d:\PROJECT_MobileShops Copy - Copy\web\config-trade-in-edit.jsp"
)

foreach ($filepath in $files) {
    if (-not (Test-Path $filepath)) { continue }
    
    $content = Get-Content $filepath -Raw -Encoding UTF8
    
    $startIdx = $content.IndexOf('<div class="sidebar">')
    if ($startIdx -eq -1) { continue }
    
    $divCount = 0
    $endIdx = -1
    $pos = $startIdx
    
    while ($pos -lt $content.Length) {
        $nextOpen = $content.IndexOf('<div', $pos)
        $nextClose = $content.IndexOf('</div>', $pos)
        
        if ($nextOpen -ne -1 -and $nextOpen -lt $nextClose) {
            $divCount++
            $pos = $nextOpen + 4
        } elseif ($nextClose -ne -1) {
            $divCount--
            $pos = $nextClose + 6
            if ($divCount -eq 0) {
                $endIdx = $pos
                break
            }
        } else {
            break
        }
    }
    
    if ($endIdx -ne -1) {
        $heroAct = if ($filepath -match "hero") { ' class="active"' } else { '' }
        $brandAct = if ($filepath -match "brand") { ' class="active"' } else { '' }
        $topAct = if ($filepath -match "top-product") { ' class="active"' } else { '' }
        $tradeAct = if ($filepath -match "trade-in") { ' class="active"' } else { '' }
        
        $newSidebar = @"
<div class="sidebar">
            <h4>MobileShop</h4>
            <div class="nav-list">
                <a href="`${ctx}/HeroListServlet"$heroAct>Biểu ngữ chính</a>
                <a href="`${ctx}/BrandListServlet"$brandAct>Thương hiệu</a>
                <a href="`${ctx}/TopProductListServlet"$topAct>Sản phẩm bán chạy</a>
                <a href="`${ctx}/TradeInConfigServlet"$tradeAct>Cấu hình Trade-in</a>
            </div>
        </div>
"@
        
        $content = $content.Substring(0, $startIdx) + $newSidebar + $content.Substring($endIdx)
        
        $content = $content -replace '(?s)\s*<a href="#" class="logout-link">[^<]*</a>', ''
        
        [System.IO.File]::WriteAllText($filepath, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Updated $filepath"
    } else {
        Write-Host "Could not find matching closing div in $filepath"
    }
}
