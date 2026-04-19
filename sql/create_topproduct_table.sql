-- Script tạo bảng TopProduct
-- Chạy script này trong SQL Server để tạo bảng

USE MOBILESHOP_DEM08; -- Thay đổi tên database nếu cần

-- Kiểm tra nếu bảng đã tồn tại thì xóa
IF OBJECT_ID('dbo.TopProduct', 'U') IS NOT NULL
    DROP TABLE dbo.TopProduct;
GO

-- Tạo bảng TopProduct
CREATE TABLE dbo.TopProduct (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    ProductImage NVARCHAR(500) NULL,
    Price DECIMAL(18,2) NOT NULL DEFAULT 0,
    OriginalPrice DECIMAL(18,2) NULL DEFAULT 0,
    DisplayOrder INT NOT NULL DEFAULT 1,
    IsActive BIT NOT NULL DEFAULT 1,
    DiscountPercent INT NOT NULL DEFAULT 0
);
GO

-- Thêm một số dữ liệu mẫu
INSERT INTO dbo.TopProduct (ProductName, ProductImage, Price, OriginalPrice, DisplayOrder, IsActive, DiscountPercent)
VALUES 
(N'iPhone 15 Pro Max', 'https://cdn2.cellphones.com.vn/358x358,webp,q100/media/resize/160x160/media/catalog/product/p/i/iphone-15-pro-max_1_.png', 29990000, 32990000, 1, 1, 10),
(N'Samsung Galaxy S24 Ultra', 'https://cdn2.cellphones.com.vn/358x358,webp,q100/media/resize/160x160/media/catalog/product/s/a/samsung-galaxy-s24-ultra_1_.png', 25990000, 28990000, 2, 1, 15),
(N'Xiaomi 14 Ultra', 'https://cdn2.cellphones.com.vn/358x358,webp,q100/media/resize/160x160/media/catalog/product/x/i/xiaomi-14-ultra_1_.png', 22990000, 24990000, 3, 1, 8);
GO

PRINT N'✅ Tạo bảng TopProduct thành công!';
GO