USE [master]
GO
CREATE DATABASE [MOBILESHOP_DEM05]
GO
USE [MOBILESHOP_DEM05]
GO

-- 1. Table Role
CREATE TABLE [dbo].[Role](
	[RoleId] [int] NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED ([RoleId] ASC))
GO
INSERT INTO [dbo].[Role] ([RoleId], [RoleName]) VALUES (1, N'Admin'), (0, N'User')
GO

-- 2. Table Supplier
CREATE TABLE [dbo].[Supplier](
	[IdSupplier] [varchar](100) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Address] [nvarchar](255) NULL,
	[Email] [nvarchar](100) NOT NULL UNIQUE,
	[PhoneNumber] [varchar](15) NULL,
PRIMARY KEY CLUSTERED ([IdSupplier] ASC))
GO
INSERT [dbo].[Supplier] ([IdSupplier], [Name], [Address], [Email], [PhoneNumber]) VALUES (N'Apple', N'Apple', N'USA', N'contact@apple.com', N'4089961010')
INSERT [dbo].[Supplier] ([IdSupplier], [Name], [Address], [Email], [PhoneNumber]) VALUES (N'Samsung', N'Samsung', N'Korea', N'contact@samsung.com', N'82312001114')
GO

-- 3. Table User
CREATE TABLE [dbo].[User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[Gender] [nvarchar](10) NULL,
	[Email] [varchar](100) NOT NULL UNIQUE,
	[PhoneNumber] [varchar](15) NULL,
	[Address] [nvarchar](255) NULL,
	[Birthday] [date] NULL,
	[RoleId] [int] NULL,
PRIMARY KEY CLUSTERED ([UserId] ASC),
FOREIGN KEY([RoleId]) REFERENCES [dbo].[Role] ([RoleId]))
GO
SET IDENTITY_INSERT [dbo].[User] ON 
INSERT [dbo].[User] ([UserId], [Username], [Gender], [Password], [Address], [Email], [PhoneNumber], [FullName], [Birthday], [RoleId]) VALUES (1, N'admin', N'Male', N'123', N'Ha Noi', N'admin@mobileshop.com', N'0912345678', N'Vương Hải Vũ (Admin)', CAST(N'2004-01-01' AS Date), 1)
INSERT [dbo].[User] ([UserId], [Username], [Gender], [Password], [Address], [Email], [PhoneNumber], [FullName], [Birthday], [RoleId]) VALUES (2, N'phucth', N'Male', N'phuc123', N'Ha Noi', N'phuc@gmail.com', N'0912345678', N'Thân Hải Phúc', CAST(N'2004-05-19' AS Date), 0)
SET IDENTITY_INSERT [dbo].[User] OFF
GO

-- 4. Table BlogCategory
CREATE TABLE [dbo].[BlogCategory](
	[IdBlogCat] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED ([IdBlogCat] ASC))
GO
INSERT INTO [dbo].[BlogCategory] ([CategoryName]) VALUES (N'Tin tức'), (N'Đánh giá'), (N'Mẹo vặt')
GO

-- 5. Table Blog
CREATE TABLE [dbo].[Blog](
	[IdPost] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[SubTitle] [nvarchar](255) NULL,
	[Summary] [nvarchar](500) NULL,
	[Content] [nvarchar](max) NULL,
	[ThumbnailPath] [nvarchar](255) NULL,
	[CreatedDate] [date] DEFAULT (getdate()),
	[UserId] [int] NULL,
	[IdBlogCat] [int] NULL,
PRIMARY KEY CLUSTERED ([IdPost] ASC),
FOREIGN KEY([UserId]) REFERENCES [dbo].[User] ([UserId]),
FOREIGN KEY([IdBlogCat]) REFERENCES [dbo].[BlogCategory] ([IdBlogCat]))
GO
SET IDENTITY_INSERT [dbo].[Blog] ON 
INSERT [dbo].[Blog] ([IdPost], [Title], [SubTitle], [Summary], [Content], [ThumbnailPath], [CreatedDate], [UserId], [IdBlogCat]) VALUES (1, N'iPhone 17 Pro Max Review', N'TIN HOT', N'Đánh giá siêu phẩm 2026', N'Nội dung chi tiết...', N'https://picsum.photos/1200/800', CAST(N'2026-04-16' AS Date), 1, 2)
INSERT [dbo].[Blog] ([IdPost], [Title], [SubTitle], [Summary], [Content], [ThumbnailPath], [CreatedDate], [UserId], [IdBlogCat]) VALUES (2, N'Mẹo dùng Samsung', N'CẨM NANG', N'Cách tiết kiệm pin', N'Nội dung chi tiết...', N'https://picsum.photos/1200/801', CAST(N'2026-04-16' AS Date), 1, 3)
SET IDENTITY_INSERT [dbo].[Blog] OFF
GO

-- 6. Table ProductDetail
CREATE TABLE [dbo].[ProductDetail](
	[IdProduct] [nvarchar](50) NOT NULL,
	[ProductName] [nvarchar](100) NULL,
	[Price] [decimal](10, 2) NOT NULL,
	[Quantity] [int] NOT NULL,
	[ReleaseDate] [date] NOT NULL,
	[Screen] [nvarchar](100) NULL,
	[OperatingSystem] [nvarchar](50) NULL,
	[CPU] [nvarchar](50) NULL,
	[RAM] [int] NULL,
	[Camera] [varchar](50) NULL,
	[Battery] [varchar](50) NULL,
	[Description] [nvarchar](2500) NULL,
	[Discount] [decimal](5, 2) DEFAULT ((0)),
	[ImagePath] [nvarchar](255) NULL,
	[IdSupplier] [varchar](100) NULL,
PRIMARY KEY CLUSTERED ([IdProduct] ASC),
FOREIGN KEY([IdSupplier]) REFERENCES [dbo].[Supplier] ([IdSupplier]))
GO

-- 7. Table Order
CREATE TABLE [dbo].[Order](
	[IdOrder] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[OrderDate] [date] NOT NULL,
	[TotalPrice] [decimal](10, 2) NOT NULL,
	[ReceiverName] [nvarchar](100) NOT NULL,
	[ReceiverPhone] [varchar](15) NOT NULL,
	[ReceiverAddress] [nvarchar](255) NOT NULL,
	[OrderStatus] [nvarchar](50) NULL,
	[PaymentMethod] [nvarchar](50) NULL,
	[PaymentStatus] [nvarchar](50) NULL,
	[DeliveryStatus] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED ([IdOrder] ASC),
FOREIGN KEY([UserId]) REFERENCES [dbo].[User] ([UserId]))
GO

-- 8. Table OrderDetail
CREATE TABLE [dbo].[OrderDetail](
	[IdOrder] [int] NOT NULL,
	[IdProduct] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED ([IdOrder] ASC, [IdProduct] ASC),
FOREIGN KEY([IdOrder]) REFERENCES [dbo].[Order] ([IdOrder]),
FOREIGN KEY([IdProduct]) REFERENCES [dbo].[ProductDetail] ([IdProduct]))
GO
