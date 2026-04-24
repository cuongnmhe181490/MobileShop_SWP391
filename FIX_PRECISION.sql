USE [MOBILESHOP_DEM05]
GO

-- Increase precision for prices and totals to avoid arithmetic overflow
-- decimal(10, 2) only allows up to 99,999,999.99
-- For iPhone 17 at 40M, buying 3+ units will overflow the TotalPrice.

ALTER TABLE [dbo].[ProductDetail] ALTER COLUMN [Price] DECIMAL(18, 2) NOT NULL;
GO

ALTER TABLE [dbo].[Order] ALTER COLUMN [TotalPrice] DECIMAL(18, 2) NOT NULL;
GO

ALTER TABLE [dbo].[OrderDetail] ALTER COLUMN [UnitPrice] DECIMAL(18, 2) NOT NULL;
GO

PRINT 'Precision fix completed successfully.';
