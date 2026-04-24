USE [MOBILESHOP_DEM05]
GO

-- 1. Add missing columns to ProductDetail
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ProductDetail]') AND name = 'OriginalQuantity')
    ALTER TABLE [dbo].[ProductDetail] ADD [OriginalQuantity] [int] NULL;
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ProductDetail]') AND name = 'CurrentQuantity')
    ALTER TABLE [dbo].[ProductDetail] ADD [CurrentQuantity] [int] NULL;
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ProductDetail]') AND name = 'idCat')
    ALTER TABLE [dbo].[ProductDetail] ADD [idCat] [int] NULL;
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ProductDetail]') AND name = 'IsFeatured')
    ALTER TABLE [dbo].[ProductDetail] ADD [IsFeatured] [int] DEFAULT ((0));
GO

-- Sync quantities if they were NULL
UPDATE [dbo].[ProductDetail] SET [OriginalQuantity] = [Quantity] WHERE [OriginalQuantity] IS NULL;
UPDATE [dbo].[ProductDetail] SET [CurrentQuantity] = [Quantity] WHERE [CurrentQuantity] IS NULL;
GO

-- 2. Create BlogCategory table and update Blog table
IF OBJECT_ID(N'[dbo].[BlogCategory]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[BlogCategory](
        [IdBlogCat] [int] IDENTITY(1,1) NOT NULL,
        [CategoryName] [nvarchar](100) NOT NULL,
    PRIMARY KEY CLUSTERED ([IdBlogCat] ASC))
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Blog]') AND name = 'IdBlogCat')
    ALTER TABLE [dbo].[Blog] ADD [IdBlogCat] [int] NULL;
GO

-- 3. Create GeneralReview table
IF OBJECT_ID(N'[dbo].[GeneralReview]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[GeneralReview](
        [ReviewId] [int] IDENTITY(1,1) NOT NULL,
        [ReviewType] [nvarchar](50) NOT NULL,
        [IdProduct] [nvarchar](50) NULL,
        [UserId] [int] NOT NULL,
        [ReviewDate] [datetime] DEFAULT (getdate()),
        [ReviewContent] [nvarchar](max) NULL,
        [ReviewTopic] [nvarchar](100) NULL,
        [Ranking] [int] NULL,
        [Status] [nvarchar](50) DEFAULT ('VISIBLE'),
        [ReplyContent] [nvarchar](max) NULL,
        [ReplyDate] [datetime] NULL,
    PRIMARY KEY CLUSTERED ([ReviewId] ASC),
    FOREIGN KEY([UserId]) REFERENCES [dbo].[User] ([UserId]),
    FOREIGN KEY([IdProduct]) REFERENCES [dbo].[ProductDetail] ([IdProduct]))
END
GO

-- 4. Create ReviewImage table
IF OBJECT_ID(N'[dbo].[ReviewImage]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[ReviewImage](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [ReviewId] [int] NOT NULL,
        [ImageUrl] [nvarchar](255) NOT NULL,
        [SortOrder] [int] DEFAULT ((0)),
    PRIMARY KEY CLUSTERED ([Id] ASC),
    FOREIGN KEY([ReviewId]) REFERENCES [dbo].[GeneralReview] ([ReviewId]) ON DELETE CASCADE)
END
GO

-- 5. Create HeroBanner table
IF OBJECT_ID(N'[dbo].[HeroBanner]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[HeroBanner](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [Eyebrow] [nvarchar](100) NULL,
        [Title] [nvarchar](255) NULL,
        [Description] [nvarchar](500) NULL,
        [CtaPrimary] [nvarchar](100) NULL,
        [CtaSecondary] [nvarchar](100) NULL,
        [ImageUrl] [nvarchar](255) NULL,
        [Stat1_Label] [nvarchar](100) NULL,
        [Stat2_Label] [nvarchar](100) NULL,
        [Stat3_Label] [nvarchar](100) NULL,
        [IsActive] [bit] DEFAULT ((1)),
    PRIMARY KEY CLUSTERED ([Id] ASC))
END
GO

-- 6. Create TradeInConfig table
IF OBJECT_ID(N'[dbo].[TradeInConfig]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[TradeInConfig](
        [Id] [int] NOT NULL,
        [Title] [nvarchar](255) NULL,
        [Description] [nvarchar](500) NULL,
        [Note1_Title] [nvarchar](100) NULL,
        [Note1_Desc] [nvarchar](255) NULL,
        [Note2_Title] [nvarchar](100) NULL,
        [Note2_Desc] [nvarchar](255) NULL,
        [Note3_Title] [nvarchar](100) NULL,
        [Note3_Desc] [nvarchar](255) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC))
    
    INSERT INTO [dbo].[TradeInConfig] ([Id], [Title], [Description], [Note1_Title], [Note1_Desc], [Note2_Title], [Note2_Desc], [Note3_Title], [Note3_Desc])
    VALUES (1, N'Trade-in Program', N'Exchange your old device for a new one', N'Step 1', N'Bring your device', N'Step 2', N'Get valuation', N'Step 3', N'Pay difference')
END
GO

-- 7. Create ContactMessages table
IF OBJECT_ID(N'[dbo].[ContactMessages]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[ContactMessages](
        [ContactId] [int] IDENTITY(1,1) NOT NULL,
        [FullName] [nvarchar](100) NOT NULL,
        [Email] [nvarchar](100) NOT NULL,
        [PhoneNumber] [varchar](15) NULL,
        [Subject] [nvarchar](255) NULL,
        [MessageContent] [nvarchar](max) NULL,
        [SentDate] [datetime] DEFAULT (getdate()),
        [Status] [nvarchar](50) DEFAULT ('NEW'),
        [AdminNotes] [nvarchar](max) NULL,
    PRIMARY KEY CLUSTERED ([ContactId] ASC))
END
GO

-- 8. Create UserCart table
IF OBJECT_ID(N'[dbo].[UserCart]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[UserCart](
        [UserId] [int] NOT NULL,
        [IdProduct] [nvarchar](50) NOT NULL,
        [Quantity] [int] NOT NULL CHECK (Quantity > 0),
        [IsReserved] [bit] NOT NULL DEFAULT ((0)),
        [ExpiresAt] [datetime] NULL,
    PRIMARY KEY CLUSTERED ([UserId], [IdProduct]),
    FOREIGN KEY([UserId]) REFERENCES [dbo].[User] ([UserId]),
    FOREIGN KEY([IdProduct]) REFERENCES [dbo].[ProductDetail] ([IdProduct]))
END
GO

-- 9. Create TopProduct table
IF OBJECT_ID(N'[dbo].[TopProduct]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[TopProduct](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [ProductName] [nvarchar](255) NULL,
        [ProductImage] [nvarchar](255) NULL,
        [Price] [decimal](18, 2) NULL,
        [OriginalPrice] [decimal](18, 2) NULL,
        [DisplayOrder] [int] NULL,
        [IsActive] [bit] DEFAULT ((1)),
        [DiscountPercent] [int] DEFAULT ((0)),
    PRIMARY KEY CLUSTERED ([Id] ASC))
END
GO
