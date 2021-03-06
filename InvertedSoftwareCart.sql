/****** Object:  Table [dbo].[CustomFieldType]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomFieldType](
	[CustomFieldTypeID] [int] IDENTITY(1,1) NOT NULL,
	[CustomFieldTypeName] [varchar](50) NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_CustomFieldType] PRIMARY KEY CLUSTERED 
(
	[CustomFieldTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[aspnet_WebEvent_Events]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[aspnet_WebEvent_Events](
	[EventId] [char](32) NOT NULL,
	[EventTimeUtc] [datetime] NOT NULL,
	[EventTime] [datetime] NOT NULL,
	[EventType] [nvarchar](256) NOT NULL,
	[EventSequence] [decimal](19, 0) NOT NULL,
	[EventOccurrence] [decimal](19, 0) NOT NULL,
	[EventCode] [int] NOT NULL,
	[EventDetailCode] [int] NOT NULL,
	[Message] [nvarchar](1024) NULL,
	[ApplicationPath] [nvarchar](256) NULL,
	[ApplicationVirtualPath] [nvarchar](256) NULL,
	[MachineName] [nvarchar](256) NOT NULL,
	[RequestUrl] [nvarchar](1024) NULL,
	[ExceptionType] [nvarchar](256) NULL,
	[Details] [ntext] NULL,
PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CouponType]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CouponType](
	[CouponTypeID] [int] IDENTITY(1,1) NOT NULL,
	[CouponTypeName] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_CouponType] PRIMARY KEY CLUSTERED 
(
	[CouponTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Country]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [varchar](50) NOT NULL,
	[CountryCode] [varchar](2) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Category]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[ParentCategoryID] [int] NULL,
	[CategoryName] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Category] UNIQUE NONCLUSTERED 
(
	[CategoryName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Setup_RestorePermissions]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Setup_RestorePermissions]
    @name   sysname
AS
BEGIN
    DECLARE @object sysname
    DECLARE @protectType char(10)
    DECLARE @action varchar(60)
    DECLARE @grantee sysname
    DECLARE @cmd nvarchar(500)
    DECLARE c1 cursor FORWARD_ONLY FOR
        SELECT Object, ProtectType, [Action], Grantee FROM #aspnet_Permissions where Object = @name

    OPEN c1

    FETCH c1 INTO @object, @protectType, @action, @grantee
    WHILE (@@fetch_status = 0)
    BEGIN
        SET @cmd = @protectType + ' ' + @action + ' on ' + @object + ' TO [' + @grantee + ']'
        EXEC (@cmd)
        FETCH c1 INTO @object, @protectType, @action, @grantee
    END

    CLOSE c1
    DEALLOCATE c1
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Setup_RemoveAllRoleMembers]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Setup_RemoveAllRoleMembers]
    @name   sysname
AS
BEGIN
    CREATE TABLE #aspnet_RoleMembers
    (
        Group_name      sysname,
        Group_id        smallint,
        Users_in_group  sysname,
        User_id         smallint
    )

    INSERT INTO #aspnet_RoleMembers
    EXEC sp_helpuser @name

    DECLARE @user_id smallint
    DECLARE @cmd nvarchar(500)
    DECLARE c1 cursor FORWARD_ONLY FOR
        SELECT User_id FROM #aspnet_RoleMembers

    OPEN c1

    FETCH c1 INTO @user_id
    WHILE (@@fetch_status = 0)
    BEGIN
        SET @cmd = 'EXEC sp_droprolemember ' + '''' + @name + ''', ''' + USER_NAME(@user_id) + ''''
        EXEC (@cmd)
        FETCH c1 INTO @user_id
    END

    CLOSE c1
    DEALLOCATE c1
END
GO
/****** Object:  Table [dbo].[aspnet_SchemaVersions]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_SchemaVersions](
	[Feature] [nvarchar](128) NOT NULL,
	[CompatibleSchemaVersion] [nvarchar](128) NOT NULL,
	[IsCurrentVersion] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Feature] ASC,
	[CompatibleSchemaVersion] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aspnet_Applications]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Applications](
	[ApplicationName] [nvarchar](256) NOT NULL,
	[LoweredApplicationName] [nvarchar](256) NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](256) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ApplicationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[LoweredApplicationName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ApplicationName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [aspnet_Applications_Index] ON [dbo].[aspnet_Applications] 
(
	[LoweredApplicationName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InventoryAction]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InventoryAction](
	[InventoryActionID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryActionName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_InventoryAction] PRIMARY KEY CLUSTERED 
(
	[InventoryActionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Product]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [varchar](50) NULL,
	[CatalogNumber] [varchar](50) NULL,
	[Description] [text] NULL,
	[Price] [money] NOT NULL,
	[SalePrice] [money] NOT NULL,
	[Weight] [decimal](18, 0) NULL,
	[ShippingWeight] [decimal](18, 0) NULL,
	[Height] [decimal](18, 0) NULL,
	[ShippingHeight] [decimal](18, 0) NULL,
	[Length] [decimal](18, 0) NULL,
	[ShippingLength] [decimal](18, 0) NULL,
	[Width] [decimal](18, 0) NULL,
	[ShippingWidth] [decimal](18, 0) NULL,
	[ProductLink] [varchar](400) NULL,
	[IsDownloadable] [bit] NOT NULL,
	[IsDownloadKeyRequired] [bit] NULL,
	[IsDownloadKeyUnique] [bit] NULL,
	[DownloadURL] [varchar](400) NULL,
	[IsReviewEnabled] [bit] NOT NULL,
	[TotalReviewCount] [int] NOT NULL,
	[RatingScore] [decimal](18, 0) NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Product] UNIQUE NONCLUSTERED 
(
	[ProductName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Product_1] UNIQUE NONCLUSTERED 
(
	[CatalogNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_Product_2] ON [dbo].[Product] 
(
	[ProductName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderStatus]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrderStatus](
	[OrderStatusID] [int] IDENTITY(1,1) NOT NULL,
	[OrderStatusName] [varchar](50) NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_OrderStatus] PRIMARY KEY CLUSTERED 
(
	[OrderStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductReviewCategory]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductReviewCategory](
	[ProductReviewCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[ProductReviewCategoryName] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_ProductReviewCategory] PRIMARY KEY CLUSTERED 
(
	[ProductReviewCategoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Province]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Province](
	[ProvinceID] [int] IDENTITY(1,1) NOT NULL,
	[ProvinceName] [varchar](50) NOT NULL,
	[ProvinceCode] [varchar](2) NOT NULL,
	[Active] [char](10) NOT NULL,
 CONSTRAINT [PK_Province] PRIMARY KEY CLUSTERED 
(
	[ProvinceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Tag]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tag](
	[TagID] [int] IDENTITY(1,1) NOT NULL,
	[TagName] [varchar](50) NOT NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_Tag] PRIMARY KEY CLUSTERED 
(
	[TagID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StoreConfiguration]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StoreConfiguration](
	[ConfigKey] [varchar](50) NOT NULL,
	[ConfigValue] [varchar](800) NULL,
 CONSTRAINT [PK_StoreConfiguration] PRIMARY KEY CLUSTERED 
(
	[ConfigKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[State]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[State](
	[StateID] [int] IDENTITY(1,1) NOT NULL,
	[StateName] [varchar](50) NOT NULL,
	[StateCode] [varchar](2) NOT NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED 
(
	[StateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 10/27/2011 09:13:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Corey Aldebol
-- Create date: Published: Wednesday, March 10, 2004
-- Description: http://www.4guysfromrolla.com/webtech/031004-1.shtml
-- =============================================
CREATE FUNCTION [dbo].[Split]
(
	@List nvarchar(2000),
	@SplitOn nvarchar(5)
) 
RETURNS @RtnValue table 
( 
	Id int identity(1,1),
	Value nvarchar(100)
) 
AS 
BEGIN
	WHILE (CHARINDEX(@SplitOn,@List)>0)
		BEGIN 
			INSERT INTO @RtnValue (value)
			SELECT Value = ltrim(rtrim(SUBSTRING(@List,1,CHARINDEX(@SplitOn,@List)-1))) 
			SET @List = SUBSTRING(@List,CHARINDEX(@SplitOn,@List)+LEN(@SplitOn),LEN(@List))
		END 
		INSERT INTO @RtnValue (Value)
		SELECT Value = LTRIM(RTRIM(@List))
RETURN
END
GO
/****** Object:  Table [dbo].[ShippingProvider]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ShippingProvider](
	[ShippingProviderID] [int] IDENTITY(1,1) NOT NULL,
	[ShippingProviderName] [varchar](50) NOT NULL,
	[ShippingCost] [money] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_ShippingProvider] PRIMARY KEY CLUSTERED 
(
	[ShippingProviderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_aspnet_Applications]    Script Date: 10/27/2011 09:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_aspnet_Applications]
  AS SELECT [dbo].[aspnet_Applications].[ApplicationName], [dbo].[aspnet_Applications].[LoweredApplicationName], [dbo].[aspnet_Applications].[ApplicationId], [dbo].[aspnet_Applications].[Description]
  FROM [dbo].[aspnet_Applications]
GO
/****** Object:  StoredProcedure [dbo].[UpdateProduct]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateProduct]
	@ProductID int,
    @CatalogNumber varchar(50),
    @ProductName varchar(50),
    @Description varchar(400),
    @Price money,
	@SalePrice money,
	@Weight decimal(18,0),
	@ShippingWeight decimal(18,0),
	@Height decimal(18,0),
	@ShippingHeight decimal(18,0),
	@ProductLink  varchar(400),
	@Length decimal(18,0),
	@ShippingLength decimal(18,0),
	@Width decimal(18,0),
	@ShippingWidth decimal(18,0),
	@IsDownloadable bit,
	@IsDownloadKeyRequired bit,
	@IsDownloadKeyUnique bit,
	@DownloadURL varchar(400),
	@IsReviewEnabled bit,
	@TotalReviewCount int,
	@RatingScore decimal(18,0),
    @Active bit
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE
		Product
	SET
		CatalogNumber = @CatalogNumber,
		ProductName = @ProductName,
		[Description] = @Description,
		Price = @Price,
		SalePrice = @SalePrice,
		[Weight] = @Weight,
		ShippingWeight = @ShippingWeight,
		Height =@Height,
		ShippingHeight = @ShippingHeight,
		[Length] = @Length,
		ShippingLength = @ShippingLength,
		Width = @Width,
		ShippingWidth = @ShippingWidth,
		ProductLink = @ProductLink,
		IsDownloadable = @IsDownloadable,
		IsDownloadKeyRequired = @IsDownloadKeyRequired,
		IsDownloadKeyUnique = @IsDownloadKeyUnique,
		DownloadURL = @DownloadURL,
		IsReviewEnabled = @IsReviewEnabled,
		TotalReviewCount = @TotalReviewCount,
		RatingScore = @RatingScore,
		Active = @Active
	WHERE
		ProductID = @ProductID
END
GO
/****** Object:  Table [dbo].[Tax]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tax](
	[TaxID] [int] IDENTITY(1,1) NOT NULL,
	[TaxName] [varchar](50) NOT NULL,
	[Fixed] [bit] NOT NULL,
	[Amount] [decimal](18, 3) NULL,
	[IsAfterShipping] [bit] NOT NULL,
	[CountryID] [int] NOT NULL,
	[StateID] [int] NULL,
	[ProvinceID] [int] NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Tax] PRIMARY KEY CLUSTERED 
(
	[TaxID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RelatedProduct]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RelatedProduct](
	[RelatedProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductOneID] [int] NOT NULL,
	[ProductTwoID] [int] NOT NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_RelatedProduct] PRIMARY KEY CLUSTERED 
(
	[RelatedProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Shipping]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shipping](
	[ShippingID] [int] IDENTITY(1,1) NOT NULL,
	[CountryID] [int] NOT NULL,
	[StateID] [int] NULL,
	[ProvinceID] [int] NULL,
	[ProductID] [int] NOT NULL,
	[ShippingProviderID] [int] NOT NULL,
	[Rate] [money] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Shipping] PRIMARY KEY CLUSTERED 
(
	[ShippingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[SetStoreConfiguration]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetStoreConfiguration]
	@ConfigKey VARCHAR(50),
	@ConfigValue VARCHAR(800)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF EXISTS(SELECT 1 FROM StoreConfiguration WITH(NOLOCK) WHERE ConfigKey = @ConfigKey)
		BEGIN
			UPDATE
				StoreConfiguration
			SET
				ConfigValue = @ConfigValue
			WHERE
				ConfigKey = @ConfigKey
		END
	ELSE
		BEGIN
			INSERT INTO StoreConfiguration(
				ConfigKey,
				ConfigValue
			) VALUES(
				@ConfigKey,
				@ConfigValue
			)	
		END
END
GO
/****** Object:  Table [dbo].[ProductOption]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductOption](
	[ProductOptionID] [int] IDENTITY(1,1) NOT NULL,
	[ProductOptionName] [varchar](50) NOT NULL,
	[ProductOptionGroup] [varchar](50) NOT NULL,
	[ProductID] [int] NOT NULL,
	[PriceChange] [money] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_ProductOption] PRIMARY KEY CLUSTERED 
(
	[ProductOptionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductDownloadKey]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductDownloadKey](
	[ProductDownloadKeyID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[DownloadKey] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_DownloadKey] PRIMARY KEY CLUSTERED 
(
	[ProductDownloadKeyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductCategory]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductCategory](
	[ProductCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_ProductCategory] PRIMARY KEY CLUSTERED 
(
	[ProductCategoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductTag]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductTag](
	[ProductTagID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[TagID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_ProductTag] PRIMARY KEY CLUSTERED 
(
	[ProductTagID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetProvinces]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProvinces]
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		ProvinceID,
		ProvinceName
	FROM
		Province WITH(NOLOCK)
	WHERE
		Active = @Active
    ORDER BY
		ProvinceName
END
GO
/****** Object:  StoredProcedure [dbo].[GetProvinceCode]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProvinceCode] 
	@ProvinceID int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		ProvinceCode
	FROM
		Province WITH(NOLOCK)
	WHERE
		ProvinceID = @ProvinceID
END
GO
/****** Object:  StoredProcedure [dbo].[GetOrderStatus]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOrderStatus]
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		OrderStatusID
		OrderStatusName
	FROM
		OrderStatus WITH(NOLOCK)
	WHERE
		Active = @Active
    ORDER BY
		OrderStatusName
END
GO
/****** Object:  StoredProcedure [dbo].[GetProductReviewCategories]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProductReviewCategories]
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		ProductReviewCategoryID,
		ProductReviewCategoryName
	FROM
		ProductReviewCategory WITH(NOLOCK)
	WHERE
		Active = @Active
    ORDER BY
		ProductReviewCategoryName
END
GO
/****** Object:  StoredProcedure [dbo].[GetTags]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTags]
	@Active bit = 1
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT
		TagName
	FROM
		Tag WITH(NOLOCK)
	WHERE
		Active = @Active
END
GO
/****** Object:  StoredProcedure [dbo].[GetStoreConfiguration]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetStoreConfiguration] 
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT
		ConfigKey,
		ConfigValue
	FROM
		StoreConfiguration WITH(NOLOCK)
END
GO
/****** Object:  StoredProcedure [dbo].[GetStates]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetStates]
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		StateID,
		StateName
	FROM
		State WITH(NOLOCK)
	WHERE
		Active = @Active
    ORDER BY
		StateName
END
GO
/****** Object:  StoredProcedure [dbo].[GetStateCode]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetStateCode] 
	@StateID int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		StateCode
	FROM
		State WITH(NOLOCK)
	WHERE
		StateID = @StateID
END
GO
/****** Object:  StoredProcedure [dbo].[GetShippingPoviders]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GetShippingPoviders]
	@Active bit = 1
AS

SELECT
	ShippingProviderID,
	ShippingProviderName,
	ShippingCost
FROM  
	ShippingProvider WITH(NOLOCK)
WHERE
	Active = @Active
ORDER BY
	ShippingProviderName
GO
/****** Object:  StoredProcedure [dbo].[GetShippingCosts]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetShippingCosts]
	@ShippingProviderID int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		ShippingCost
	FROM  
		ShippingProvider WITH(NOLOCK)
	WHERE
		ShippingProviderID = @ShippingProviderID
END
GO
/****** Object:  Table [dbo].[Inventory]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inventory](
	[InventoryID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryActionID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductAmountInStock] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Inventory] PRIMARY KEY CLUSTERED 
(
	[InventoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Image]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Image](
	[ImageID] [int] IDENTITY(1,1) NOT NULL,
	[ParentID] [int] NULL,
	[ProductID] [int] NOT NULL,
	[SortOrder] [int] NULL,
	[ImageName] [varchar](200) NULL,
	[ImageURL] [varchar](200) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Image] PRIMARY KEY CLUSTERED 
(
	[ImageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Order]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Order](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[OrderNumber] [varchar](50) NULL,
	[OrderDate] [datetime] NULL,
	[OrderStatusID] [int] NULL,
	[ShippingProviderID] [int] NULL,
	[ShippingNumber] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[StateID] [int] NULL,
	[ProvinceID] [int] NULL,
	[CountryID] [int] NULL,
	[Zipcode] [varchar](50) NULL,
	[Comments] [varchar](400) NULL,
	[DatePlaced] [datetime] NULL,
	[DateShipped] [datetime] NULL,
	[Total] [money] NULL,
	[Shipping] [money] NULL,
	[Tax] [money] NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[aspnet_Paths]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Paths](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[PathId] [uniqueidentifier] NOT NULL,
	[Path] [nvarchar](256) NOT NULL,
	[LoweredPath] [nvarchar](256) NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[PathId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [aspnet_Paths_index] ON [dbo].[aspnet_Paths] 
(
	[ApplicationId] ASC,
	[LoweredPath] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Personalization_GetApplicationId]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Personalization_GetApplicationId] (
    @ApplicationName NVARCHAR(256),
    @ApplicationId UNIQUEIDENTIFIER OUT)
AS
BEGIN
    SELECT @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_CheckSchemaVersion]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_CheckSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128)
AS
BEGIN
    IF (EXISTS( SELECT  *
                FROM    dbo.aspnet_SchemaVersions
                WHERE   Feature = LOWER( @Feature ) AND
                        CompatibleSchemaVersion = @CompatibleSchemaVersion ))
        RETURN 0

    RETURN 1
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Applications_CreateApplication]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Applications_CreateApplication]
    @ApplicationName      nvarchar(256),
    @ApplicationId        uniqueidentifier OUTPUT
AS
BEGIN
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName

    IF(@ApplicationId IS NULL)
    BEGIN
        DECLARE @TranStarted   bit
        SET @TranStarted = 0

        IF( @@TRANCOUNT = 0 )
        BEGIN
	        BEGIN TRANSACTION
	        SET @TranStarted = 1
        END
        ELSE
    	    SET @TranStarted = 0

        SELECT  @ApplicationId = ApplicationId
        FROM dbo.aspnet_Applications WITH (UPDLOCK, HOLDLOCK)
        WHERE LOWER(@ApplicationName) = LoweredApplicationName

        IF(@ApplicationId IS NULL)
        BEGIN
            SELECT  @ApplicationId = NEWID()
            INSERT  dbo.aspnet_Applications (ApplicationId, ApplicationName, LoweredApplicationName)
            VALUES  (@ApplicationId, @ApplicationName, LOWER(@ApplicationName))
        END


        IF( @TranStarted = 1 )
        BEGIN
            IF(@@ERROR = 0)
            BEGIN
	        SET @TranStarted = 0
	        COMMIT TRANSACTION
            END
            ELSE
            BEGIN
                SET @TranStarted = 0
                ROLLBACK TRANSACTION
            END
        END
    END
END
GO
/****** Object:  StoredProcedure [dbo].[AddCategory]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddCategory]
	@ParentCategoryID int,
    @CategoryName varchar(50),
    @Active bit
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO Category(
		ParentCategoryID,
        CategoryName,
        Active
    )VALUES(
		@ParentCategoryID,
        @CategoryName,
        @Active)

	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddProduct]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddProduct]
    @CatalogNumber varchar(50),
    @ProductName varchar(50),
    @Description varchar(400),
    @Price money,
	@SalePrice money,
	@Weight decimal(18,0),
	@ShippingWeight decimal(18,0),
	@Height decimal(18,0),
	@ShippingHeight decimal(18,0),
	@Length decimal(18,0),
	@ShippingLength decimal(18,0),
	@Width decimal(18,0),
	@ShippingWidth decimal(18,0),
	@ProductLink varchar(400),
	@IsDownloadable bit,
	@IsDownloadKeyRequired bit,
	@IsDownloadKeyUnique bit,
	@DownloadURL varchar(400),
	@IsReviewEnabled bit,
	@TotalReviewCount int,
	@RatingScore decimal(18,0),
    @Active bit
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO Product(
		CatalogNumber,
		ProductName,
		Description,
		Price,
		SalePrice,
		[Weight],
		ShippingWeight,
		Height,
		ShippingHeight,
		[Length],
		ShippingLength,
		Width,
		ShippingWidth,
		ProductLink,
		IsDownloadable,
		IsDownloadKeyRequired,
		IsDownloadKeyUnique,
		DownloadURL,
		IsReviewEnabled,
		TotalReviewCount,
		RatingScore,
		Active
    )VALUES(
		@CatalogNumber,
		@ProductName,
		@Description,
		@Price,
		@SalePrice,
		@Weight,
		@ShippingWeight,
		@Height,
		@ShippingHeight,
		@Length,
		@ShippingLength,
		@Width,
		@ShippingWidth,
		@ProductLink,
		@IsDownloadable,
		@IsDownloadKeyRequired,
		@IsDownloadKeyUnique,
		@DownloadURL,
		@IsReviewEnabled,
		@TotalReviewCount,
		@RatingScore,
		@Active)
END
GO
/****** Object:  Table [dbo].[aspnet_Users]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Users](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[LoweredUserName] [nvarchar](256) NOT NULL,
	[MobileAlias] [nvarchar](16) NULL,
	[IsAnonymous] [bit] NOT NULL,
	[LastActivityDate] [datetime] NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [aspnet_Users_Index] ON [dbo].[aspnet_Users] 
(
	[ApplicationId] ASC,
	[LoweredUserName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [aspnet_Users_Index2] ON [dbo].[aspnet_Users] 
(
	[ApplicationId] ASC,
	[LastActivityDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UnRegisterSchemaVersion]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_UnRegisterSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128)
AS
BEGIN
    DELETE FROM dbo.aspnet_SchemaVersions
        WHERE   Feature = LOWER(@Feature) AND @CompatibleSchemaVersion = CompatibleSchemaVersion
END
GO
/****** Object:  Table [dbo].[aspnet_Roles]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Roles](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[RoleName] [nvarchar](256) NOT NULL,
	[LoweredRoleName] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](256) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [aspnet_Roles_index1] ON [dbo].[aspnet_Roles] 
(
	[ApplicationId] ASC,
	[LoweredRoleName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[aspnet_RegisterSchemaVersion]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_RegisterSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128),
    @IsCurrentVersion          bit,
    @RemoveIncompatibleSchema  bit
AS
BEGIN
    IF( @RemoveIncompatibleSchema = 1 )
    BEGIN
        DELETE FROM dbo.aspnet_SchemaVersions WHERE Feature = LOWER( @Feature )
    END
    ELSE
    BEGIN
        IF( @IsCurrentVersion = 1 )
        BEGIN
            UPDATE dbo.aspnet_SchemaVersions
            SET IsCurrentVersion = 0
            WHERE Feature = LOWER( @Feature )
        END
    END

    INSERT  dbo.aspnet_SchemaVersions( Feature, CompatibleSchemaVersion, IsCurrentVersion )
    VALUES( LOWER( @Feature ), @CompatibleSchemaVersion, @IsCurrentVersion )
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_WebEvent_LogEvent]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_WebEvent_LogEvent]
        @EventId         char(32),
        @EventTimeUtc    datetime,
        @EventTime       datetime,
        @EventType       nvarchar(256),
        @EventSequence   decimal(19,0),
        @EventOccurrence decimal(19,0),
        @EventCode       int,
        @EventDetailCode int,
        @Message         nvarchar(1024),
        @ApplicationPath nvarchar(256),
        @ApplicationVirtualPath nvarchar(256),
        @MachineName    nvarchar(256),
        @RequestUrl      nvarchar(1024),
        @ExceptionType   nvarchar(256),
        @Details         ntext
AS
BEGIN
    INSERT
        dbo.aspnet_WebEvent_Events
        (
            EventId,
            EventTimeUtc,
            EventTime,
            EventType,
            EventSequence,
            EventOccurrence,
            EventCode,
            EventDetailCode,
            Message,
            ApplicationPath,
            ApplicationVirtualPath,
            MachineName,
            RequestUrl,
            ExceptionType,
            Details
        )
    VALUES
    (
        @EventId,
        @EventTimeUtc,
        @EventTime,
        @EventType,
        @EventSequence,
        @EventOccurrence,
        @EventCode,
        @EventDetailCode,
        @Message,
        @ApplicationPath,
        @ApplicationVirtualPath,
        @MachineName,
        @RequestUrl,
        @ExceptionType,
        @Details
    )
END
GO
/****** Object:  Table [dbo].[Coupon]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Coupon](
	[CouponID] [int] IDENTITY(1,1) NOT NULL,
	[CouponTypeID] [int] NOT NULL,
	[ProductID] [int] NULL,
	[CouponCode] [varchar](200) NOT NULL,
	[CouponDescription] [varchar](200) NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[IsCouponUnique] [bit] NOT NULL,
	[IsCanBeCombined] [bit] NOT NULL,
	[IssuedDate] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Coupon] PRIMARY KEY CLUSTERED 
(
	[CouponID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[GetCountryCode]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCountryCode] 
	@CountryID int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		CountryCode
	FROM
		Country WITH(NOLOCK)
	WHERE
		CountryID = @CountryID
END
GO
/****** Object:  StoredProcedure [dbo].[GetCountries]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCountries]
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		CountryID,
		CountryName
	FROM
		Country WITH(NOLOCK)
	WHERE
		Active = @Active
    ORDER BY
		CountryName
END
GO
/****** Object:  StoredProcedure [dbo].[GetCategory]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GetCategory]
	@CategoryID int,
	@Active bit
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		CategoryID,
		ParentCategoryID,
		CategoryName,
		Active
	FROM  
		Category WITH(NOLOCK)
	WHERE
		CategoryID =  @CategoryID AND
		Active = @Active
END
GO
/****** Object:  StoredProcedure [dbo].[GetCategories]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GetCategories]
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		CategoryID,
		ParentCategoryID,
		CategoryName
	FROM  
		Category WITH(NOLOCK)
	WHERE
		Active = @Active
	ORDER BY
		CategoryName
END
GO
/****** Object:  Table [dbo].[FeaturedProduct]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FeaturedProduct](
	[FeaturedProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[CategoryID] [int] NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_FeaturedProduct] PRIMARY KEY CLUSTERED 
(
	[FeaturedProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomField]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomField](
	[CustomFieldID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[CustomFieldName] [varchar](50) NOT NULL,
	[CustomFieldTypeID] [int] NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_CustomField] PRIMARY KEY CLUSTERED 
(
	[CustomFieldID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[MemberID] [uniqueidentifier] NOT NULL,
	[Company] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[StateID] [int] NULL,
	[ProvinceID] [int] NULL,
	[CountryID] [int] NULL,
	[Zipcode] [varchar](50) NULL,
	[DayPhone] [varchar](50) NULL,
	[EveningPhone] [varchar](50) NULL,
	[CellPhone] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[Email] [varchar](50) NOT NULL,
	[DateCreated] [datetime] NULL,
	[DateUpdated] [datetime] NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Customer] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[DeactivateCoupon]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeactivateCoupon] 
	@CouponID int
AS
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE Coupon
	SET Active = 0
	WHERE CouponID = @CouponID
END
GO
/****** Object:  StoredProcedure [dbo].[GetCoupon]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCoupon] 
	@CouponCode varchar(200)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT
		CouponID,
		CouponTypeID,
		ProductID,
		CouponCode,
		CouponDescription,
		Amount,
		IsCouponUnique,
		IsCanBeCombined,
		IssuedDate,
		ExpirationDate,
		Active
	FROM
		Coupon WITH(NOLOCK)
	WHERE
		CouponCode = @CouponCode AND
		Active = 1
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Roles_CreateRole]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Roles_CreateRole]
    @ApplicationName  nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
        BEGIN TRANSACTION
        SET @TranStarted = 1
    END
    ELSE
        SET @TranStarted = 0

    EXEC dbo.aspnet_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF (EXISTS(SELECT RoleId FROM dbo.aspnet_Roles WHERE LoweredRoleName = LOWER(@RoleName) AND ApplicationId = @ApplicationId))
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    INSERT INTO dbo.aspnet_Roles
                (ApplicationId, RoleName, LoweredRoleName)
         VALUES (@ApplicationId, @RoleName, LOWER(@RoleName))

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        COMMIT TRANSACTION
    END

    RETURN(0)

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerOrders]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GetCustomerOrders]
	@CustomerID int,
	@PageIndex int,
    @PageSize int,
	@Active bit = 1
AS
BEGIN

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForCustomerOrders
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        OrderID int
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForCustomerOrders (OrderID)
    SELECT
		OrderID
    FROM
		[OrderID]
	WHERE
		CustomerID = @CustomerID

	SELECT
		OrderID,
		CustomerID,
		OrderNumber,
		OrderDate,
		OrderStatusID,
		ShippingProviderID,
		Address,
		City,
		StateID,
		CountryID,
		Zipcode,
		DatePlaced,
		DateShipped,
		Total,
		Shipping,
		Tax,
		Active
	FROM
		[Order],
		#PageIndexForCustomerOrders i
	WHERE
		Active = @Active AND
		i.IndexId >= @PageLowerBound AND 
		i.IndexId <= @PageUpperBound
	ORDER BY
		OrderDate DESC
	
	RETURN @TotalRecords

    DROP TABLE #PageIndexForCustomerOrders
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Users_CreateUser]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Users_CreateUser]
    @ApplicationId    uniqueidentifier,
    @UserName         nvarchar(256),
    @IsUserAnonymous  bit,
    @LastActivityDate DATETIME,
    @UserId           uniqueidentifier OUTPUT
AS
BEGIN
    IF( @UserId IS NULL )
        SELECT @UserId = NEWID()
    ELSE
    BEGIN
        IF( EXISTS( SELECT UserId FROM dbo.aspnet_Users
                    WHERE @UserId = UserId ) )
            RETURN -1
    END

    INSERT dbo.aspnet_Users (ApplicationId, UserId, UserName, LoweredUserName, IsAnonymous, LastActivityDate)
    VALUES (@ApplicationId, @UserId, @UserName, LOWER(@UserName), @IsUserAnonymous, @LastActivityDate)

    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Roles_RoleExists]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Roles_RoleExists]
    @ApplicationName  nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(0)
    IF (EXISTS (SELECT RoleName FROM dbo.aspnet_Roles WHERE LOWER(@RoleName) = LoweredRoleName AND ApplicationId = @ApplicationId ))
        RETURN(1)
    ELSE
        RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Roles_GetAllRoles]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Roles_GetAllRoles] (
    @ApplicationName           nvarchar(256))
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN
    SELECT RoleName
    FROM   dbo.aspnet_Roles WHERE ApplicationId = @ApplicationId
    ORDER BY RoleName
END
GO
/****** Object:  Table [dbo].[aspnet_UsersInRoles]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_UsersInRoles](
	[UserId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [aspnet_UsersInRoles_index] ON [dbo].[aspnet_UsersInRoles] 
(
	[RoleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aspnet_Membership]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Membership](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordFormat] [int] NOT NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[MobilePIN] [nvarchar](16) NULL,
	[Email] [nvarchar](256) NULL,
	[LoweredEmail] [nvarchar](256) NULL,
	[PasswordQuestion] [nvarchar](256) NULL,
	[PasswordAnswer] [nvarchar](128) NULL,
	[IsApproved] [bit] NOT NULL,
	[IsLockedOut] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastLoginDate] [datetime] NOT NULL,
	[LastPasswordChangedDate] [datetime] NOT NULL,
	[LastLockoutDate] [datetime] NOT NULL,
	[FailedPasswordAttemptCount] [int] NOT NULL,
	[FailedPasswordAttemptWindowStart] [datetime] NOT NULL,
	[FailedPasswordAnswerAttemptCount] [int] NOT NULL,
	[FailedPasswordAnswerAttemptWindowStart] [datetime] NOT NULL,
	[Comment] [ntext] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [aspnet_Membership_index] ON [dbo].[aspnet_Membership] 
(
	[ApplicationId] ASC,
	[LoweredEmail] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[AddOrder]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddOrder]
	@CustomerID int,
    @OrderNumber varchar(50),
    @OrderDate datetime,
    @OrderStatusID int,
    @ShippingProviderID int = NULL,
    @Address varchar(50),
    @City varchar(50),
    @StateID int = null,
	@ProvinceID int = null,
    @CountryID int,
    @Zipcode varchar(50),
	@Comments varchar(50) = null,
    @DatePlaced datetime,
    @DateShipped datetime = null,
    @Total money,
    @Shipping money,
    @Tax money,
    @Active bit
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [Order](
		CustomerID,
        OrderNumber,
        OrderDate,
        OrderStatusID,
        ShippingProviderID,
        Address,
        City,
        StateID,
		ProvinceID,
        CountryID,
        Zipcode,
		Comments,
        DatePlaced,
        DateShipped,
        Total,
        Shipping,
        Tax,
        Active
	)VALUES(
		@CustomerID,
		@OrderNumber,
		@OrderDate,
		@OrderStatusID,
		@ShippingProviderID,
		@Address,
		@City,
		@StateID,
		@ProvinceID,
		@CountryID,
		@Zipcode,
		@Comments,
		@DatePlaced,
		@DateShipped,
		@Total,
		@Shipping,
		@Tax,
		@Active)
	
	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddImage]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddImage] 
	@ProductID int,
	@ParentID int = NULL,
    @SortOrder int,
    @ImageName varchar(200),
    @ImageURL varchar(200),
	@Active bit
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [Image](
		ProductID,
		ParentID,
        SortOrder,
        ImageName,
        ImageURL,
        Active
     )VALUES(
		@ProductID,
		@ParentID,
        @SortOrder,
        @ImageName,
        @ImageURL,
		@Active)
	
	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddFeaturedProduct]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddFeaturedProduct] 
	@ProductID int,
    @CategoryID int,
    @Active bit
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO FeaturedProduct(
        ProductID,
		CategoryID,
        Active
     )VALUES(
		@ProductID,
		@CategoryID,
		@Active)
	
	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddRelatedProduct]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddRelatedProduct] 
	@ProductOneID int,
    @ProductTwoID int,
    @Active bit
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO RelatedProduct(
        ProductOneID,
		ProductTwoID,
        Active
     )VALUES(
		@ProductOneID,
		@ProductTwoID,
		@Active)
	
	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddProductCategory]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddProductCategory]
	@CategoryID int,
    @ProductID int,
    @Active bit
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO ProductCategory(
		CategoryID,
        ProductID,
        Active
    )VALUES(
		@CategoryID,
        @ProductID,
        @Active)

	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Paths_CreatePath]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Paths_CreatePath]
    @ApplicationId UNIQUEIDENTIFIER,
    @Path           NVARCHAR(256),
    @PathId         UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    BEGIN TRANSACTION
    IF (NOT EXISTS(SELECT * FROM dbo.aspnet_Paths WHERE LoweredPath = LOWER(@Path) AND ApplicationId = @ApplicationId))
    BEGIN
        INSERT dbo.aspnet_Paths (ApplicationId, Path, LoweredPath) VALUES (@ApplicationId, @Path, LOWER(@Path))
    END
    COMMIT TRANSACTION
    SELECT @PathId = PathId FROM dbo.aspnet_Paths WHERE LOWER(@Path) = LoweredPath AND ApplicationId = @ApplicationId
END
GO
/****** Object:  Table [dbo].[aspnet_PersonalizationAllUsers]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_PersonalizationAllUsers](
	[PathId] [uniqueidentifier] NOT NULL,
	[PageSettings] [image] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PathId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aspnet_PersonalizationPerUser]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_PersonalizationPerUser](
	[Id] [uniqueidentifier] NOT NULL,
	[PathId] [uniqueidentifier] NULL,
	[UserId] [uniqueidentifier] NULL,
	[PageSettings] [image] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [aspnet_PersonalizationPerUser_index1] ON [dbo].[aspnet_PersonalizationPerUser] 
(
	[PathId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [aspnet_PersonalizationPerUser_ncindex2] ON [dbo].[aspnet_PersonalizationPerUser] 
(
	[UserId] ASC,
	[PathId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aspnet_Profile]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Profile](
	[UserId] [uniqueidentifier] NOT NULL,
	[PropertyNames] [ntext] NOT NULL,
	[PropertyValuesString] [ntext] NOT NULL,
	[PropertyValuesBinary] [image] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderProduct]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrderProduct](
	[OrderProductID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[PricePerUnit] [money] NOT NULL,
	[TotalPrice] [money] NOT NULL,
	[Discount] [money] NULL,
	[Shipping] [money] NULL,
	[DownloadKey] [varchar](50) NULL,
	[DownloadURL] [varchar](400) NULL,
	[OrderDate] [datetime] NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_OrderProduct] PRIMARY KEY CLUSTERED 
(
	[OrderProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[IsProductOptionsExist]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IsProductOptionsExist] 
	@ProductID int,
	@Active bit = 1
AS
BEGIN
	
	SET NOCOUNT ON;

    IF EXISTS(SELECT 1 FROM ProductOption WHERE ProductID = @ProductID AND Active = @Active)
		BEGIN
			SELECT 1
		END
	ELSE
		BEGIN
			SELECT 0
		END	
END
GO
/****** Object:  StoredProcedure [dbo].[GetRelatedProducts]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRelatedProducts]
	@ProductID int,
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		rp.RelatedProductID,
		rp.ProductTwoID AS ProductID,
		p.ProductName,
		(SELECT TOP 1 ImageURL FROM [Image] WITH(NOLOCK) WHERE ProductID = ProductTwoID AND ParentID IS NOT NULL) AS Thumbnail,
		rp.Active
	FROM
		RelatedProduct rp WITH(NOLOCK) INNER JOIN Product p WITH(NOLOCK) ON
		rp.ProductTwoID = p.ProductID
	WHERE
		rp.ProductOneID = @ProductID AND
		rp.Active = @Active AND
		P.Active = @Active

	UNION
	
	SELECT
		rp.RelatedProductID,
		rp.ProductOneID AS ProductID,
		p.ProductName,
		(SELECT TOP 1 ImageURL FROM [Image] WITH(NOLOCK) WHERE ProductID = ProductOneID AND ParentID IS NOT NULL) AS Thumbnail,
		rp.Active
	FROM
		RelatedProduct rp WITH(NOLOCK) INNER JOIN Product p WITH(NOLOCK) ON
		rp.ProductOneID = p.ProductID
	WHERE
		rp.ProductTwoID = @ProductID AND
		rp.Active = @Active AND
		P.Active = @Active
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetTaxes]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTaxes]
	@CountryID int,
	@StateID int = null,
	@ProvinceID int = null
AS
BEGIN
	SET NOCOUNT ON;
	IF @StateID IS NOT NULL
		BEGIN
			SELECT
				TaxID,
				TaxName,
				Fixed,
				Amount,
				IsAfterShipping,
				CountryID,
				StateID,
				ProvinceID,
				Active
			FROM
				Tax WITH(NOLOCK)
			WHERE
				CountryID = @CountryID AND
				StateID = @StateID AND
				Active = 1
		END
	ELSE IF @ProvinceID IS NOT NULL
		BEGIN
			SELECT
				TaxID,
				TaxName,
				Fixed,
				Amount,
				IsAfterShipping,
				CountryID,
				StateID,
				ProvinceID,
				Active
			FROM
				Tax WITH(NOLOCK)
			WHERE
				CountryID = @CountryID AND
				ProvinceID = @ProvinceID AND
				Active = 1
		END
	ELSE
		BEGIN
			SELECT
				TaxID,
				TaxName,
				Fixed,
				Amount,
				IsAfterShipping,
				CountryID,
				StateID,
				ProvinceID,
				Active
			FROM
				Tax WITH(NOLOCK)
			WHERE
				CountryID = @CountryID AND
				Active = 1
		END
		
		
END
GO
/****** Object:  StoredProcedure [dbo].[GetProductOptions]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProductOptions] 
	@ProductID int,
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		ProductOptionID,
		ProductOptionName,
		ProductOptionGroup,
		ProductID,
		PriceChange,
		Active
	FROM
		ProductOption WITH(NOLOCK)
	WHERE
		ProductID = @ProductID AND
		Active = @Active
END
GO
/****** Object:  StoredProcedure [dbo].[GetOrder]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOrder] 
	@OrderID int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 
		OrderID,
		CustomerID,
		OrderNumber,
		OrderDate,
		OrderStatusID,
		ShippingProviderID,
		Address,
		City,
		StateID,
		CountryID,
		Zipcode,
		DatePlaced,
		DateShipped,
		Total,
		Shipping,
		Tax,
		Active
	FROM
		[Order] WITH(NOLOCK)
	WHERE
		OrderID = @OrderID
END
GO
/****** Object:  StoredProcedure [dbo].[GetNextProductKey]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetNextProductKey] 
	@ProductID int,
	@IsExpireKey bit
AS
BEGIN
	
	SET NOCOUNT ON;
	IF @IsExpireKey = 1
		BEGIN
			DECLARE @DownloadKeyVar table(
				DownloadKey varchar(50) NULL
			);

			UPDATE TOP (1)
				ProductDownloadKey
			SET 
				Active = 0
			OUTPUT inserted.DownloadKey
			INTO @DownloadKeyVar
			WHERE
				ProductID = @ProductID AND
				Active = 1
			
			SELECT TOP 1 DownloadKey FROM @DownloadKeyVar
		END
	ELSE
		BEGIN
			SELECT TOP 1
				DownloadKey
			FROM
				ProductDownloadKey WITH(NOLOCK)
			WHERE
				ProductID = @ProductID AND
				Active = 1
		END
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetImage]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetImage]
	@ImageID int = NULL,
	@ParentID int = NULL,
	@ProductID int = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @ImageID IS NOT NULL AND @ParentID IS NULL AND @ProductID IS NULL
		BEGIN
			SELECT
				ImageID,
				ParentID,
				ProductID,
				SortOrder,
				ImageName,
				ImageURL,
				Active
			FROM
				[Image] WITH(NOLOCK)
			WHERE
				ImageID = @ImageID
		END
	ELSE IF @ImageID IS NULL AND @ParentID IS NOT NULL AND @ProductID IS NULL
		BEGIN
			SELECT
				ImageID,
				ParentID,
				ProductID,
				SortOrder,
				ImageName,
				ImageURL,
				Active
			FROM
				[Image] WITH(NOLOCK)
			WHERE
				ParentID = @ParentID
		END
	ELSE IF @ImageID IS NULL AND @ParentID IS NULL AND @ProductID IS NOT NULL
		BEGIN
			SELECT
				ImageID,
				ParentID,
				ProductID,
				SortOrder,
				ImageName,
				ImageURL,
				Active
			FROM
				[Image] WITH(NOLOCK)
			WHERE
				ProductID = @ProductID
		END

END
GO
/****** Object:  StoredProcedure [dbo].[GetOrders]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GetOrders]
	@OrderStatusID int = NULL,
	@CustomerID int = NULL,
	@StartDate datetime,
	@EndDate datetime,
	@PageIndex int,
    @PageSize int,
	@Active bit = 1
AS
BEGIN

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForCustomerOrders
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        OrderID int
    )

    -- Insert into our temp table
	IF @OrderStatusID IS NOT NULL AND @CustomerID IS NULL
		BEGIN
			INSERT INTO #PageIndexForCustomerOrders (OrderID)
			SELECT
				OrderID
			FROM
				[Order]
			WHERE
				OrderStatusID = @OrderStatusID AND
				(OrderDate BETWEEN @StartDate AND @EndDate)

			SELECT @TotalRecords = @@ROWCOUNT
		END
	ELSE IF @OrderStatusID IS NULL AND @CustomerID IS NOT NULL
		BEGIN
			INSERT INTO #PageIndexForCustomerOrders (OrderID)
			SELECT
				OrderID
			FROM
				[Order]
			WHERE
				CustomerID = @CustomerID AND
				(OrderDate BETWEEN @StartDate AND @EndDate)

			SELECT @TotalRecords = @@ROWCOUNT
		END

	SELECT
		O.OrderID,
		O.CustomerID,
		O.OrderNumber,
		O.OrderDate,
		O.OrderStatusID,
		(Select OrderStatusName FROM OrderStatus WHERE OrderStatusID = O.OrderStatusID) AS OrderStatusName,
		O.ShippingProviderID,
		(Select ShippingProviderName FROM ShippingProvider WHERE ShippingProviderID = O.ShippingProviderID) AS ShippingProviderName,
		O.ShippingNumber,
		O.Address,
		O.City,
		O.StateID,
		(Select StateName FROM State WHERE StateID = O.StateID) AS StateName,
		O.ProvinceID,
		(Select ProvinceName FROM Province WHERE ProvinceID = O.ProvinceID) AS ProvinceName,
		O.CountryID,
		(Select CountryName FROM Country WHERE CountryID = O.CountryID) AS CountryName,
		O.Zipcode,
		O.DatePlaced,
		O.DateShipped,
		O.Total,
		O.Shipping,
		O.Tax,
		O.Active
	FROM
		[Order] O INNER JOIN #PageIndexForCustomerOrders i ON
		O.OrderID = i.OrderID
	WHERE
		O.Active = @Active AND
		i.IndexId >= @PageLowerBound AND 
		i.IndexId <= @PageUpperBound
	ORDER BY
		OrderDate DESC
	
	RETURN @TotalRecords

    DROP TABLE #PageIndexForOrders
END
GO
/****** Object:  StoredProcedure [dbo].[GetProductShipping]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProductShipping] 
	@CountryID int,
    @StateID int = null,
    @ProvinceID int = null,
    @ProductID int,
    @ShippingProviderID int,
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		Rate
	FROM
		Shipping WITH(NOLOCK)
	WHERE
		CountryID = @CountryID AND
		(StateID = @StateID OR StateID IS NULL) AND
		(ProvinceID = @ProvinceID OR ProvinceID IS NULL) AND
		ProductID = @ProductID AND
		ShippingProviderID = @ShippingProviderID AND
		Active = @Active
END
GO
/****** Object:  StoredProcedure [dbo].[GetProductsByTag]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GetProductsByTag]
	@PageIndex int,
    @PageSize int,
    @TagName varchar(200) = NULL,
	@Active bit = 1
AS
BEGIN

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForProducts
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        ProductID int
    )

	INSERT INTO #PageIndexForProducts (ProductID)
	SELECT DISTINCT
		P.ProductID
	FROM
		Product p INNER JOIN ProductTag pt ON
		p.ProductID = pt.ProductID
		INNER JOIN Tag t ON
		pt.TagID = t.TagID
	WHERE
		p.Active = @Active AND
		pt.Active = @Active AND
		t.Active = @Active AND
		t.TagName = @TagName


	SELECT @TotalRecords = @@ROWCOUNT
		
	SELECT
		p.ProductID,
		p.CatalogNumber,
		p.ProductName,
		SUBSTRING(p.Description, 0, 200) AS Description,
		(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NOT NULL ORDER BY SortOrder) AS Thumbnail,
		(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NULL ORDER BY SortOrder) AS ImageURL,
		p.price,
		p.Active 
	FROM
		Product p INNER JOIN #PageIndexForProducts i ON
		p.ProductID = i.ProductID
	WHERE
		i.IndexId >= @PageLowerBound AND 
		i.IndexId <= @PageUpperBound

	RETURN @TotalRecords

    DROP TABLE #PageIndexForProducts
END
GO
/****** Object:  StoredProcedure [dbo].[GetProducts]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GetProducts]
	@PageIndex int,
    @PageSize int,
    @CategoryID int = NULL,
    @SortOrder VARCHAR(10) = NULL,
	@Active bit = 1
AS
BEGIN

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForProducts
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        ProductID int
    )

IF @CategoryID IS NULL
	BEGIN

	 -- Insert into our temp table
    INSERT INTO #PageIndexForProducts (ProductID)
    SELECT
		ProductID
    FROM
		Product
	WHERE
		Active = @Active

	SELECT @TotalRecords = @@ROWCOUNT

		SELECT
			p.ProductID,
			p.CatalogNumber,
			p.ProductName,
			p.ProductLink,
			SUBSTRING(p.Description, 0, 200) AS Description,
			(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NOT NULL ORDER BY SortOrder) AS Thumbnail,
			(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NULL ORDER BY SortOrder) AS ImageURL,
			p.Price,
			p.Active 
		FROM
			Product p INNER JOIN #PageIndexForProducts i ON
			p.ProductID = i.ProductID
		WHERE
			i.IndexId >= @PageLowerBound AND 
			i.IndexId <= @PageUpperBound
	END
ELSE
	BEGIN
		IF @SortOrder IS NULL OR @SortOrder = 'DontSort'
			BEGIN
				INSERT INTO #PageIndexForProducts (ProductID)
				SELECT
					P.ProductID
				FROM
					Product p INNER JOIN ProductCategory pc ON
					p.ProductID = pc.ProductID
				WHERE
					p.Active = @Active AND
					pc.Active = @Active AND
					pc.CategoryID = @CategoryID

				SELECT @TotalRecords = @@ROWCOUNT
				SELECT
					p.ProductID,
					p.CatalogNumber,
					p.ProductName,
					p.ProductLink,
					SUBSTRING(p.Description, 0, 200) AS Description,
					(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NOT NULL ORDER BY SortOrder) AS Thumbnail,
					(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NULL ORDER BY SortOrder) AS ImageURL,
					p.Price,
					p.Active 
				FROM
					Product p INNER JOIN #PageIndexForProducts i ON
					p.ProductID = i.ProductID
				WHERE
					i.IndexId >= @PageLowerBound AND 
					i.IndexId <= @PageUpperBound
			END
		IF @SortOrder = 'LowtoHigh'
			BEGIN
				INSERT INTO #PageIndexForProducts (ProductID)
				SELECT
					P.ProductID
				FROM
					Product p INNER JOIN ProductCategory pc ON
					p.ProductID = pc.ProductID
				WHERE
					p.Active = @Active AND
					pc.Active = @Active AND
					pc.CategoryID = @CategoryID
				ORDER BY
					p.Price

				SELECT @TotalRecords = @@ROWCOUNT
				SELECT
					p.ProductID,
					p.CatalogNumber,
					p.ProductName,
					p.ProductLink,
					SUBSTRING(p.Description, 0, 200) AS Description,
					(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NOT NULL ORDER BY SortOrder) AS Thumbnail,
					(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NULL ORDER BY SortOrder) AS ImageURL,
					p.Price,
					p.Active 
				FROM
					Product p INNER JOIN #PageIndexForProducts i ON
					p.ProductID = i.ProductID
				WHERE
					i.IndexId >= @PageLowerBound AND 
					i.IndexId <= @PageUpperBound
				ORDER BY
					p.Price
			END
		IF @SortOrder = 'HightoLow'
			BEGIN
				INSERT INTO #PageIndexForProducts (ProductID)
				SELECT
					P.ProductID
				FROM
					Product p INNER JOIN ProductCategory pc ON
					p.ProductID = pc.ProductID
				WHERE
					p.Active = @Active AND
					pc.Active = @Active AND
					pc.CategoryID = @CategoryID
				ORDER BY
					p.Price
				DESC

				SELECT @TotalRecords = @@ROWCOUNT
				SELECT
					p.ProductID,
					p.CatalogNumber,
					p.ProductName,
					p.ProductLink,
					SUBSTRING(p.Description, 0, 200) AS Description,
					(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NOT NULL ORDER BY SortOrder) AS Thumbnail,
					(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NULL ORDER BY SortOrder) AS ImageURL,
					p.Price,
					p.Active 
				FROM
					Product p INNER JOIN #PageIndexForProducts i ON
					p.ProductID = i.ProductID
				WHERE
					i.IndexId >= @PageLowerBound AND 
					i.IndexId <= @PageUpperBound
				ORDER BY
					p.Price
				DESC
			END
		IF @SortOrder = 'Name'
			BEGIN
				INSERT INTO #PageIndexForProducts (ProductID)
				SELECT
					P.ProductID
				FROM
					Product p INNER JOIN ProductCategory pc ON
					p.ProductID = pc.ProductID
				WHERE
					p.Active = @Active AND
					pc.Active = @Active AND
					pc.CategoryID = @CategoryID
				ORDER BY
					p.ProductName

				SELECT @TotalRecords = @@ROWCOUNT
				SELECT
					p.ProductID,
					p.CatalogNumber,
					p.ProductName,
					p.ProductLink,
					SUBSTRING(p.Description, 0, 200) AS Description,
					(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NOT NULL ORDER BY SortOrder) AS Thumbnail,
					(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NULL ORDER BY SortOrder) AS ImageURL,
					p.Price,
					p.Active 
				FROM
					Product p INNER JOIN #PageIndexForProducts i ON
					p.ProductID = i.ProductID
				WHERE
					i.IndexId >= @PageLowerBound AND 
					i.IndexId <= @PageUpperBound
				ORDER BY
					p.ProductName
			END
	END
   
	RETURN @TotalRecords

    DROP TABLE #PageIndexForProducts
END
GO
/****** Object:  StoredProcedure [dbo].[GetProductImages]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProductImages] 
	@ProductID int,
	@Thums bit = 0,
	@Active bit= 1
AS
BEGIN
	SET NOCOUNT ON;

	IF @Thums = 1
		BEGIN
			SELECT
				ImageURL
			FROM
				[Image] WITH(NOLOCK)
			WHERE
				ProductID = @ProductID AND
				ParentID IS NOT NULL AND
				Active = @Active
			ORDER BY
				SortOrder
		END
	ELSE
		BEGIN
			SELECT
				ImageURL
			FROM
				[Image] WITH(NOLOCK)
			WHERE
				ProductID  = @ProductID AND
				ParentID IS NULL AND
				Active = @Active
			ORDER BY
				SortOrder
		END
END
GO
/****** Object:  StoredProcedure [dbo].[GetProductCategories]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProductCategories] 
	@ProductID int
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT
		C.CategoryID
	FROM
		Product P WITH(NOLOCK) INNER JOIN ProductCategory PC WITH(NOLOCK) ON
		P.ProductID = PC.ProductID INNER JOIN Category C WITH(NOLOCK) ON
		PC.CategoryID = C.CategoryID
	WHERE
		P.ProductID = @ProductID AND
		P.Active = 1 AND
		PC.Active = 1 AND
		C.Active = 1
END
GO
/****** Object:  StoredProcedure [dbo].[GetProduct]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProduct] 
	@ProductID int = NULL,
	@ProductName varchar(50) = NULL,
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	IF @ProductName IS NULL
		BEGIN
			SELECT 
				ProductID,
				CatalogNumber,
				ProductName,
				[Description],
				(SELECT TOP 1 ImageURL FROM [Image] WITH(NOLOCK) WHERE ProductID = ProductID AND ParentID IS NOT NULL ORDER BY SortOrder) AS Thumbnail,
				(SELECT TOP 1 ImageURL FROM [Image] WITH(NOLOCK) WHERE ProductID = ProductID AND ParentID IS NULL ORDER BY SortOrder) AS ImageURL,
				Price,
				SalePrice,
				[Weight],
				ShippingWeight,
				Height,
				ShippingHeight,
				[Length],
				ShippingLength,
				Width,
				ShippingWidth,
				ProductLink,
				IsDownloadable,
				IsDownloadKeyRequired,
				IsDownloadKeyUnique,
				DownloadURL,
				IsReviewEnabled,
				TotalReviewCount,
				RatingScore,
				Active 
			FROM
				[Product] WITH(NOLOCK)
			WHERE
				ProductID = @ProductID
		END
	ELSE
		BEGIN
			SELECT 
				ProductID,
				CatalogNumber,
				ProductName,
				Description,
				(SELECT TOP 1 ImageURL FROM [Image] WITH(NOLOCK) WHERE ProductID = ProductID AND ParentID IS NOT NULL ORDER BY SortOrder) AS Thumbnail,
				(SELECT TOP 1 ImageURL FROM [Image] WITH(NOLOCK) WHERE ProductID = ProductID AND ParentID IS NULL ORDER BY SortOrder) AS ImageURL,
				Price,
				SalePrice,
				[Weight],
				ShippingWeight,
				Height,
				ShippingHeight,
				[Length],
				ShippingLength,
				Width,
				ShippingWidth,
				ProductLink,
				IsDownloadable,
				IsDownloadKeyRequired,
				IsDownloadKeyUnique,
				DownloadURL,
				IsReviewEnabled,
				TotalReviewCount,
				RatingScore,
				Active 
			FROM
				[Product] WITH(NOLOCK)
			WHERE
				ProductName = @ProductName
		END
END
GO
/****** Object:  StoredProcedure [dbo].[GetFeaturedProducts]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFeaturedProducts]
	@CategoryID int = NULL,
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @CategoryID IS NOT NULL
		BEGIN
			SELECT
				fp.FeaturedProductID,
				fp.ProductID,
				p.ProductName,
				(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = fp.ProductID AND ParentID IS NOT NULL) AS Thumbnail,
				fp.CategoryID,
				fp.Active
			FROM
				FeaturedProduct fp WITH(NOLOCK) INNER JOIN Product p WITH(NOLOCK) ON
				fp.ProductID = p.ProductID
			WHERE
				fp.CategoryID = @CategoryID AND
				fp.Active = @Active AND
				p.Active = @Active
		END
	ELSE
		BEGIN
			SELECT
				fp.FeaturedProductID,
				fp.ProductID,
				p.ProductName,
				(SELECT TOP 1 ImageURL FROM [Image] WITH(NOLOCK) WHERE ProductID = fp.ProductID AND ParentID IS NOT NULL) AS Thumbnail,
				fp.CategoryID,
				fp.Active
			FROM
				FeaturedProduct fp WITH(NOLOCK) INNER JOIN Product p WITH(NOLOCK) ON
				fp.ProductID = p.ProductID
			WHERE
				CategoryID IS NULL AND
				fp.Active = @Active AND
				p.Active = @Active
		END

END
GO
/****** Object:  StoredProcedure [dbo].[GetCustomFields]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCustomFields] 
	@ProductID int = NULL,
	@Active bit = 1
AS
BEGIN

	SET NOCOUNT ON;

    SELECT
		CustomFieldID,
		ProductID,
		CustomFieldName,
		CustomFieldTypeName,
		IsRequired,
		CustomField.Active
	FROM
		CustomField WITH(NOLOCK) JOIN CustomFieldType WITH(NOLOCK) ON
		CustomField.CustomFieldTypeID = CustomFieldType.CustomFieldTypeID
	WHERE
		(ProductID = @ProductID OR ProductID IS NULL) AND
		CustomField.Active = @Active AND
		CustomFieldType.Active = @Active
END
GO
/****** Object:  StoredProcedure [dbo].[SearchProducts]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SearchProducts]
	@PageIndex int,
    @PageSize int,
    @Keyword varchar(200) = NULL,
	@Active bit = 1
AS
BEGIN

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForProducts
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        ProductID int
    )

	INSERT INTO #PageIndexForProducts (ProductID)
	SELECT
		P.ProductID
	FROM
		Product p
	WHERE
		p.Active = @Active AND
		(p.ProductName LIKE '%' + @Keyword + '%' OR
		p.Description LIKE '%' + @Keyword + '%')


	SELECT @TotalRecords = @@ROWCOUNT
		
	SELECT
		p.ProductID,
		p.CatalogNumber,
		p.ProductName,
		SUBSTRING(p.Description, 0, 200) AS Description,
		(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NOT NULL ORDER BY SortOrder) AS Thumbnail,
		(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = p.ProductID AND ParentID IS NULL ORDER BY SortOrder) AS ImageURL,
		p.price,
		p.Active 
	FROM
		Product p INNER JOIN #PageIndexForProducts i ON
		p.ProductID = i.ProductID
		INNER JOIN ProductCategory pc ON
		p.ProductID = pc.ProductID
	WHERE
		i.IndexId >= @PageLowerBound AND 
		i.IndexId <= @PageUpperBound


   
	RETURN @TotalRecords

    DROP TABLE #PageIndexForProducts
END
GO
/****** Object:  StoredProcedure [dbo].[RemoveRelatedProduct]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemoveRelatedProduct] 
	@RelatedProductID int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM RelatedProduct
	WHERE
		RelatedProductID = @RelatedProductID
END
GO
/****** Object:  StoredProcedure [dbo].[RemoveProductCategory]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemoveProductCategory] 
	@ProductCategoryID int
AS
BEGIN
	SET NOCOUNT ON;

    DELETE FROM ProductCategory
	WHERE
		ProductCategoryID = @ProductCategoryID
END
GO
/****** Object:  StoredProcedure [dbo].[RemoveImage]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemoveImage] 
	@ImageID int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [Image]
	WHERE
		ParentID = @ImageID

    DELETE FROM [Image]
	WHERE
		ImageID = @ImageID
END
GO
/****** Object:  StoredProcedure [dbo].[RemoveFeaturedProduct]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemoveFeaturedProduct] 
	@FeaturedProductID int
AS
BEGIN
	SET NOCOUNT ON;

    DELETE FROM FeaturedProduct
	WHERE
		FeaturedProductID = @FeaturedProductID
END
GO
/****** Object:  StoredProcedure [dbo].[RemoveCategory]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemoveCategory] 
	@CategoryID int
AS
BEGIN
	SET NOCOUNT ON;

    DELETE FROM ProductCategory
	WHERE
		CategoryID = @CategoryID

	DELETE FROM Category
	WHERE
		CategoryID = @CategoryID
END
GO
/****** Object:  Table [dbo].[InventoryProductOption]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryProductOption](
	[InventoryProductOptionID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryID] [int] NOT NULL,
	[ProductOptionID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_OptionInventory] PRIMARY KEY CLUSTERED 
(
	[InventoryProductOptionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[UpdateOrder]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateOrder]
	@OrderID int,
	@CustomerID int,
    @OrderNumber varchar(50),
    @OrderDate datetime,
    @OrderStatusID int,
    @ShippingProviderID int,
    @Address varchar(50),
    @City varchar(50),
    @StateID int,
    @CountryID int,
    @Zipcode varchar(50),
	@Comments varchar(50) = null,
    @DatePlaced datetime,
    @DateShipped datetime,
    @Total money,
    @Shipping money,
    @Tax money,
    @Active bit
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE
		[Order]
	SET
		CustomerID = @CustomerID,
		OrderNumber = @OrderNumber,
		OrderDate = @OrderDate,
		OrderStatusID = @OrderStatusID,
		ShippingProviderID = @ShippingProviderID,
		Address = @Address,
		City = @City,
		StateID = @StateID,
		CountryID = @CountryID,
		Zipcode = @Zipcode,
		Comments = @Comments,
		DatePlaced = @DatePlaced,
		DateShipped = @DateShipped,
		Total = @Total,
		Shipping = @Shipping,
		Tax = @Tax,
		Active = @Active
	WHERE
		OrderID = @OrderID
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateImage]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateImage]
	@ImageID int,
	@ParentID int,
	@ProductID int,
    @SortOrder int,
    @ImageName varchar(200),
    @ImageURL varchar(200),
	@Active bit
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE
		[Image]
	SET	
		ParentID = @ParentID,
		ProductID = @ProductID,
		SortOrder = @SortOrder,
		ImageName = @ImageName,
		ImageURL = @ImageURL,
		Active = @Active
	WHERE
		ImageID = @ImageID
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateOrderStatus]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateOrderStatus]
	@OrderID int,
    @OrderStatusID int
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE
		[Order]
	SET
		OrderStatusID = @OrderStatusID
	WHERE
		OrderID = @OrderID
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateProductCategory]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateProductCategory]
	@ProductCategoryID int,
	@ProductID int,
    @CategoryID int,
    @Active bit
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE
		ProductCategory
	SET
		ProductID = @ProductID,
		CategoryID = @CategoryID,
		Active = @Active
	WHERE
		ProductCategoryID = @ProductCategoryID
END
GO
/****** Object:  View [dbo].[vw_aspnet_WebPartState_Paths]    Script Date: 10/27/2011 09:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_aspnet_WebPartState_Paths]
  AS SELECT [dbo].[aspnet_Paths].[ApplicationId], [dbo].[aspnet_Paths].[PathId], [dbo].[aspnet_Paths].[Path], [dbo].[aspnet_Paths].[LoweredPath]
  FROM [dbo].[aspnet_Paths]
GO
/****** Object:  View [dbo].[vw_aspnet_Users]    Script Date: 10/27/2011 09:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_aspnet_Users]
  AS SELECT [dbo].[aspnet_Users].[ApplicationId], [dbo].[aspnet_Users].[UserId], [dbo].[aspnet_Users].[UserName], [dbo].[aspnet_Users].[LoweredUserName], [dbo].[aspnet_Users].[MobileAlias], [dbo].[aspnet_Users].[IsAnonymous], [dbo].[aspnet_Users].[LastActivityDate]
  FROM [dbo].[aspnet_Users]
GO
/****** Object:  View [dbo].[vw_aspnet_Roles]    Script Date: 10/27/2011 09:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_aspnet_Roles]
  AS SELECT [dbo].[aspnet_Roles].[ApplicationId], [dbo].[aspnet_Roles].[RoleId], [dbo].[aspnet_Roles].[RoleName], [dbo].[aspnet_Roles].[LoweredRoleName], [dbo].[aspnet_Roles].[Description]
  FROM [dbo].[aspnet_Roles]
GO
/****** Object:  StoredProcedure [dbo].[UpdateProductInventory]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateProductInventory]
	@ProductID INT,
	@CommaDelimitedProductOptions VARCHAR(2000),
	@Quantity INT
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @ProductOptions TABLE (
		ProductOptionID INT PRIMARY KEY
	);
	
	INSERT INTO 
		@ProductOptions
	SELECT DISTINCT 
		Value 
	FROM
		Split(@CommaDelimitedProductOptions, ',');
	
	DECLARE @InventoryID INT

    IF(SELECT COUNT(ProductOptionID) FROM @ProductOptions) > 0
		BEGIN	
			SET @InventoryID = (SELECT TOP 1
				InventoryID
			FROM
				Inventory iv
			WHERE
				ProductID = @ProductID AND
				NOT EXISTS (SELECT 
					ProductOptionID      
				FROM
					InventoryProductOption ipo INNER JOIN Inventory i ON 
					ipo.InventoryID = i.InventoryID
				WHERE
					i.InventoryID = iv.InventoryID
				EXCEPT
				SELECT
					ProductOptionID
				FROM
					@ProductOptions
				UNION
				SELECT
					ProductOptionID
				FROM
					@ProductOptions
				EXCEPT
				SELECT 
					ProductOptionID      
				FROM
					InventoryProductOption ipo INNER JOIN Inventory i ON 
					ipo.InventoryID = i.InventoryID
				WHERE
					i.InventoryID = iv.InventoryID
					
				)
				)
		END
	ELSE
		BEGIN
				SET @InventoryID = (SELECT TOP 1
				InventoryID
			FROM
				Inventory
			WHERE
				ProductID = @ProductID AND
				NOT EXISTS(
					SELECT 
						ProductOptionID      
					FROM
						InventoryProductOption ipo INNER JOIN Inventory i ON 
						ipo.InventoryID = i.InventoryID
					WHERE
						i.ProductID = @ProductID
						)
						)
		END
		
	IF @InventoryID IS NOT NULL
		BEGIN
			UPDATE
				Inventory
			SET
				ProductAmountInStock = ProductAmountInStock - @Quantity
			WHERE
				InventoryID = @InventoryID
		END
END
GO
/****** Object:  View [dbo].[vw_aspnet_WebPartState_User]    Script Date: 10/27/2011 09:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_aspnet_WebPartState_User]
  AS SELECT [dbo].[aspnet_PersonalizationPerUser].[PathId], [dbo].[aspnet_PersonalizationPerUser].[UserId], [DataSize]=DATALENGTH([dbo].[aspnet_PersonalizationPerUser].[PageSettings]), [dbo].[aspnet_PersonalizationPerUser].[LastUpdatedDate]
  FROM [dbo].[aspnet_PersonalizationPerUser]
GO
/****** Object:  View [dbo].[vw_aspnet_WebPartState_Shared]    Script Date: 10/27/2011 09:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_aspnet_WebPartState_Shared]
  AS SELECT [dbo].[aspnet_PersonalizationAllUsers].[PathId], [DataSize]=DATALENGTH([dbo].[aspnet_PersonalizationAllUsers].[PageSettings]), [dbo].[aspnet_PersonalizationAllUsers].[LastUpdatedDate]
  FROM [dbo].[aspnet_PersonalizationAllUsers]
GO
/****** Object:  View [dbo].[vw_aspnet_Profiles]    Script Date: 10/27/2011 09:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_aspnet_Profiles]
  AS SELECT [dbo].[aspnet_Profile].[UserId], [dbo].[aspnet_Profile].[LastUpdatedDate],
      [DataSize]=  DATALENGTH([dbo].[aspnet_Profile].[PropertyNames])
                 + DATALENGTH([dbo].[aspnet_Profile].[PropertyValuesString])
                 + DATALENGTH([dbo].[aspnet_Profile].[PropertyValuesBinary])
  FROM [dbo].[aspnet_Profile]
GO
/****** Object:  View [dbo].[vw_aspnet_MembershipUsers]    Script Date: 10/27/2011 09:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_aspnet_MembershipUsers]
  AS SELECT [dbo].[aspnet_Membership].[UserId],
            [dbo].[aspnet_Membership].[PasswordFormat],
            [dbo].[aspnet_Membership].[MobilePIN],
            [dbo].[aspnet_Membership].[Email],
            [dbo].[aspnet_Membership].[LoweredEmail],
            [dbo].[aspnet_Membership].[PasswordQuestion],
            [dbo].[aspnet_Membership].[PasswordAnswer],
            [dbo].[aspnet_Membership].[IsApproved],
            [dbo].[aspnet_Membership].[IsLockedOut],
            [dbo].[aspnet_Membership].[CreateDate],
            [dbo].[aspnet_Membership].[LastLoginDate],
            [dbo].[aspnet_Membership].[LastPasswordChangedDate],
            [dbo].[aspnet_Membership].[LastLockoutDate],
            [dbo].[aspnet_Membership].[FailedPasswordAttemptCount],
            [dbo].[aspnet_Membership].[FailedPasswordAttemptWindowStart],
            [dbo].[aspnet_Membership].[FailedPasswordAnswerAttemptCount],
            [dbo].[aspnet_Membership].[FailedPasswordAnswerAttemptWindowStart],
            [dbo].[aspnet_Membership].[Comment],
            [dbo].[aspnet_Users].[ApplicationId],
            [dbo].[aspnet_Users].[UserName],
            [dbo].[aspnet_Users].[MobileAlias],
            [dbo].[aspnet_Users].[IsAnonymous],
            [dbo].[aspnet_Users].[LastActivityDate]
  FROM [dbo].[aspnet_Membership] INNER JOIN [dbo].[aspnet_Users]
      ON [dbo].[aspnet_Membership].[UserId] = [dbo].[aspnet_Users].[UserId]
GO
/****** Object:  View [dbo].[vw_aspnet_UsersInRoles]    Script Date: 10/27/2011 09:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_aspnet_UsersInRoles]
  AS SELECT [dbo].[aspnet_UsersInRoles].[UserId], [dbo].[aspnet_UsersInRoles].[RoleId]
  FROM [dbo].[aspnet_UsersInRoles]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCustomer]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateCustomer]
	@CustomerID int = NULL,
	@MemberID uniqueidentifier = NULL,
	@Company varchar(50),
    @FirstName varchar(50),
    @LastName varchar(50),
    @Address varchar(50),
    @City varchar(50),
    @StateID int = NULL,
	@ProvinceID int = NULL,
    @CountryID int,
    @Zipcode varchar(50),
    @DayPhone varchar(50),
    @EveningPhone varchar(50),
    @CellPhone varchar(50),
    @Fax varchar(50),
    @Email varchar(50),
    @DateCreated datetime,
    @DateUpdated datetime = GETDATE,
    @Active bit
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @CustomerID IS NOT NULL
		BEGIN
			UPDATE
				Customer
			SET
				Company = @Company,
				FirstName = @FirstName,
				LastName = @LastName,
				Address = @Address,
				City = @City,
				StateID = @StateID,
				ProvinceID = @ProvinceID,
				CountryID = @CountryID,
				Zipcode = @Zipcode,
				DayPhone = @DayPhone,
				EveningPhone = @EveningPhone,
				CellPhone = @CellPhone,
				Fax = @Fax,
				Email = @Email,
				DateCreated = @DateCreated,
				DateUpdated = @DateUpdated,
				Active = @Active
			WHERE
				CustomerID = @CustomerID
		END
	ELSE IF @CustomerID IS NULL AND @MemberID IS NOT NULL
		BEGIN
			UPDATE
				Customer
			SET
				Company = @Company,
				FirstName = @FirstName,
				LastName = @LastName,
				Address = @Address,
				City = @City,
				StateID = @StateID,
				ProvinceID = @ProvinceID,
				CountryID = @CountryID,
				Zipcode = @Zipcode,
				DayPhone = @DayPhone,
				EveningPhone = @EveningPhone,
				CellPhone = @CellPhone,
				Fax = @Fax,
				Email = @Email,
				DateCreated = @DateCreated,
				DateUpdated = @DateUpdated,
				Active = @Active
			WHERE
				MemberID = @MemberID
		END
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateOrderProduct]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateOrderProduct]
	@OrderProductID int,
	@OrderID int,
    @ProductID int,
    @Quantity int,
    @PricePerUnit money,
    @TotalPrice money,
    @Discount money,
    @Shipping money,
    @DownloadKey varchar(50),
    @DownloadURL varchar(400),
    @OrderDate datetime,
    @Active bit
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE
		[OrderProduct]
	SET
		OrderID = @OrderID,
		ProductID = @ProductID,
		Quantity = @Quantity,
		PricePerUnit = @PricePerUnit,
		TotalPrice = @TotalPrice,
		Discount = @Discount,
		Shipping = @Shipping,
		DownloadKey = @DownloadKey,
		DownloadURL = @DownloadURL,
		OrderDate = @OrderDate,
		Active = @Active
	WHERE
		OrderProductID = @OrderProductID
END
GO
/****** Object:  StoredProcedure [dbo].[GetCustomers]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GetCustomers]
	@PageIndex int,
    @PageSize int,
	@Active bit = 1
AS
BEGIN

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForCustomers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        CustomerID int
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForCustomers (CustomerID)
    SELECT
		CustomerID
    FROM
		Customer

	SELECT @TotalRecords = @@ROWCOUNT

	SELECT
		CustomerID,
		MemberID,
		Company,
		FirstName,
		LastName,
		Address,
		City,
		StateID,
		CountryID,
		Zipcode,
		DayPhone,
		EveningPhone,
		CellPhone,
		Fax,
		Email,
		DateCreated,
		DateUpdated,
		Active
	FROM
			Customer,
			#PageIndexForCustomers i
		WHERE
			Active = @Active AND
			i.IndexId >= @PageLowerBound AND 
			i.IndexId <= @PageUpperBound
	

   
	RETURN @TotalRecords

    DROP TABLE #PageIndexForCustomers
END
GO
/****** Object:  StoredProcedure [dbo].[GetOrderProducts]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOrderProducts]
	@OrderID int,
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		OP.OrderProductID,
		OP.OrderID,
		OP.ProductID,
		OP.Quantity,
		OP.PricePerUnit,
		OP.TotalPrice,
		OP.Discount,
		OP.Shipping,
		OP.OrderDate,
		OP.DownloadKey,
		OP.DownloadURL,
		OP.Active,
		P.ProductName,
		P.CatalogNumber
	FROM
		OrderProduct OP WITH(NOLOCK) INNER JOIN Product P WITH(NOLOCK) ON
		OP.ProductID = P.ProductID
	WHERE
		OrderID = @OrderID
END
GO
/****** Object:  Table [dbo].[GiftRegistry]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GiftRegistry](
	[GiftRegistryID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[IsPublic] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_GiftRegistry] PRIMARY KEY CLUSTERED 
(
	[GiftRegistryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetProductInventory]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProductInventory]
	@ProductID INT,
	@CommaDelimitedProductOptions VARCHAR(2000)
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @ProductOptions TABLE (
		ProductOptionID INT PRIMARY KEY
	);
	
	INSERT INTO 
		@ProductOptions
	SELECT DISTINCT 
		Value 
	FROM
		Split(@CommaDelimitedProductOptions, ',');

	
	IF(SELECT COUNT(ProductOptionID) FROM @ProductOptions) > 0
		BEGIN	
			SELECT TOP 1
				InventoryID,
				InventoryActionID,
				ProductID,
				ProductAmountInStock,
				Active
			FROM
				Inventory iv
			WHERE
				ProductID = @ProductID AND
				NOT EXISTS (SELECT 
					ProductOptionID      
				FROM
					InventoryProductOption ipo INNER JOIN Inventory i ON 
					ipo.InventoryID = i.InventoryID
				WHERE
					i.InventoryID = iv.InventoryID
				EXCEPT
				SELECT
					ProductOptionID
				FROM
					@ProductOptions
				UNION
				SELECT
					ProductOptionID
				FROM
					@ProductOptions
				EXCEPT
				SELECT 
					ProductOptionID      
				FROM
					InventoryProductOption ipo INNER JOIN Inventory i ON 
					ipo.InventoryID = i.InventoryID
				WHERE
					i.InventoryID = iv.InventoryID
					
				)
		END
	ELSE
		BEGIN
				SELECT TOP 1
				InventoryID,
				InventoryActionID,
				ProductID,
				ProductAmountInStock,
				Active
			FROM
				Inventory
			WHERE
				ProductID = @ProductID AND
				NOT EXISTS(
					SELECT 
						ProductOptionID      
					FROM
						InventoryProductOption ipo INNER JOIN Inventory i ON 
						ipo.InventoryID = i.InventoryID
					WHERE
						i.ProductID = @ProductID)
		END
END
GO
/****** Object:  StoredProcedure [dbo].[IsEmailExists]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IsEmailExists] 
	@Email varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM Customer WHERE Email = @Email)
		BEGIN
			SELECT 1
		END
	ELSE
		BEGIN
			SELECT 0
		END	
END
GO
/****** Object:  StoredProcedure [dbo].[IsCustomerAllowedToReview]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IsCustomerAllowedToReview] 
	@CustomerID int,
	@ProductID int
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF EXISTS(SELECT 1 FROM
			Customer C WITH(NOLOCK) INNER JOIN [Order] O WITH(NOLOCK) ON
			C.CustomerID = O.CustomerID INNER JOIN OrderProduct OP WITH(NOLOCK) ON
			O.OrderID = OP.OrderID
		WHERE
			O.CustomerID = @CustomerID AND
			OP.ProductID = @ProductID AND
			C.Active = 1 AND
			O.Active = 1 AND
			OP.Active = 1)
		BEGIN
			SELECT 1
		END
	ELSE
		BEGIN
			SELECT 0
		END
END
GO
/****** Object:  Table [dbo].[OrderProductOption]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderProductOption](
	[OrderProductOptionID] [int] IDENTITY(1,1) NOT NULL,
	[OrderProductID] [int] NOT NULL,
	[ProductOptionID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_OrderProductOption] PRIMARY KEY CLUSTERED 
(
	[OrderProductOptionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderProductCustomField]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrderProductCustomField](
	[OrderProductCustomFieldID] [int] IDENTITY(1,1) NOT NULL,
	[OrderProductID] [int] NOT NULL,
	[CustomFieldID] [int] NOT NULL,
	[OrderProductCustomFieldValue] [varchar](400) NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_OrderProductCustomField] PRIMARY KEY CLUSTERED 
(
	[OrderProductCustomFieldID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductReview]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductReview](
	[ProductReviewID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[ReviewText] [varchar](500) NOT NULL,
	[ReviewDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_ProductReview] PRIMARY KEY CLUSTERED 
(
	[ProductReviewID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationPerUser_SetPageSettings]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationPerUser_SetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @UserName         NVARCHAR(256),
    @Path             NVARCHAR(256),
    @PageSettings     IMAGE,
    @CurrentTimeUtc   DATETIME)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER
    DECLARE @UserId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL
    SELECT @UserId = NULL

    EXEC dbo.aspnet_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    SELECT @PathId = u.PathId FROM dbo.aspnet_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        EXEC dbo.aspnet_Paths_CreatePath @ApplicationId, @Path, @PathId OUTPUT
    END

    SELECT @UserId = u.UserId FROM dbo.aspnet_Users u WHERE u.ApplicationId = @ApplicationId AND u.LoweredUserName = LOWER(@UserName)
    IF (@UserId IS NULL)
    BEGIN
        EXEC dbo.aspnet_Users_CreateUser @ApplicationId, @UserName, 0, @CurrentTimeUtc, @UserId OUTPUT
    END

    UPDATE   dbo.aspnet_Users WITH (ROWLOCK)
    SET      LastActivityDate = @CurrentTimeUtc
    WHERE    UserId = @UserId
    IF (@@ROWCOUNT = 0) -- Username not found
        RETURN

    IF (EXISTS(SELECT PathId FROM dbo.aspnet_PersonalizationPerUser WHERE UserId = @UserId AND PathId = @PathId))
        UPDATE dbo.aspnet_PersonalizationPerUser SET PageSettings = @PageSettings, LastUpdatedDate = @CurrentTimeUtc WHERE UserId = @UserId AND PathId = @PathId
    ELSE
        INSERT INTO dbo.aspnet_PersonalizationPerUser(UserId, PathId, PageSettings, LastUpdatedDate) VALUES (@UserId, @PathId, @PageSettings, @CurrentTimeUtc)
    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationPerUser_ResetPageSettings]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationPerUser_ResetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @UserName         NVARCHAR(256),
    @Path             NVARCHAR(256),
    @CurrentTimeUtc   DATETIME)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER
    DECLARE @UserId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL
    SELECT @UserId = NULL

    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @PathId = u.PathId FROM dbo.aspnet_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @UserId = u.UserId FROM dbo.aspnet_Users u WHERE u.ApplicationId = @ApplicationId AND u.LoweredUserName = LOWER(@UserName)
    IF (@UserId IS NULL)
    BEGIN
        RETURN
    END

    UPDATE   dbo.aspnet_Users WITH (ROWLOCK)
    SET      LastActivityDate = @CurrentTimeUtc
    WHERE    UserId = @UserId
    IF (@@ROWCOUNT = 0) -- Username not found
        RETURN

    DELETE FROM dbo.aspnet_PersonalizationPerUser WHERE PathId = @PathId AND UserId = @UserId
    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationPerUser_GetPageSettings]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationPerUser_GetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @UserName         NVARCHAR(256),
    @Path             NVARCHAR(256),
    @CurrentTimeUtc   DATETIME)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER
    DECLARE @UserId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL
    SELECT @UserId = NULL

    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @PathId = u.PathId FROM dbo.aspnet_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @UserId = u.UserId FROM dbo.aspnet_Users u WHERE u.ApplicationId = @ApplicationId AND u.LoweredUserName = LOWER(@UserName)
    IF (@UserId IS NULL)
    BEGIN
        RETURN
    END

    UPDATE   dbo.aspnet_Users WITH (ROWLOCK)
    SET      LastActivityDate = @CurrentTimeUtc
    WHERE    UserId = @UserId
    IF (@@ROWCOUNT = 0) -- Username not found
        RETURN

    SELECT p.PageSettings FROM dbo.aspnet_PersonalizationPerUser p WHERE p.PathId = @PathId AND p.UserId = @UserId
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAllUsers_SetPageSettings]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAllUsers_SetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @Path             NVARCHAR(256),
    @PageSettings     IMAGE,
    @CurrentTimeUtc   DATETIME)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL

    EXEC dbo.aspnet_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    SELECT @PathId = u.PathId FROM dbo.aspnet_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        EXEC dbo.aspnet_Paths_CreatePath @ApplicationId, @Path, @PathId OUTPUT
    END

    IF (EXISTS(SELECT PathId FROM dbo.aspnet_PersonalizationAllUsers WHERE PathId = @PathId))
        UPDATE dbo.aspnet_PersonalizationAllUsers SET PageSettings = @PageSettings, LastUpdatedDate = @CurrentTimeUtc WHERE PathId = @PathId
    ELSE
        INSERT INTO dbo.aspnet_PersonalizationAllUsers(PathId, PageSettings, LastUpdatedDate) VALUES (@PathId, @PageSettings, @CurrentTimeUtc)
    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAllUsers_ResetPageSettings]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAllUsers_ResetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @Path              NVARCHAR(256))
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL

    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @PathId = u.PathId FROM dbo.aspnet_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        RETURN
    END

    DELETE FROM dbo.aspnet_PersonalizationAllUsers WHERE PathId = @PathId
    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAllUsers_GetPageSettings]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAllUsers_GetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @Path              NVARCHAR(256))
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL

    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @PathId = u.PathId FROM dbo.aspnet_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        RETURN
    END

    SELECT p.PageSettings FROM dbo.aspnet_PersonalizationAllUsers p WHERE p.PathId = @PathId
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAdministration_ResetUserState]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAdministration_ResetUserState] (
    @Count                  int                 OUT,
    @ApplicationName        NVARCHAR(256),
    @InactiveSinceDate      DATETIME            = NULL,
    @UserName               NVARCHAR(256)       = NULL,
    @Path                   NVARCHAR(256)       = NULL)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        SELECT @Count = 0
    ELSE
    BEGIN
        DELETE FROM dbo.aspnet_PersonalizationPerUser
        WHERE Id IN (SELECT PerUser.Id
                     FROM dbo.aspnet_PersonalizationPerUser PerUser, dbo.aspnet_Users Users, dbo.aspnet_Paths Paths
                     WHERE Paths.ApplicationId = @ApplicationId
                           AND PerUser.UserId = Users.UserId
                           AND PerUser.PathId = Paths.PathId
                           AND (@InactiveSinceDate IS NULL OR Users.LastActivityDate <= @InactiveSinceDate)
                           AND (@UserName IS NULL OR Users.LoweredUserName = LOWER(@UserName))
                           AND (@Path IS NULL OR Paths.LoweredPath = LOWER(@Path)))

        SELECT @Count = @@ROWCOUNT
    END
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAdministration_ResetSharedState]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAdministration_ResetSharedState] (
    @Count int OUT,
    @ApplicationName NVARCHAR(256),
    @Path NVARCHAR(256))
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        SELECT @Count = 0
    ELSE
    BEGIN
        DELETE FROM dbo.aspnet_PersonalizationAllUsers
        WHERE PathId IN
            (SELECT AllUsers.PathId
             FROM dbo.aspnet_PersonalizationAllUsers AllUsers, dbo.aspnet_Paths Paths
             WHERE Paths.ApplicationId = @ApplicationId
                   AND AllUsers.PathId = Paths.PathId
                   AND Paths.LoweredPath = LOWER(@Path))

        SELECT @Count = @@ROWCOUNT
    END
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAdministration_GetCountOfState]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAdministration_GetCountOfState] (
    @Count int OUT,
    @AllUsersScope bit,
    @ApplicationName NVARCHAR(256),
    @Path NVARCHAR(256) = NULL,
    @UserName NVARCHAR(256) = NULL,
    @InactiveSinceDate DATETIME = NULL)
AS
BEGIN

    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        SELECT @Count = 0
    ELSE
        IF (@AllUsersScope = 1)
            SELECT @Count = COUNT(*)
            FROM dbo.aspnet_PersonalizationAllUsers AllUsers, dbo.aspnet_Paths Paths
            WHERE Paths.ApplicationId = @ApplicationId
                  AND AllUsers.PathId = Paths.PathId
                  AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
        ELSE
            SELECT @Count = COUNT(*)
            FROM dbo.aspnet_PersonalizationPerUser PerUser, dbo.aspnet_Users Users, dbo.aspnet_Paths Paths
            WHERE Paths.ApplicationId = @ApplicationId
                  AND PerUser.UserId = Users.UserId
                  AND PerUser.PathId = Paths.PathId
                  AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
                  AND (@UserName IS NULL OR Users.LoweredUserName LIKE LOWER(@UserName))
                  AND (@InactiveSinceDate IS NULL OR Users.LastActivityDate <= @InactiveSinceDate)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAdministration_FindState]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAdministration_FindState] (
    @AllUsersScope bit,
    @ApplicationName NVARCHAR(256),
    @PageIndex              INT,
    @PageSize               INT,
    @Path NVARCHAR(256) = NULL,
    @UserName NVARCHAR(256) = NULL,
    @InactiveSinceDate DATETIME = NULL)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        RETURN

    -- Set the page bounds
    DECLARE @PageLowerBound INT
    DECLARE @PageUpperBound INT
    DECLARE @TotalRecords   INT
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table to store the selected results
    CREATE TABLE #PageIndex (
        IndexId int IDENTITY (0, 1) NOT NULL,
        ItemId UNIQUEIDENTIFIER
    )

    IF (@AllUsersScope = 1)
    BEGIN
        -- Insert into our temp table
        INSERT INTO #PageIndex (ItemId)
        SELECT Paths.PathId
        FROM dbo.aspnet_Paths Paths,
             ((SELECT Paths.PathId
               FROM dbo.aspnet_PersonalizationAllUsers AllUsers, dbo.aspnet_Paths Paths
               WHERE Paths.ApplicationId = @ApplicationId
                      AND AllUsers.PathId = Paths.PathId
                      AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
              ) AS SharedDataPerPath
              FULL OUTER JOIN
              (SELECT DISTINCT Paths.PathId
               FROM dbo.aspnet_PersonalizationPerUser PerUser, dbo.aspnet_Paths Paths
               WHERE Paths.ApplicationId = @ApplicationId
                      AND PerUser.PathId = Paths.PathId
                      AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
              ) AS UserDataPerPath
              ON SharedDataPerPath.PathId = UserDataPerPath.PathId
             )
        WHERE Paths.PathId = SharedDataPerPath.PathId OR Paths.PathId = UserDataPerPath.PathId
        ORDER BY Paths.Path ASC

        SELECT @TotalRecords = @@ROWCOUNT

        SELECT Paths.Path,
               SharedDataPerPath.LastUpdatedDate,
               SharedDataPerPath.SharedDataLength,
               UserDataPerPath.UserDataLength,
               UserDataPerPath.UserCount
        FROM dbo.aspnet_Paths Paths,
             ((SELECT PageIndex.ItemId AS PathId,
                      AllUsers.LastUpdatedDate AS LastUpdatedDate,
                      DATALENGTH(AllUsers.PageSettings) AS SharedDataLength
               FROM dbo.aspnet_PersonalizationAllUsers AllUsers, #PageIndex PageIndex
               WHERE AllUsers.PathId = PageIndex.ItemId
                     AND PageIndex.IndexId >= @PageLowerBound AND PageIndex.IndexId <= @PageUpperBound
              ) AS SharedDataPerPath
              FULL OUTER JOIN
              (SELECT PageIndex.ItemId AS PathId,
                      SUM(DATALENGTH(PerUser.PageSettings)) AS UserDataLength,
                      COUNT(*) AS UserCount
               FROM aspnet_PersonalizationPerUser PerUser, #PageIndex PageIndex
               WHERE PerUser.PathId = PageIndex.ItemId
                     AND PageIndex.IndexId >= @PageLowerBound AND PageIndex.IndexId <= @PageUpperBound
               GROUP BY PageIndex.ItemId
              ) AS UserDataPerPath
              ON SharedDataPerPath.PathId = UserDataPerPath.PathId
             )
        WHERE Paths.PathId = SharedDataPerPath.PathId OR Paths.PathId = UserDataPerPath.PathId
        ORDER BY Paths.Path ASC
    END
    ELSE
    BEGIN
        -- Insert into our temp table
        INSERT INTO #PageIndex (ItemId)
        SELECT PerUser.Id
        FROM dbo.aspnet_PersonalizationPerUser PerUser, dbo.aspnet_Users Users, dbo.aspnet_Paths Paths
        WHERE Paths.ApplicationId = @ApplicationId
              AND PerUser.UserId = Users.UserId
              AND PerUser.PathId = Paths.PathId
              AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
              AND (@UserName IS NULL OR Users.LoweredUserName LIKE LOWER(@UserName))
              AND (@InactiveSinceDate IS NULL OR Users.LastActivityDate <= @InactiveSinceDate)
        ORDER BY Paths.Path ASC, Users.UserName ASC

        SELECT @TotalRecords = @@ROWCOUNT

        SELECT Paths.Path, PerUser.LastUpdatedDate, DATALENGTH(PerUser.PageSettings), Users.UserName, Users.LastActivityDate
        FROM dbo.aspnet_PersonalizationPerUser PerUser, dbo.aspnet_Users Users, dbo.aspnet_Paths Paths, #PageIndex PageIndex
        WHERE PerUser.Id = PageIndex.ItemId
              AND PerUser.UserId = Users.UserId
              AND PerUser.PathId = Paths.PathId
              AND PageIndex.IndexId >= @PageLowerBound AND PageIndex.IndexId <= @PageUpperBound
        ORDER BY Paths.Path ASC, Users.UserName ASC
    END

    RETURN @TotalRecords
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAdministration_DeleteAllState]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAdministration_DeleteAllState] (
    @AllUsersScope bit,
    @ApplicationName NVARCHAR(256),
    @Count int OUT)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        SELECT @Count = 0
    ELSE
    BEGIN
        IF (@AllUsersScope = 1)
            DELETE FROM aspnet_PersonalizationAllUsers
            WHERE PathId IN
               (SELECT Paths.PathId
                FROM dbo.aspnet_Paths Paths
                WHERE Paths.ApplicationId = @ApplicationId)
        ELSE
            DELETE FROM aspnet_PersonalizationPerUser
            WHERE PathId IN
               (SELECT Paths.PathId
                FROM dbo.aspnet_Paths Paths
                WHERE Paths.ApplicationId = @ApplicationId)

        SELECT @Count = @@ROWCOUNT
    END
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_UpdateUserInfo]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_UpdateUserInfo]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @IsPasswordCorrect              bit,
    @UpdateLastLoginActivityDate    bit,
    @MaxInvalidPasswordAttempts     int,
    @PasswordAttemptWindow          int,
    @CurrentTimeUtc                 datetime,
    @LastLoginDate                  datetime,
    @LastActivityDate               datetime
AS
BEGIN
    DECLARE @UserId                                 uniqueidentifier
    DECLARE @IsApproved                             bit
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId,
            @IsApproved = m.IsApproved,
            @IsLockedOut = m.IsLockedOut,
            @LastLockoutDate = m.LastLockoutDate,
            @FailedPasswordAttemptCount = m.FailedPasswordAttemptCount,
            @FailedPasswordAttemptWindowStart = m.FailedPasswordAttemptWindowStart,
            @FailedPasswordAnswerAttemptCount = m.FailedPasswordAnswerAttemptCount,
            @FailedPasswordAnswerAttemptWindowStart = m.FailedPasswordAnswerAttemptWindowStart
    FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m WITH ( UPDLOCK )
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF ( @@rowcount = 0 )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    IF( @IsLockedOut = 1 )
    BEGIN
        GOTO Cleanup
    END

    IF( @IsPasswordCorrect = 0 )
    BEGIN
        IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAttemptWindowStart ) )
        BEGIN
            SET @FailedPasswordAttemptWindowStart = @CurrentTimeUtc
            SET @FailedPasswordAttemptCount = 1
        END
        ELSE
        BEGIN
            SET @FailedPasswordAttemptWindowStart = @CurrentTimeUtc
            SET @FailedPasswordAttemptCount = @FailedPasswordAttemptCount + 1
        END

        BEGIN
            IF( @FailedPasswordAttemptCount >= @MaxInvalidPasswordAttempts )
            BEGIN
                SET @IsLockedOut = 1
                SET @LastLockoutDate = @CurrentTimeUtc
            END
        END
    END
    ELSE
    BEGIN
        IF( @FailedPasswordAttemptCount > 0 OR @FailedPasswordAnswerAttemptCount > 0 )
        BEGIN
            SET @FailedPasswordAttemptCount = 0
            SET @FailedPasswordAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            SET @FailedPasswordAnswerAttemptCount = 0
            SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            SET @LastLockoutDate = CONVERT( datetime, '17540101', 112 )
        END
    END

    IF( @UpdateLastLoginActivityDate = 1 )
    BEGIN
        UPDATE  dbo.aspnet_Users
        SET     LastActivityDate = @LastActivityDate
        WHERE   @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END

        UPDATE  dbo.aspnet_Membership
        SET     LastLoginDate = @LastLoginDate
        WHERE   UserId = @UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END


    UPDATE dbo.aspnet_Membership
    SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
        FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
        FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
        FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
        FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
    WHERE @UserId = UserId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_UpdateUser]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_UpdateUser]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @Email                nvarchar(256),
    @Comment              ntext,
    @IsApproved           bit,
    @LastLoginDate        datetime,
    @LastActivityDate     datetime,
    @UniqueEmail          int,
    @CurrentTimeUtc       datetime
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId, @ApplicationId = a.ApplicationId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF (@UserId IS NULL)
        RETURN(1)

    IF (@UniqueEmail = 1)
    BEGIN
        IF (EXISTS (SELECT *
                    FROM  dbo.aspnet_Membership WITH (UPDLOCK, HOLDLOCK)
                    WHERE ApplicationId = @ApplicationId  AND @UserId <> UserId AND LoweredEmail = LOWER(@Email)))
        BEGIN
            RETURN(7)
        END
    END

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
	SET @TranStarted = 0

    UPDATE dbo.aspnet_Users WITH (ROWLOCK)
    SET
         LastActivityDate = @LastActivityDate
    WHERE
       @UserId = UserId

    IF( @@ERROR <> 0 )
        GOTO Cleanup

    UPDATE dbo.aspnet_Membership WITH (ROWLOCK)
    SET
         Email            = @Email,
         LoweredEmail     = LOWER(@Email),
         Comment          = @Comment,
         IsApproved       = @IsApproved,
         LastLoginDate    = @LastLoginDate
    WHERE
       @UserId = UserId

    IF( @@ERROR <> 0 )
        GOTO Cleanup

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN -1
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_UnlockUser]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_UnlockUser]
    @ApplicationName                         nvarchar(256),
    @UserName                                nvarchar(256)
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF ( @UserId IS NULL )
        RETURN 1

    UPDATE dbo.aspnet_Membership
    SET IsLockedOut = 0,
        FailedPasswordAttemptCount = 0,
        FailedPasswordAttemptWindowStart = CONVERT( datetime, '17540101', 112 ),
        FailedPasswordAnswerAttemptCount = 0,
        FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 ),
        LastLockoutDate = CONVERT( datetime, '17540101', 112 )
    WHERE @UserId = UserId

    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_SetPassword]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_SetPassword]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @NewPassword      nvarchar(128),
    @PasswordSalt     nvarchar(128),
    @CurrentTimeUtc   datetime,
    @PasswordFormat   int = 0
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF (@UserId IS NULL)
        RETURN(1)

    UPDATE dbo.aspnet_Membership
    SET Password = @NewPassword, PasswordFormat = @PasswordFormat, PasswordSalt = @PasswordSalt,
        LastPasswordChangedDate = @CurrentTimeUtc
    WHERE @UserId = UserId
    RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_ResetPassword]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_ResetPassword]
    @ApplicationName             nvarchar(256),
    @UserName                    nvarchar(256),
    @NewPassword                 nvarchar(128),
    @MaxInvalidPasswordAttempts  int,
    @PasswordAttemptWindow       int,
    @PasswordSalt                nvarchar(128),
    @CurrentTimeUtc              datetime,
    @PasswordFormat              int = 0,
    @PasswordAnswer              nvarchar(128) = NULL
AS
BEGIN
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @UserId                                 uniqueidentifier
    SET     @UserId = NULL

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF ( @UserId IS NULL )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    SELECT @IsLockedOut = IsLockedOut,
           @LastLockoutDate = LastLockoutDate,
           @FailedPasswordAttemptCount = FailedPasswordAttemptCount,
           @FailedPasswordAttemptWindowStart = FailedPasswordAttemptWindowStart,
           @FailedPasswordAnswerAttemptCount = FailedPasswordAnswerAttemptCount,
           @FailedPasswordAnswerAttemptWindowStart = FailedPasswordAnswerAttemptWindowStart
    FROM dbo.aspnet_Membership WITH ( UPDLOCK )
    WHERE @UserId = UserId

    IF( @IsLockedOut = 1 )
    BEGIN
        SET @ErrorCode = 99
        GOTO Cleanup
    END

    UPDATE dbo.aspnet_Membership
    SET    Password = @NewPassword,
           LastPasswordChangedDate = @CurrentTimeUtc,
           PasswordFormat = @PasswordFormat,
           PasswordSalt = @PasswordSalt
    WHERE  @UserId = UserId AND
           ( ( @PasswordAnswer IS NULL ) OR ( LOWER( PasswordAnswer ) = LOWER( @PasswordAnswer ) ) )

    IF ( @@ROWCOUNT = 0 )
        BEGIN
            IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAnswerAttemptWindowStart ) )
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = 1
            END
            ELSE
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount + 1
            END

            BEGIN
                IF( @FailedPasswordAnswerAttemptCount >= @MaxInvalidPasswordAttempts )
                BEGIN
                    SET @IsLockedOut = 1
                    SET @LastLockoutDate = @CurrentTimeUtc
                END
            END

            SET @ErrorCode = 3
        END
    ELSE
        BEGIN
            IF( @FailedPasswordAnswerAttemptCount > 0 )
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = 0
                SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            END
        END

    IF( NOT ( @PasswordAnswer IS NULL ) )
    BEGIN
        UPDATE dbo.aspnet_Membership
        SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
            FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
            FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
            FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
            FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
        WHERE @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByUserId]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetUserByUserId]
    @UserId               uniqueidentifier,
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    IF ( @UpdateLastActivity = 1 )
    BEGIN
        UPDATE   dbo.aspnet_Users
        SET      LastActivityDate = @CurrentTimeUtc
        FROM     dbo.aspnet_Users
        WHERE    @UserId = UserId

        IF ( @@ROWCOUNT = 0 ) -- User ID not found
            RETURN -1
    END

    SELECT  m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate, m.LastLoginDate, u.LastActivityDate,
            m.LastPasswordChangedDate, u.UserName, m.IsLockedOut,
            m.LastLockoutDate
    FROM    dbo.aspnet_Users u, dbo.aspnet_Membership m
    WHERE   @UserId = u.UserId AND u.UserId = m.UserId

    IF ( @@ROWCOUNT = 0 ) -- User ID not found
       RETURN -1

    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByName]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetUserByName]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    DECLARE @UserId uniqueidentifier

    IF (@UpdateLastActivity = 1)
    BEGIN
        -- select user ID from aspnet_users table
        SELECT TOP 1 @UserId = u.UserId
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE    LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                LOWER(@UserName) = u.LoweredUserName AND u.UserId = m.UserId

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1

        UPDATE   dbo.aspnet_Users
        SET      LastActivityDate = @CurrentTimeUtc
        WHERE    @UserId = UserId

        SELECT m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
                m.CreateDate, m.LastLoginDate, u.LastActivityDate, m.LastPasswordChangedDate,
                u.UserId, m.IsLockedOut, m.LastLockoutDate
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE  @UserId = u.UserId AND u.UserId = m.UserId 
    END
    ELSE
    BEGIN
        SELECT TOP 1 m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
                m.CreateDate, m.LastLoginDate, u.LastActivityDate, m.LastPasswordChangedDate,
                u.UserId, m.IsLockedOut,m.LastLockoutDate
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE    LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                LOWER(@UserName) = u.LoweredUserName AND u.UserId = m.UserId

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1
    END

    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByEmail]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetUserByEmail]
    @ApplicationName  nvarchar(256),
    @Email            nvarchar(256)
AS
BEGIN
    IF( @Email IS NULL )
        SELECT  u.UserName
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                u.UserId = m.UserId AND
                m.LoweredEmail IS NULL
    ELSE
        SELECT  u.UserName
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                u.UserId = m.UserId AND
                LOWER(@Email) = m.LoweredEmail

    IF (@@rowcount = 0)
        RETURN(1)
    RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetPasswordWithFormat]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetPasswordWithFormat]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @UpdateLastLoginActivityDate    bit,
    @CurrentTimeUtc                 datetime
AS
BEGIN
    DECLARE @IsLockedOut                        bit
    DECLARE @UserId                             uniqueidentifier
    DECLARE @Password                           nvarchar(128)
    DECLARE @PasswordSalt                       nvarchar(128)
    DECLARE @PasswordFormat                     int
    DECLARE @FailedPasswordAttemptCount         int
    DECLARE @FailedPasswordAnswerAttemptCount   int
    DECLARE @IsApproved                         bit
    DECLARE @LastActivityDate                   datetime
    DECLARE @LastLoginDate                      datetime

    SELECT  @UserId          = NULL

    SELECT  @UserId = u.UserId, @IsLockedOut = m.IsLockedOut, @Password=Password, @PasswordFormat=PasswordFormat,
            @PasswordSalt=PasswordSalt, @FailedPasswordAttemptCount=FailedPasswordAttemptCount,
		    @FailedPasswordAnswerAttemptCount=FailedPasswordAnswerAttemptCount, @IsApproved=IsApproved,
            @LastActivityDate = LastActivityDate, @LastLoginDate = LastLoginDate
    FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF (@UserId IS NULL)
        RETURN 1

    IF (@IsLockedOut = 1)
        RETURN 99

    SELECT   @Password, @PasswordFormat, @PasswordSalt, @FailedPasswordAttemptCount,
             @FailedPasswordAnswerAttemptCount, @IsApproved, @LastLoginDate, @LastActivityDate

    IF (@UpdateLastLoginActivityDate = 1 AND @IsApproved = 1)
    BEGIN
        UPDATE  dbo.aspnet_Membership
        SET     LastLoginDate = @CurrentTimeUtc
        WHERE   UserId = @UserId

        UPDATE  dbo.aspnet_Users
        SET     LastActivityDate = @CurrentTimeUtc
        WHERE   @UserId = UserId
    END


    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetPassword]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetPassword]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @MaxInvalidPasswordAttempts     int,
    @PasswordAttemptWindow          int,
    @CurrentTimeUtc                 datetime,
    @PasswordAnswer                 nvarchar(128) = NULL
AS
BEGIN
    DECLARE @UserId                                 uniqueidentifier
    DECLARE @PasswordFormat                         int
    DECLARE @Password                               nvarchar(128)
    DECLARE @passAns                                nvarchar(128)
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId,
            @Password = m.Password,
            @passAns = m.PasswordAnswer,
            @PasswordFormat = m.PasswordFormat,
            @IsLockedOut = m.IsLockedOut,
            @LastLockoutDate = m.LastLockoutDate,
            @FailedPasswordAttemptCount = m.FailedPasswordAttemptCount,
            @FailedPasswordAttemptWindowStart = m.FailedPasswordAttemptWindowStart,
            @FailedPasswordAnswerAttemptCount = m.FailedPasswordAnswerAttemptCount,
            @FailedPasswordAnswerAttemptWindowStart = m.FailedPasswordAnswerAttemptWindowStart
    FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m WITH ( UPDLOCK )
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF ( @@rowcount = 0 )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    IF( @IsLockedOut = 1 )
    BEGIN
        SET @ErrorCode = 99
        GOTO Cleanup
    END

    IF ( NOT( @PasswordAnswer IS NULL ) )
    BEGIN
        IF( ( @passAns IS NULL ) OR ( LOWER( @passAns ) <> LOWER( @PasswordAnswer ) ) )
        BEGIN
            IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAnswerAttemptWindowStart ) )
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = 1
            END
            ELSE
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount + 1
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
            END

            BEGIN
                IF( @FailedPasswordAnswerAttemptCount >= @MaxInvalidPasswordAttempts )
                BEGIN
                    SET @IsLockedOut = 1
                    SET @LastLockoutDate = @CurrentTimeUtc
                END
            END

            SET @ErrorCode = 3
        END
        ELSE
        BEGIN
            IF( @FailedPasswordAnswerAttemptCount > 0 )
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = 0
                SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            END
        END

        UPDATE dbo.aspnet_Membership
        SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
            FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
            FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
            FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
            FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
        WHERE @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    IF( @ErrorCode = 0 )
        SELECT @Password, @PasswordFormat

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetNumberOfUsersOnline]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetNumberOfUsersOnline]
    @ApplicationName            nvarchar(256),
    @MinutesSinceLastInActive   int,
    @CurrentTimeUtc             datetime
AS
BEGIN
    DECLARE @DateActive datetime
    SELECT  @DateActive = DATEADD(minute,  -(@MinutesSinceLastInActive), @CurrentTimeUtc)

    DECLARE @NumOnline int
    SELECT  @NumOnline = COUNT(*)
    FROM    dbo.aspnet_Users u(NOLOCK),
            dbo.aspnet_Applications a(NOLOCK),
            dbo.aspnet_Membership m(NOLOCK)
    WHERE   u.ApplicationId = a.ApplicationId                  AND
            LastActivityDate > @DateActive                     AND
            a.LoweredApplicationName = LOWER(@ApplicationName) AND
            u.UserId = m.UserId
    RETURN(@NumOnline)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetAllUsers]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetAllUsers]
    @ApplicationName       nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0


    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
    SELECT u.UserId
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u
    WHERE  u.ApplicationId = @ApplicationId AND u.UserId = m.UserId
    ORDER BY u.UserName

    SELECT @TotalRecords = @@ROWCOUNT

    SELECT u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY u.UserName
    RETURN @TotalRecords
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_FindUsersByName]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_FindUsersByName]
    @ApplicationName       nvarchar(256),
    @UserNameToMatch       nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
        SELECT u.UserId
        FROM   dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND u.LoweredUserName LIKE LOWER(@UserNameToMatch)
        ORDER BY u.UserName


    SELECT  u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY u.UserName

    SELECT  @TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers
    RETURN @TotalRecords
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_FindUsersByEmail]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_FindUsersByEmail]
    @ApplicationName       nvarchar(256),
    @EmailToMatch          nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    IF( @EmailToMatch IS NULL )
        INSERT INTO #PageIndexForUsers (UserId)
            SELECT u.UserId
            FROM   dbo.aspnet_Users u, dbo.aspnet_Membership m
            WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND m.Email IS NULL
            ORDER BY m.LoweredEmail
    ELSE
        INSERT INTO #PageIndexForUsers (UserId)
            SELECT u.UserId
            FROM   dbo.aspnet_Users u, dbo.aspnet_Membership m
            WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND m.LoweredEmail LIKE LOWER(@EmailToMatch)
            ORDER BY m.LoweredEmail

    SELECT  u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY m.LoweredEmail

    SELECT  @TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers
    RETURN @TotalRecords
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_CreateUser]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_CreateUser]
    @ApplicationName                        nvarchar(256),
    @UserName                               nvarchar(256),
    @Password                               nvarchar(128),
    @PasswordSalt                           nvarchar(128),
    @Email                                  nvarchar(256),
    @PasswordQuestion                       nvarchar(256),
    @PasswordAnswer                         nvarchar(128),
    @IsApproved                             bit,
    @CurrentTimeUtc                         datetime,
    @CreateDate                             datetime = NULL,
    @UniqueEmail                            int      = 0,
    @PasswordFormat                         int      = 0,
    @UserId                                 uniqueidentifier OUTPUT
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL

    DECLARE @NewUserId uniqueidentifier
    SELECT @NewUserId = NULL

    DECLARE @IsLockedOut bit
    SET @IsLockedOut = 0

    DECLARE @LastLockoutDate  datetime
    SET @LastLockoutDate = CONVERT( datetime, '17540101', 112 )

    DECLARE @FailedPasswordAttemptCount int
    SET @FailedPasswordAttemptCount = 0

    DECLARE @FailedPasswordAttemptWindowStart  datetime
    SET @FailedPasswordAttemptWindowStart = CONVERT( datetime, '17540101', 112 )

    DECLARE @FailedPasswordAnswerAttemptCount int
    SET @FailedPasswordAnswerAttemptCount = 0

    DECLARE @FailedPasswordAnswerAttemptWindowStart  datetime
    SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )

    DECLARE @NewUserCreated bit
    DECLARE @ReturnValue   int
    SET @ReturnValue = 0

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    EXEC dbo.aspnet_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    SET @CreateDate = @CurrentTimeUtc

    SELECT  @NewUserId = UserId FROM dbo.aspnet_Users WHERE LOWER(@UserName) = LoweredUserName AND @ApplicationId = ApplicationId
    IF ( @NewUserId IS NULL )
    BEGIN
        SET @NewUserId = @UserId
        EXEC @ReturnValue = dbo.aspnet_Users_CreateUser @ApplicationId, @UserName, 0, @CreateDate, @NewUserId OUTPUT
        SET @NewUserCreated = 1
    END
    ELSE
    BEGIN
        SET @NewUserCreated = 0
        IF( @NewUserId <> @UserId AND @UserId IS NOT NULL )
        BEGIN
            SET @ErrorCode = 6
            GOTO Cleanup
        END
    END

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @ReturnValue = -1 )
    BEGIN
        SET @ErrorCode = 10
        GOTO Cleanup
    END

    IF ( EXISTS ( SELECT UserId
                  FROM   dbo.aspnet_Membership
                  WHERE  @NewUserId = UserId ) )
    BEGIN
        SET @ErrorCode = 6
        GOTO Cleanup
    END

    SET @UserId = @NewUserId

    IF (@UniqueEmail = 1)
    BEGIN
        IF (EXISTS (SELECT *
                    FROM  dbo.aspnet_Membership m WITH ( UPDLOCK, HOLDLOCK )
                    WHERE ApplicationId = @ApplicationId AND LoweredEmail = LOWER(@Email)))
        BEGIN
            SET @ErrorCode = 7
            GOTO Cleanup
        END
    END

    IF (@NewUserCreated = 0)
    BEGIN
        UPDATE dbo.aspnet_Users
        SET    LastActivityDate = @CreateDate
        WHERE  @UserId = UserId
        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    INSERT INTO dbo.aspnet_Membership
                ( ApplicationId,
                  UserId,
                  Password,
                  PasswordSalt,
                  Email,
                  LoweredEmail,
                  PasswordQuestion,
                  PasswordAnswer,
                  PasswordFormat,
                  IsApproved,
                  IsLockedOut,
                  CreateDate,
                  LastLoginDate,
                  LastPasswordChangedDate,
                  LastLockoutDate,
                  FailedPasswordAttemptCount,
                  FailedPasswordAttemptWindowStart,
                  FailedPasswordAnswerAttemptCount,
                  FailedPasswordAnswerAttemptWindowStart )
         VALUES ( @ApplicationId,
                  @UserId,
                  @Password,
                  @PasswordSalt,
                  @Email,
                  LOWER(@Email),
                  @PasswordQuestion,
                  @PasswordAnswer,
                  @PasswordFormat,
                  @IsApproved,
                  @IsLockedOut,
                  @CreateDate,
                  @CreateDate,
                  @CreateDate,
                  @LastLockoutDate,
                  @FailedPasswordAttemptCount,
                  @FailedPasswordAttemptWindowStart,
                  @FailedPasswordAnswerAttemptCount,
                  @FailedPasswordAnswerAttemptWindowStart )

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
	    SET @TranStarted = 0
	    COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_ChangePasswordQuestionAndAnswer]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_ChangePasswordQuestionAndAnswer]
    @ApplicationName       nvarchar(256),
    @UserName              nvarchar(256),
    @NewPasswordQuestion   nvarchar(256),
    @NewPasswordAnswer     nvarchar(128)
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Membership m, dbo.aspnet_Users u, dbo.aspnet_Applications a
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId
    IF (@UserId IS NULL)
    BEGIN
        RETURN(1)
    END

    UPDATE dbo.aspnet_Membership
    SET    PasswordQuestion = @NewPasswordQuestion, PasswordAnswer = @NewPasswordAnswer
    WHERE  UserId=@UserId
    RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_AnyDataInTables]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_AnyDataInTables]
    @TablesToCheck int
AS
BEGIN
    -- Check Membership table if (@TablesToCheck & 1) is set
    IF ((@TablesToCheck & 1) <> 0 AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_MembershipUsers') AND (type = 'V'))))
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_Membership))
        BEGIN
            SELECT N'aspnet_Membership'
            RETURN
        END
    END

    -- Check aspnet_Roles table if (@TablesToCheck & 2) is set
    IF ((@TablesToCheck & 2) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_Roles') AND (type = 'V'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 RoleId FROM dbo.aspnet_Roles))
        BEGIN
            SELECT N'aspnet_Roles'
            RETURN
        END
    END

    -- Check aspnet_Profile table if (@TablesToCheck & 4) is set
    IF ((@TablesToCheck & 4) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_Profiles') AND (type = 'V'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_Profile))
        BEGIN
            SELECT N'aspnet_Profile'
            RETURN
        END
    END

    -- Check aspnet_PersonalizationPerUser table if (@TablesToCheck & 8) is set
    IF ((@TablesToCheck & 8) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_WebPartState_User') AND (type = 'V'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_PersonalizationPerUser))
        BEGIN
            SELECT N'aspnet_PersonalizationPerUser'
            RETURN
        END
    END

    -- Check aspnet_PersonalizationPerUser table if (@TablesToCheck & 16) is set
    IF ((@TablesToCheck & 16) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'aspnet_WebEvent_LogEvent') AND (type = 'P'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 * FROM dbo.aspnet_WebEvent_Events))
        BEGIN
            SELECT N'aspnet_WebEvent_Events'
            RETURN
        END
    END

    -- Check aspnet_Users table if (@TablesToCheck & 1,2,4 & 8) are all set
    IF ((@TablesToCheck & 1) <> 0 AND
        (@TablesToCheck & 2) <> 0 AND
        (@TablesToCheck & 4) <> 0 AND
        (@TablesToCheck & 8) <> 0 AND
        (@TablesToCheck & 32) <> 0 AND
        (@TablesToCheck & 128) <> 0 AND
        (@TablesToCheck & 256) <> 0 AND
        (@TablesToCheck & 512) <> 0 AND
        (@TablesToCheck & 1024) <> 0)
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_Users))
        BEGIN
            SELECT N'aspnet_Users'
            RETURN
        END
        IF (EXISTS(SELECT TOP 1 ApplicationId FROM dbo.aspnet_Applications))
        BEGIN
            SELECT N'aspnet_Applications'
            RETURN
        END
    END
END
GO
/****** Object:  StoredProcedure [dbo].[AddOrderProduct]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddOrderProduct] 
	@OrderID int,
    @ProductID int,
    @Quantity int,
    @PricePerUnit money,
    @TotalPrice money,
    @Discount money,
    @Shipping money,
    @DownloadKey varchar(50) = NULL,
    @DownloadURL varchar(400) = NULL,
    @OrderDate datetime,
    @Active bit
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO OrderProduct(
		OrderID,
        ProductID,
        Quantity,
        PricePerUnit,
        TotalPrice,
        Discount,
        Shipping,
        DownloadKey,
		DownloadURL,
        OrderDate,
        Active
     )VALUES(
		@OrderID,
		@ProductID,
		@Quantity,
		@PricePerUnit,
		@TotalPrice,
		@Discount,
		@Shipping,
		@DownloadKey,
		@DownloadURL,
		@OrderDate,
		@Active)
	
	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddCustomer]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddCustomer] 
	@MemberID uniqueidentifier,
	@Company varchar(50) = null,
    @FirstName varchar(50) = null,
    @LastName varchar(50) = null,
    @Address varchar(50) = null,
    @City varchar(50) = null,
    @StateID int = null,
	@ProvinceID int = null,
    @CountryID int = null,
    @Zipcode varchar(50) = null,
    @DayPhone varchar(50) = null,
    @EveningPhone varchar(50) = null,
    @CellPhone varchar(50) = null,
    @Fax varchar(50) = null,
    @Email varchar(50),
    @DateCreated datetime,
    @DateUpdated datetime = GETDATE,
    @Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Customer(
		MemberID,
        Company,
        FirstName,
        LastName,
        Address,
        City,
        StateID,
		ProvinceID,
        CountryID,
        Zipcode,
        DayPhone,
        EveningPhone,
        CellPhone,
        Fax,
        Email,
        DateCreated,
        DateUpdated,
        Active
	)VALUES(
		@MemberID,
		@Company,
		@FirstName,
		@LastName,
		@Address,
		@City,
		@StateID,
		@ProvinceID,
		@CountryID,
		@Zipcode,
		@DayPhone,
		@EveningPhone,
		@CellPhone,
		@Fax,
		@Email,
		@DateCreated,
		@DateUpdated,
		@Active)

	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Users_DeleteUser]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Users_DeleteUser]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @TablesToDeleteFrom int,
    @NumTablesDeletedFrom int OUTPUT
AS
BEGIN
    DECLARE @UserId               uniqueidentifier
    SELECT  @UserId               = NULL
    SELECT  @NumTablesDeletedFrom = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
	SET @TranStarted = 0

    DECLARE @ErrorCode   int
    DECLARE @RowCount    int

    SET @ErrorCode = 0
    SET @RowCount  = 0

    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a
    WHERE   u.LoweredUserName       = LOWER(@UserName)
        AND u.ApplicationId         = a.ApplicationId
        AND LOWER(@ApplicationName) = a.LoweredApplicationName

    IF (@UserId IS NULL)
    BEGIN
        GOTO Cleanup
    END

    -- Delete from Membership table if (@TablesToDeleteFrom & 1) is set
    IF ((@TablesToDeleteFrom & 1) <> 0 AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_MembershipUsers') AND (type = 'V'))))
    BEGIN
        DELETE FROM dbo.aspnet_Membership WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
               @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_UsersInRoles table if (@TablesToDeleteFrom & 2) is set
    IF ((@TablesToDeleteFrom & 2) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_UsersInRoles') AND (type = 'V'))) )
    BEGIN
        DELETE FROM dbo.aspnet_UsersInRoles WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_Profile table if (@TablesToDeleteFrom & 4) is set
    IF ((@TablesToDeleteFrom & 4) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_Profiles') AND (type = 'V'))) )
    BEGIN
        DELETE FROM dbo.aspnet_Profile WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_PersonalizationPerUser table if (@TablesToDeleteFrom & 8) is set
    IF ((@TablesToDeleteFrom & 8) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_WebPartState_User') AND (type = 'V'))) )
    BEGIN
        DELETE FROM dbo.aspnet_PersonalizationPerUser WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_Users table if (@TablesToDeleteFrom & 1,2,4 & 8) are all set
    IF ((@TablesToDeleteFrom & 1) <> 0 AND
        (@TablesToDeleteFrom & 2) <> 0 AND
        (@TablesToDeleteFrom & 4) <> 0 AND
        (@TablesToDeleteFrom & 8) <> 0 AND
        (EXISTS (SELECT UserId FROM dbo.aspnet_Users WHERE @UserId = UserId)))
    BEGIN
        DELETE FROM dbo.aspnet_Users WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    IF( @TranStarted = 1 )
    BEGIN
	    SET @TranStarted = 0
	    COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:
    SET @NumTablesDeletedFrom = 0

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
	    ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Roles_DeleteRole]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Roles_DeleteRole]
    @ApplicationName            nvarchar(256),
    @RoleName                   nvarchar(256),
    @DeleteOnlyIfRoleIsEmpty    bit
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(1)

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
        BEGIN TRANSACTION
        SET @TranStarted = 1
    END
    ELSE
        SET @TranStarted = 0

    DECLARE @RoleId   uniqueidentifier
    SELECT  @RoleId = NULL
    SELECT  @RoleId = RoleId FROM dbo.aspnet_Roles WHERE LoweredRoleName = LOWER(@RoleName) AND ApplicationId = @ApplicationId

    IF (@RoleId IS NULL)
    BEGIN
        SELECT @ErrorCode = 1
        GOTO Cleanup
    END
    IF (@DeleteOnlyIfRoleIsEmpty <> 0)
    BEGIN
        IF (EXISTS (SELECT RoleId FROM dbo.aspnet_UsersInRoles  WHERE @RoleId = RoleId))
        BEGIN
            SELECT @ErrorCode = 2
            GOTO Cleanup
        END
    END


    DELETE FROM dbo.aspnet_UsersInRoles  WHERE @RoleId = RoleId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    DELETE FROM dbo.aspnet_Roles WHERE @RoleId = RoleId  AND ApplicationId = @ApplicationId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        COMMIT TRANSACTION
    END

    RETURN(0)

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Profile_SetProperties]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Profile_SetProperties]
    @ApplicationName        nvarchar(256),
    @PropertyNames          ntext,
    @PropertyValuesString   ntext,
    @PropertyValuesBinary   image,
    @UserName               nvarchar(256),
    @IsUserAnonymous        bit,
    @CurrentTimeUtc         datetime
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
       BEGIN TRANSACTION
       SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    EXEC dbo.aspnet_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    DECLARE @UserId uniqueidentifier
    DECLARE @LastActivityDate datetime
    SELECT  @UserId = NULL
    SELECT  @LastActivityDate = @CurrentTimeUtc

    SELECT @UserId = UserId
    FROM   dbo.aspnet_Users
    WHERE  ApplicationId = @ApplicationId AND LoweredUserName = LOWER(@UserName)
    IF (@UserId IS NULL)
        EXEC dbo.aspnet_Users_CreateUser @ApplicationId, @UserName, @IsUserAnonymous, @LastActivityDate, @UserId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    UPDATE dbo.aspnet_Users
    SET    LastActivityDate=@CurrentTimeUtc
    WHERE  UserId = @UserId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF (EXISTS( SELECT *
               FROM   dbo.aspnet_Profile
               WHERE  UserId = @UserId))
        UPDATE dbo.aspnet_Profile
        SET    PropertyNames=@PropertyNames, PropertyValuesString = @PropertyValuesString,
               PropertyValuesBinary = @PropertyValuesBinary, LastUpdatedDate=@CurrentTimeUtc
        WHERE  UserId = @UserId
    ELSE
        INSERT INTO dbo.aspnet_Profile(UserId, PropertyNames, PropertyValuesString, PropertyValuesBinary, LastUpdatedDate)
             VALUES (@UserId, @PropertyNames, @PropertyValuesString, @PropertyValuesBinary, @CurrentTimeUtc)

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
    	SET @TranStarted = 0
    	COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Profile_GetProperties]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Profile_GetProperties]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @CurrentTimeUtc       datetime
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN

    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL

    SELECT @UserId = UserId
    FROM   dbo.aspnet_Users
    WHERE  ApplicationId = @ApplicationId AND LoweredUserName = LOWER(@UserName)

    IF (@UserId IS NULL)
        RETURN
    SELECT TOP 1 PropertyNames, PropertyValuesString, PropertyValuesBinary
    FROM         dbo.aspnet_Profile
    WHERE        UserId = @UserId

    IF (@@ROWCOUNT > 0)
    BEGIN
        UPDATE dbo.aspnet_Users
        SET    LastActivityDate=@CurrentTimeUtc
        WHERE  UserId = @UserId
    END
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Profile_GetProfiles]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Profile_GetProfiles]
    @ApplicationName        nvarchar(256),
    @ProfileAuthOptions     int,
    @PageIndex              int,
    @PageSize               int,
    @UserNameToMatch        nvarchar(256) = NULL,
    @InactiveSinceDate      datetime      = NULL
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
        SELECT  u.UserId
        FROM    dbo.aspnet_Users u, dbo.aspnet_Profile p
        WHERE   ApplicationId = @ApplicationId
            AND u.UserId = p.UserId
            AND (@InactiveSinceDate IS NULL OR LastActivityDate <= @InactiveSinceDate)
            AND (     (@ProfileAuthOptions = 2)
                   OR (@ProfileAuthOptions = 0 AND IsAnonymous = 1)
                   OR (@ProfileAuthOptions = 1 AND IsAnonymous = 0)
                 )
            AND (@UserNameToMatch IS NULL OR LoweredUserName LIKE LOWER(@UserNameToMatch))
        ORDER BY UserName

    SELECT  u.UserName, u.IsAnonymous, u.LastActivityDate, p.LastUpdatedDate,
            DATALENGTH(p.PropertyNames) + DATALENGTH(p.PropertyValuesString) + DATALENGTH(p.PropertyValuesBinary)
    FROM    dbo.aspnet_Users u, dbo.aspnet_Profile p, #PageIndexForUsers i
    WHERE   u.UserId = p.UserId AND p.UserId = i.UserId AND i.IndexId >= @PageLowerBound AND i.IndexId <= @PageUpperBound

    SELECT COUNT(*)
    FROM   #PageIndexForUsers

    DROP TABLE #PageIndexForUsers
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Profile_GetNumberOfInactiveProfiles]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Profile_GetNumberOfInactiveProfiles]
    @ApplicationName        nvarchar(256),
    @ProfileAuthOptions     int,
    @InactiveSinceDate      datetime
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
    BEGIN
        SELECT 0
        RETURN
    END

    SELECT  COUNT(*)
    FROM    dbo.aspnet_Users u, dbo.aspnet_Profile p
    WHERE   ApplicationId = @ApplicationId
        AND u.UserId = p.UserId
        AND (LastActivityDate <= @InactiveSinceDate)
        AND (
                (@ProfileAuthOptions = 2)
                OR (@ProfileAuthOptions = 0 AND IsAnonymous = 1)
                OR (@ProfileAuthOptions = 1 AND IsAnonymous = 0)
            )
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UsersInRoles_RemoveUsersFromRoles]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_UsersInRoles_RemoveUsersFromRoles]
	@ApplicationName  nvarchar(256),
	@UserNames		  nvarchar(4000),
	@RoleNames		  nvarchar(4000)
AS
BEGIN
	DECLARE @AppId uniqueidentifier
	SELECT  @AppId = NULL
	SELECT  @AppId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
	IF (@AppId IS NULL)
		RETURN(2)


	DECLARE @TranStarted   bit
	SET @TranStarted = 0

	IF( @@TRANCOUNT = 0 )
	BEGIN
		BEGIN TRANSACTION
		SET @TranStarted = 1
	END

	DECLARE @tbNames  table(Name nvarchar(256) NOT NULL PRIMARY KEY)
	DECLARE @tbRoles  table(RoleId uniqueidentifier NOT NULL PRIMARY KEY)
	DECLARE @tbUsers  table(UserId uniqueidentifier NOT NULL PRIMARY KEY)
	DECLARE @Num	  int
	DECLARE @Pos	  int
	DECLARE @NextPos  int
	DECLARE @Name	  nvarchar(256)
	DECLARE @CountAll int
	DECLARE @CountU	  int
	DECLARE @CountR	  int


	SET @Num = 0
	SET @Pos = 1
	WHILE(@Pos <= LEN(@RoleNames))
	BEGIN
		SELECT @NextPos = CHARINDEX(N',', @RoleNames,  @Pos)
		IF (@NextPos = 0 OR @NextPos IS NULL)
			SELECT @NextPos = LEN(@RoleNames) + 1
		SELECT @Name = RTRIM(LTRIM(SUBSTRING(@RoleNames, @Pos, @NextPos - @Pos)))
		SELECT @Pos = @NextPos+1

		INSERT INTO @tbNames VALUES (@Name)
		SET @Num = @Num + 1
	END

	INSERT INTO @tbRoles
	  SELECT RoleId
	  FROM   dbo.aspnet_Roles ar, @tbNames t
	  WHERE  LOWER(t.Name) = ar.LoweredRoleName AND ar.ApplicationId = @AppId
	SELECT @CountR = @@ROWCOUNT

	IF (@CountR <> @Num)
	BEGIN
		SELECT TOP 1 N'', Name
		FROM   @tbNames
		WHERE  LOWER(Name) NOT IN (SELECT ar.LoweredRoleName FROM dbo.aspnet_Roles ar,  @tbRoles r WHERE r.RoleId = ar.RoleId)
		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(2)
	END


	DELETE FROM @tbNames WHERE 1=1
	SET @Num = 0
	SET @Pos = 1


	WHILE(@Pos <= LEN(@UserNames))
	BEGIN
		SELECT @NextPos = CHARINDEX(N',', @UserNames,  @Pos)
		IF (@NextPos = 0 OR @NextPos IS NULL)
			SELECT @NextPos = LEN(@UserNames) + 1
		SELECT @Name = RTRIM(LTRIM(SUBSTRING(@UserNames, @Pos, @NextPos - @Pos)))
		SELECT @Pos = @NextPos+1

		INSERT INTO @tbNames VALUES (@Name)
		SET @Num = @Num + 1
	END

	INSERT INTO @tbUsers
	  SELECT UserId
	  FROM   dbo.aspnet_Users ar, @tbNames t
	  WHERE  LOWER(t.Name) = ar.LoweredUserName AND ar.ApplicationId = @AppId

	SELECT @CountU = @@ROWCOUNT
	IF (@CountU <> @Num)
	BEGIN
		SELECT TOP 1 Name, N''
		FROM   @tbNames
		WHERE  LOWER(Name) NOT IN (SELECT au.LoweredUserName FROM dbo.aspnet_Users au,  @tbUsers u WHERE u.UserId = au.UserId)

		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(1)
	END

	SELECT  @CountAll = COUNT(*)
	FROM	dbo.aspnet_UsersInRoles ur, @tbUsers u, @tbRoles r
	WHERE   ur.UserId = u.UserId AND ur.RoleId = r.RoleId

	IF (@CountAll <> @CountU * @CountR)
	BEGIN
		SELECT TOP 1 UserName, RoleName
		FROM		 @tbUsers tu, @tbRoles tr, dbo.aspnet_Users u, dbo.aspnet_Roles r
		WHERE		 u.UserId = tu.UserId AND r.RoleId = tr.RoleId AND
					 tu.UserId NOT IN (SELECT ur.UserId FROM dbo.aspnet_UsersInRoles ur WHERE ur.RoleId = tr.RoleId) AND
					 tr.RoleId NOT IN (SELECT ur.RoleId FROM dbo.aspnet_UsersInRoles ur WHERE ur.UserId = tu.UserId)
		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(3)
	END

	DELETE FROM dbo.aspnet_UsersInRoles
	WHERE UserId IN (SELECT UserId FROM @tbUsers)
	  AND RoleId IN (SELECT RoleId FROM @tbRoles)
	IF( @TranStarted = 1 )
		COMMIT TRANSACTION
	RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UsersInRoles_IsUserInRole]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_UsersInRoles_IsUserInRole]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(2)
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    DECLARE @RoleId uniqueidentifier
    SELECT  @RoleId = NULL

    SELECT  @UserId = UserId
    FROM    dbo.aspnet_Users
    WHERE   LoweredUserName = LOWER(@UserName) AND ApplicationId = @ApplicationId

    IF (@UserId IS NULL)
        RETURN(2)

    SELECT  @RoleId = RoleId
    FROM    dbo.aspnet_Roles
    WHERE   LoweredRoleName = LOWER(@RoleName) AND ApplicationId = @ApplicationId

    IF (@RoleId IS NULL)
        RETURN(3)

    IF (EXISTS( SELECT * FROM dbo.aspnet_UsersInRoles WHERE  UserId = @UserId AND RoleId = @RoleId))
        RETURN(1)
    ELSE
        RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UsersInRoles_GetUsersInRoles]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_UsersInRoles_GetUsersInRoles]
    @ApplicationName  nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(1)
     DECLARE @RoleId uniqueidentifier
     SELECT  @RoleId = NULL

     SELECT  @RoleId = RoleId
     FROM    dbo.aspnet_Roles
     WHERE   LOWER(@RoleName) = LoweredRoleName AND ApplicationId = @ApplicationId

     IF (@RoleId IS NULL)
         RETURN(1)

    SELECT u.UserName
    FROM   dbo.aspnet_Users u, dbo.aspnet_UsersInRoles ur
    WHERE  u.UserId = ur.UserId AND @RoleId = ur.RoleId AND u.ApplicationId = @ApplicationId
    ORDER BY u.UserName
    RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UsersInRoles_GetRolesForUser]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_UsersInRoles_GetRolesForUser]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(1)
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL

    SELECT  @UserId = UserId
    FROM    dbo.aspnet_Users
    WHERE   LoweredUserName = LOWER(@UserName) AND ApplicationId = @ApplicationId

    IF (@UserId IS NULL)
        RETURN(1)

    SELECT r.RoleName
    FROM   dbo.aspnet_Roles r, dbo.aspnet_UsersInRoles ur
    WHERE  r.RoleId = ur.RoleId AND r.ApplicationId = @ApplicationId AND ur.UserId = @UserId
    ORDER BY r.RoleName
    RETURN (0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UsersInRoles_FindUsersInRole]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_UsersInRoles_FindUsersInRole]
    @ApplicationName  nvarchar(256),
    @RoleName         nvarchar(256),
    @UserNameToMatch  nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(1)
     DECLARE @RoleId uniqueidentifier
     SELECT  @RoleId = NULL

     SELECT  @RoleId = RoleId
     FROM    dbo.aspnet_Roles
     WHERE   LOWER(@RoleName) = LoweredRoleName AND ApplicationId = @ApplicationId

     IF (@RoleId IS NULL)
         RETURN(1)

    SELECT u.UserName
    FROM   dbo.aspnet_Users u, dbo.aspnet_UsersInRoles ur
    WHERE  u.UserId = ur.UserId AND @RoleId = ur.RoleId AND u.ApplicationId = @ApplicationId AND LoweredUserName LIKE LOWER(@UserNameToMatch)
    ORDER BY u.UserName
    RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UsersInRoles_AddUsersToRoles]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_UsersInRoles_AddUsersToRoles]
	@ApplicationName  nvarchar(256),
	@UserNames		  nvarchar(4000),
	@RoleNames		  nvarchar(4000),
	@CurrentTimeUtc   datetime
AS
BEGIN
	DECLARE @AppId uniqueidentifier
	SELECT  @AppId = NULL
	SELECT  @AppId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
	IF (@AppId IS NULL)
		RETURN(2)
	DECLARE @TranStarted   bit
	SET @TranStarted = 0

	IF( @@TRANCOUNT = 0 )
	BEGIN
		BEGIN TRANSACTION
		SET @TranStarted = 1
	END

	DECLARE @tbNames	table(Name nvarchar(256) NOT NULL PRIMARY KEY)
	DECLARE @tbRoles	table(RoleId uniqueidentifier NOT NULL PRIMARY KEY)
	DECLARE @tbUsers	table(UserId uniqueidentifier NOT NULL PRIMARY KEY)
	DECLARE @Num		int
	DECLARE @Pos		int
	DECLARE @NextPos	int
	DECLARE @Name		nvarchar(256)

	SET @Num = 0
	SET @Pos = 1
	WHILE(@Pos <= LEN(@RoleNames))
	BEGIN
		SELECT @NextPos = CHARINDEX(N',', @RoleNames,  @Pos)
		IF (@NextPos = 0 OR @NextPos IS NULL)
			SELECT @NextPos = LEN(@RoleNames) + 1
		SELECT @Name = RTRIM(LTRIM(SUBSTRING(@RoleNames, @Pos, @NextPos - @Pos)))
		SELECT @Pos = @NextPos+1

		INSERT INTO @tbNames VALUES (@Name)
		SET @Num = @Num + 1
	END

	INSERT INTO @tbRoles
	  SELECT RoleId
	  FROM   dbo.aspnet_Roles ar, @tbNames t
	  WHERE  LOWER(t.Name) = ar.LoweredRoleName AND ar.ApplicationId = @AppId

	IF (@@ROWCOUNT <> @Num)
	BEGIN
		SELECT TOP 1 Name
		FROM   @tbNames
		WHERE  LOWER(Name) NOT IN (SELECT ar.LoweredRoleName FROM dbo.aspnet_Roles ar,  @tbRoles r WHERE r.RoleId = ar.RoleId)
		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(2)
	END

	DELETE FROM @tbNames WHERE 1=1
	SET @Num = 0
	SET @Pos = 1

	WHILE(@Pos <= LEN(@UserNames))
	BEGIN
		SELECT @NextPos = CHARINDEX(N',', @UserNames,  @Pos)
		IF (@NextPos = 0 OR @NextPos IS NULL)
			SELECT @NextPos = LEN(@UserNames) + 1
		SELECT @Name = RTRIM(LTRIM(SUBSTRING(@UserNames, @Pos, @NextPos - @Pos)))
		SELECT @Pos = @NextPos+1

		INSERT INTO @tbNames VALUES (@Name)
		SET @Num = @Num + 1
	END

	INSERT INTO @tbUsers
	  SELECT UserId
	  FROM   dbo.aspnet_Users ar, @tbNames t
	  WHERE  LOWER(t.Name) = ar.LoweredUserName AND ar.ApplicationId = @AppId

	IF (@@ROWCOUNT <> @Num)
	BEGIN
		DELETE FROM @tbNames
		WHERE LOWER(Name) IN (SELECT LoweredUserName FROM dbo.aspnet_Users au,  @tbUsers u WHERE au.UserId = u.UserId)

		INSERT dbo.aspnet_Users (ApplicationId, UserId, UserName, LoweredUserName, IsAnonymous, LastActivityDate)
		  SELECT @AppId, NEWID(), Name, LOWER(Name), 0, @CurrentTimeUtc
		  FROM   @tbNames

		INSERT INTO @tbUsers
		  SELECT  UserId
		  FROM	dbo.aspnet_Users au, @tbNames t
		  WHERE   LOWER(t.Name) = au.LoweredUserName AND au.ApplicationId = @AppId
	END

	IF (EXISTS (SELECT * FROM dbo.aspnet_UsersInRoles ur, @tbUsers tu, @tbRoles tr WHERE tu.UserId = ur.UserId AND tr.RoleId = ur.RoleId))
	BEGIN
		SELECT TOP 1 UserName, RoleName
		FROM		 dbo.aspnet_UsersInRoles ur, @tbUsers tu, @tbRoles tr, aspnet_Users u, aspnet_Roles r
		WHERE		u.UserId = tu.UserId AND r.RoleId = tr.RoleId AND tu.UserId = ur.UserId AND tr.RoleId = ur.RoleId

		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(3)
	END

	INSERT INTO dbo.aspnet_UsersInRoles (UserId, RoleId)
	SELECT UserId, RoleId
	FROM @tbUsers, @tbRoles

	IF( @TranStarted = 1 )
		COMMIT TRANSACTION
	RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerMemberID]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCustomerMemberID]
	@CustomerID int
AS
BEGIN
	SELECT
		MemberID
	FROM
		Customer WITH(NOLOCK)
	WHERE
		CustomerID = @CustomerID
END
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerID]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCustomerID]
	@MemberID uniqueidentifier
AS
BEGIN
	SELECT
		CustomerID
	FROM
		Customer WITH(NOLOCK)
	WHERE
		MemberID = @MemberID
END
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerEmail]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCustomerEmail]
	@CustomerID int,
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		Email
	FROM
		Customer WITH(NOLOCK)
	WHERE
		CustomerID = @CustomerID AND
		Active = @Active
END
GO
/****** Object:  StoredProcedure [dbo].[GetCustomer]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCustomer]
	@CustomerID int = NULL,
	@MemberID uniqueidentifier = NULL,
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	IF @CustomerID IS NOT NULL
		BEGIN
			SELECT
				CustomerID,
				MemberID,
				Company,
				FirstName,
				LastName,
				Address,
				City,
				StateID,
				ProvinceID,
				CountryID,
				Zipcode,
				DayPhone,
				EveningPhone,
				CellPhone,
				Fax,
				Email,
				DateCreated,
				DateUpdated,
				Active
			FROM
				Customer WITH(NOLOCK)
			WHERE
				CustomerID = @CustomerID AND
				Active = @Active
		END
	ELSE IF @MemberID IS NOT NULL
		BEGIN
			SELECT
				CustomerID,
				MemberID,
				Company,
				FirstName,
				LastName,
				Address,
				City,
				StateID,
				ProvinceID,
				CountryID,
				Zipcode,
				DayPhone,
				EveningPhone,
				CellPhone,
				Fax,
				Email,
				DateCreated,
				DateUpdated,
				Active
			FROM
				Customer
			WHERE
				MemberID = @MemberID AND
				Active = @Active
		END

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Profile_DeleteInactiveProfiles]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Profile_DeleteInactiveProfiles]
    @ApplicationName        nvarchar(256),
    @ProfileAuthOptions     int,
    @InactiveSinceDate      datetime
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
    BEGIN
        SELECT  0
        RETURN
    END

    DELETE
    FROM    dbo.aspnet_Profile
    WHERE   UserId IN
            (   SELECT  UserId
                FROM    dbo.aspnet_Users u
                WHERE   ApplicationId = @ApplicationId
                        AND (LastActivityDate <= @InactiveSinceDate)
                        AND (
                                (@ProfileAuthOptions = 2)
                             OR (@ProfileAuthOptions = 0 AND IsAnonymous = 1)
                             OR (@ProfileAuthOptions = 1 AND IsAnonymous = 0)
                            )
            )

    SELECT  @@ROWCOUNT
END
GO
/****** Object:  StoredProcedure [dbo].[AddProductReview]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddProductReview]
	@ProductID int,
    @CustomerID int,
    @ReviewText varchar(500),
    @Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO ProductReview(
		ProductID,
		CustomerID,
		ReviewText,
		ReviewDate,
		Active
	)VALUES(
		@ProductID,
		@CustomerID,
		@ReviewText,
		GETDATE(),
		@Active)
    
    SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Profile_DeleteProfiles]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Profile_DeleteProfiles]
    @ApplicationName        nvarchar(256),
    @UserNames              nvarchar(4000)
AS
BEGIN
    DECLARE @UserName     nvarchar(256)
    DECLARE @CurrentPos   int
    DECLARE @NextPos      int
    DECLARE @NumDeleted   int
    DECLARE @DeletedUser  int
    DECLARE @TranStarted  bit
    DECLARE @ErrorCode    int

    SET @ErrorCode = 0
    SET @CurrentPos = 1
    SET @NumDeleted = 0
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
        BEGIN TRANSACTION
        SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    WHILE (@CurrentPos <= LEN(@UserNames))
    BEGIN
        SELECT @NextPos = CHARINDEX(N',', @UserNames,  @CurrentPos)
        IF (@NextPos = 0 OR @NextPos IS NULL)
            SELECT @NextPos = LEN(@UserNames) + 1

        SELECT @UserName = SUBSTRING(@UserNames, @CurrentPos, @NextPos - @CurrentPos)
        SELECT @CurrentPos = @NextPos+1

        IF (LEN(@UserName) > 0)
        BEGIN
            SELECT @DeletedUser = 0
            EXEC dbo.aspnet_Users_DeleteUser @ApplicationName, @UserName, 4, @DeletedUser OUTPUT
            IF( @@ERROR <> 0 )
            BEGIN
                SET @ErrorCode = -1
                GOTO Cleanup
            END
            IF (@DeletedUser <> 0)
                SELECT @NumDeleted = @NumDeleted + 1
        END
    END
    SELECT @NumDeleted
    IF (@TranStarted = 1)
    BEGIN
    	SET @TranStarted = 0
    	COMMIT TRANSACTION
    END
    SET @TranStarted = 0

    RETURN 0

Cleanup:
    IF (@TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END
    RETURN @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[AddGiftRegistry]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddGiftRegistry] 
	@CustomerID INT,
	@Active BIT = 1
AS
BEGIN
	
	SET NOCOUNT ON;

    INSERT INTO GiftRegistry(
		CustomerID, 
		DateCreated,
		IsPublic,
		Active
	)VALUES(
		@CustomerID,
        GETDATE(),
        1,
        @Active
    )
    
	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddOrderProductOption]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddOrderProductOption] 
	@OrderProductID int,
    @ProductOptionID int,
    @Active bit = 1
AS
BEGIN
	
	SET NOCOUNT ON;

    INSERT INTO OrderProductOption(
		OrderProductID,
        ProductOptionID,
        Active
	)VALUES(
		@OrderProductID,
        @ProductOptionID,
        @Active)

	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddOrderProductCustomField]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddOrderProductCustomField]
	@OrderProductID int,
    @CustomFieldID int,
    @OrderProductCustomFieldValue varchar(400),
    @Active bit = 1
AS
BEGIN
	
	SET NOCOUNT ON;

    INSERT INTO OrderProductCustomField(
		OrderProductID,
        CustomFieldID,
        OrderProductCustomFieldValue,
        Active
     )VALUES(
        @OrderProductID,
        @CustomFieldID,
        @OrderProductCustomFieldValue,
        @Active)

	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  Table [dbo].[ProductReviewCaregoryProductReview]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductReviewCaregoryProductReview](
	[ProductReviewCaregoryProductReviewID] [int] IDENTITY(1,1) NOT NULL,
	[ProductReviewCategoryID] [int] NOT NULL,
	[ProductReviewID] [int] NOT NULL,
	[Rating] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_ProductReviewCaregoryProductReview] PRIMARY KEY CLUSTERED 
(
	[ProductReviewCaregoryProductReviewID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GiftRegistryProduct]    Script Date: 10/27/2011 09:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GiftRegistryProduct](
	[GiftRegistryProductID] [int] IDENTITY(1,1) NOT NULL,
	[GiftRegistryID] [int] NOT NULL,
	[ProductID] [int] NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_GiftRegistryProduct] PRIMARY KEY CLUSTERED 
(
	[GiftRegistryProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetGiftRegistry]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetGiftRegistry]
	@GiftRegistryID INT = 0,
	@CustomerID INT = 0,
	@Email VARCHAR(50) = NULL,
	@Active BIT = 1
AS
BEGIN
	SET NOCOUNT ON;

	IF @Email IS NULL
		BEGIN
			IF @CustomerID > 0
				BEGIN
					SELECT 
						GR.GiftRegistryID,
						C.CustomerID,
						C.FirstName,
						C.LastName,
						GR.DateCreated,
						GR.IsPublic,
						GR.Active
					FROM 
						GiftRegistry GR WITH(NOLOCK) INNER JOIN Customer C WITH(NOLOCK) ON
						GR.CustomerID = C.CustomerID
					WHERE
						C.CustomerID = @CustomerID AND
						C.Active = @Active AND
						GR.Active = @Active
				END
			ELSE
				BEGIN
					SELECT 
						GR.GiftRegistryID,
						C.CustomerID,
						C.FirstName,
						C.LastName,
						GR.DateCreated,
						GR.IsPublic,
						GR.Active
					FROM 
						GiftRegistry GR WITH(NOLOCK) INNER JOIN Customer C WITH(NOLOCK) ON
						GR.CustomerID = C.CustomerID
					WHERE
						GR.GiftRegistryID = @GiftRegistryID AND
						C.Active = @Active AND
						GR.Active = @Active
				END
		END
	ELSE
		BEGIN
			SELECT
				GR.GiftRegistryID,
				C.CustomerID,
				C.FirstName,
				C.LastName,
				GR.DateCreated,
				GR.IsPublic,
				GR.Active
			FROM 
				GiftRegistry GR WITH(NOLOCK) INNER JOIN Customer C WITH(NOLOCK) ON
				GR.CustomerID = C.CustomerID
			WHERE
				C.Email = @Email AND
				C.Active = @Active AND
				GR.Active = @Active
		END
END
GO
/****** Object:  StoredProcedure [dbo].[GetOrderProductOptions]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOrderProductOptions] 
	@OrderProductID int,
	@Active int = 1
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT
		OPO.OrderProductOptionID,
		OPO.OrderProductID,
		OPO.ProductOptionID,
		PO.ProductOptionName,
		OPO.Active
	FROM
		OrderProductOption OPO WITH(NOLOCK) JOIN ProductOption PO WITH(NOLOCK) ON
		OPO.ProductOptionID = po.ProductOptionID
	WHERE
		OPO.OrderProductID = @OrderProductID AND
		OPO.Active = @Active
END
GO
/****** Object:  StoredProcedure [dbo].[GetOrderProductCustomFields]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOrderProductCustomFields] 
	@OrderProductID int,
	@Active bit = 1
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT
		OrderProductCustomFieldID
		OrderProductID,
        OrderProductCustomField.CustomFieldID,
		CustomField.CustomFieldName,
        OrderProductCustomFieldValue,
        OrderProductCustomField.Active
	FROM
		OrderProductCustomField WITH(NOLOCK) JOIN CustomField WITH(NOLOCK) ON
		OrderProductCustomField.CustomFieldID = CustomField.CustomFieldID
	WHERE
		OrderProductCustomField.OrderProductID = @OrderProductID AND
		OrderProductCustomField.Active = @Active AND
		CustomField.Active = @Active
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateGiftRegistryPublic]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateGiftRegistryPublic] 
	@GiftRegistryID INT,
	@IsPublic BIT
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE
		GiftRegistry
	SET
		IsPublic = @IsPublic
	WHERE
		GiftRegistryID = @GiftRegistryID
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateRegistryProductActive]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateRegistryProductActive]
	@GiftRegistryID INT,
	@GiftRegistryProductID INT,
	@Active BIT = 1
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE
		GRP
	SET
		GRP.Active = @Active
	FROM
		GiftRegistryProduct GRP INNER JOIN GiftRegistry GR ON
		GRP.GiftRegistryID = GR.GiftRegistryID
	WHERE
		GR.GiftRegistryID = @GiftRegistryID AND
		GRP.GiftRegistryProductID = @GiftRegistryProductID
END
GO
/****** Object:  StoredProcedure [dbo].[RemoveGiftRegistryProduct]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemoveGiftRegistryProduct]
	@CustomerID INT,
	@GiftRegistryProductID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DELETE GRP FROM GiftRegistryProduct GRP INNER JOIN GiftRegistry GR ON
	GRP.GiftRegistryID = GR.GiftRegistryID
	WHERE
		GR.CustomerID = @CustomerID AND
		GRP.GiftRegistryProductID = @GiftRegistryProductID
END
GO
/****** Object:  StoredProcedure [dbo].[RemoveGiftRegistry]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemoveGiftRegistry] 
	@CustomerID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	
	DELETE FROM GiftRegistryProduct WHERE GiftRegistryID IN (SELECT GiftRegistryID FROM GiftRegistry WITH(NOLOCK) WHERE CustomerID = @CustomerID)
	DELETE FROM GiftRegistry WHERE CustomerID = @CustomerID
END
GO
/****** Object:  StoredProcedure [dbo].[GetProductReviews]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProductReviews] 
	@ProductID int,
	@PageIndex int,
	@PageSize int
AS
BEGIN

	SET NOCOUNT ON;
	
	 -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForProductReviews
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        ProductReviewID int
    )
    
    INSERT INTO #PageIndexForProductReviews (ProductReviewID)
    SELECT
		PR.ProductReviewID
    FROM
		ProductReview PR WITH(NOLOCK) INNER JOIN Customer c WITH(NOLOCK) ON
		PR.CustomerID = C.CustomerID
	WHERE
		PR.ProductID = @ProductID AND
		PR.Active = 1 AND
		C.Active = 1 AND
		EXISTS(SELECT 1 FROM
			[Order] O WITH(NOLOCK) INNER JOIN OrderProduct OP WITH(NOLOCK) ON
			O.OrderID = OP.OrderID
		WHERE
			O.CustomerID = C.CustomerID AND
			OP.ProductID = @ProductID AND
			O.Active = 1 AND
			OP.Active = 1)
	ORDER BY
		PR.ReviewDate
	DESC

	SELECT @TotalRecords = @@ROWCOUNT
	
	SELECT
		PR.ProductReviewID,
		PR.ReviewText,
		PR.ReviewDate,
		(SELECT TOP 1
			O.DatePlaced
		FROM
			[Order] O WITH(NOLOCK) INNER JOIN OrderProduct OP ON
			O.OrderID = OP.OrderID
		WHERE
			O.CustomerID = C.CustomerID AND
			OP.ProductID = @ProductID AND
			OP.Active = 1
		) AS OrderDate
		FROM
			ProductReview PR WITH(NOLOCK) INNER JOIN #PageIndexForProductReviews i ON
			PR.ProductReviewID = i.ProductReviewID INNER JOIN Customer c WITH(NOLOCK) ON
			PR.CustomerID = C.CustomerID
		WHERE
			i.IndexId >= @PageLowerBound AND 
			i.IndexId <= @PageUpperBound

	-- Add the ratings in all categories to be matched to the reviews in the application
	SELECT
		PRCPR.ProductReviewID,
		PRC.ProductReviewCategoryName,
		PRCPR.Rating
	FROM
		ProductReviewCaregoryProductReview PRCPR WITH(NOLOCK) INNER JOIN #PageIndexForProductReviews i ON
		PRCPR.ProductReviewID = i.ProductReviewID INNER JOIN ProductReviewCategory PRC WITH(NOLOCK) ON
		PRCPR.ProductReviewCategoryID = PRC.ProductReviewCategoryID
	WHERE
		PRCPR.Active = 1 AND
		PRC.Active = 1
	
	RETURN @TotalRecords

    DROP TABLE #PageIndexForProductReviews
END
GO
/****** Object:  StoredProcedure [dbo].[GetGiftRegistryProducts]    Script Date: 10/27/2011 09:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetGiftRegistryProducts]
	@GiftRegistryID INT
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT
		GRP.GiftRegistryProductID,
		GRP.GiftRegistryID,
		GRP.ProductID,
		GRP.Active,
		P.ProductName,
		(SELECT TOP 1 ImageURL FROM [Image] WHERE ProductID = GRP.ProductID AND ParentID IS NOT NULL) AS Thumbnail
	FROM
		GiftRegistryProduct GRP WITH(NOLOCK) INNER JOIN Product P WITH(NOLOCK) ON
		GRP.ProductID = P.ProductID
	WHERE
		GRP.GiftRegistryID = @GiftRegistryID AND
		P.Active = 1 AND
		GRP.Active = 1
END
GO
/****** Object:  StoredProcedure [dbo].[AddProductReviewCaregoryProductReview]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddProductReviewCaregoryProductReview] 
	@ProductReviewCategoryID int,
	@ProductReviewID int,
	@Rating int,
	@Active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO ProductReviewCaregoryProductReview(
		ProductReviewCategoryID,
		ProductReviewID,
        Rating,
        Active
    )VALUES(
		@ProductReviewCategoryID,
		@ProductReviewID,
		@Rating,
		@Active)
		
	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddGiftRegistryProduct]    Script Date: 10/27/2011 09:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddGiftRegistryProduct]
	@GiftRegistryID INT,
    @ProductID INT,
    @Active BIT = 1
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO GiftRegistryProduct (
		GiftRegistryID, 
		ProductID, 
		Active
	)VALUES(
		@GiftRegistryID,
		@ProductID,
		@Active
    )
    
    SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  Default [DF__aspnet_Ap__Appli__36B12243]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_Applications] ADD  DEFAULT (newid()) FOR [ApplicationId]
GO
/****** Object:  Default [DF__aspnet_Me__Passw__6A30C649]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_Membership] ADD  DEFAULT ((0)) FOR [PasswordFormat]
GO
/****** Object:  Default [DF__aspnet_Pa__PathI__656C112C]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_Paths] ADD  DEFAULT (newid()) FOR [PathId]
GO
/****** Object:  Default [DF__aspnet_Perso__Id__5CD6CB2B]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_PersonalizationPerUser] ADD  DEFAULT (newid()) FOR [Id]
GO
/****** Object:  Default [DF__aspnet_Ro__RoleI__75A278F5]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_Roles] ADD  DEFAULT (newid()) FOR [RoleId]
GO
/****** Object:  Default [DF__aspnet_Us__UserI__6EF57B66]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_Users] ADD  DEFAULT (newid()) FOR [UserId]
GO
/****** Object:  Default [DF__aspnet_Us__Mobil__6FE99F9F]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_Users] ADD  DEFAULT (NULL) FOR [MobileAlias]
GO
/****** Object:  Default [DF__aspnet_Us__IsAno__70DDC3D8]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_Users] ADD  DEFAULT ((0)) FOR [IsAnonymous]
GO
/****** Object:  Default [DF_Coupon_IssuedDate]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Coupon] ADD  CONSTRAINT [DF_Coupon_IssuedDate]  DEFAULT (getdate()) FOR [IssuedDate]
GO
/****** Object:  Default [DF_Product_IsReviewEnabled]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_IsReviewEnabled]  DEFAULT ((0)) FOR [IsReviewEnabled]
GO
/****** Object:  Default [DF_Product_TotalReviewCount]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_TotalReviewCount]  DEFAULT ((0)) FOR [TotalReviewCount]
GO
/****** Object:  ForeignKey [FK__aspnet_Me__Appli__5AB9788F]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_Membership]  WITH CHECK ADD FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
/****** Object:  ForeignKey [FK__aspnet_Me__UserI__5BAD9CC8]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_Membership]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
/****** Object:  ForeignKey [FK__aspnet_Pa__Appli__5CA1C101]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_Paths]  WITH CHECK ADD FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
/****** Object:  ForeignKey [FK__aspnet_Pe__PathI__5D95E53A]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_PersonalizationAllUsers]  WITH CHECK ADD FOREIGN KEY([PathId])
REFERENCES [dbo].[aspnet_Paths] ([PathId])
GO
/****** Object:  ForeignKey [FK__aspnet_Pe__PathI__5E8A0973]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_PersonalizationPerUser]  WITH CHECK ADD FOREIGN KEY([PathId])
REFERENCES [dbo].[aspnet_Paths] ([PathId])
GO
/****** Object:  ForeignKey [FK__aspnet_Pe__UserI__5F7E2DAC]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_PersonalizationPerUser]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
/****** Object:  ForeignKey [FK__aspnet_Pr__UserI__607251E5]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_Profile]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
/****** Object:  ForeignKey [FK__aspnet_Ro__Appli__6166761E]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_Roles]  WITH CHECK ADD FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
/****** Object:  ForeignKey [FK__aspnet_Us__Appli__625A9A57]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_Users]  WITH CHECK ADD FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
/****** Object:  ForeignKey [FK__aspnet_Us__RoleI__634EBE90]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_UsersInRoles]  WITH CHECK ADD FOREIGN KEY([RoleId])
REFERENCES [dbo].[aspnet_Roles] ([RoleId])
GO
/****** Object:  ForeignKey [FK__aspnet_Us__UserI__6442E2C9]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[aspnet_UsersInRoles]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
/****** Object:  ForeignKey [FK_Coupon_CouponType]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Coupon]  WITH CHECK ADD  CONSTRAINT [FK_Coupon_CouponType] FOREIGN KEY([CouponTypeID])
REFERENCES [dbo].[CouponType] ([CouponTypeID])
GO
ALTER TABLE [dbo].[Coupon] CHECK CONSTRAINT [FK_Coupon_CouponType]
GO
/****** Object:  ForeignKey [FK_Coupon_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Coupon]  WITH CHECK ADD  CONSTRAINT [FK_Coupon_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[Coupon] CHECK CONSTRAINT [FK_Coupon_Product]
GO
/****** Object:  ForeignKey [FK_Customer_aspnet_Users]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Customer]  WITH NOCHECK ADD  CONSTRAINT [FK_Customer_aspnet_Users] FOREIGN KEY([MemberID])
REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_aspnet_Users]
GO
/****** Object:  ForeignKey [FK_Customer_Country]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Customer]  WITH NOCHECK ADD  CONSTRAINT [FK_Customer_Country] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([CountryID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Country]
GO
/****** Object:  ForeignKey [FK_Customer_Province]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Customer]  WITH NOCHECK ADD  CONSTRAINT [FK_Customer_Province] FOREIGN KEY([ProvinceID])
REFERENCES [dbo].[Province] ([ProvinceID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Province]
GO
/****** Object:  ForeignKey [FK_Customer_State]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Customer]  WITH NOCHECK ADD  CONSTRAINT [FK_Customer_State] FOREIGN KEY([StateID])
REFERENCES [dbo].[State] ([StateID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_State]
GO
/****** Object:  ForeignKey [FK_CustomField_CustomFieldType]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[CustomField]  WITH CHECK ADD  CONSTRAINT [FK_CustomField_CustomFieldType] FOREIGN KEY([CustomFieldTypeID])
REFERENCES [dbo].[CustomFieldType] ([CustomFieldTypeID])
GO
ALTER TABLE [dbo].[CustomField] CHECK CONSTRAINT [FK_CustomField_CustomFieldType]
GO
/****** Object:  ForeignKey [FK_CustomField_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[CustomField]  WITH NOCHECK ADD  CONSTRAINT [FK_CustomField_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[CustomField] CHECK CONSTRAINT [FK_CustomField_Product]
GO
/****** Object:  ForeignKey [FK_FeaturedProduct_Category]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[FeaturedProduct]  WITH NOCHECK ADD  CONSTRAINT [FK_FeaturedProduct_Category] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[FeaturedProduct] CHECK CONSTRAINT [FK_FeaturedProduct_Category]
GO
/****** Object:  ForeignKey [FK_FeaturedProduct_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[FeaturedProduct]  WITH NOCHECK ADD  CONSTRAINT [FK_FeaturedProduct_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[FeaturedProduct] CHECK CONSTRAINT [FK_FeaturedProduct_Product]
GO
/****** Object:  ForeignKey [FK_GiftRegistry_Customer]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[GiftRegistry]  WITH CHECK ADD  CONSTRAINT [FK_GiftRegistry_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[GiftRegistry] CHECK CONSTRAINT [FK_GiftRegistry_Customer]
GO
/****** Object:  ForeignKey [FK_GiftRegistryProduct_GiftRegistry]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[GiftRegistryProduct]  WITH CHECK ADD  CONSTRAINT [FK_GiftRegistryProduct_GiftRegistry] FOREIGN KEY([GiftRegistryID])
REFERENCES [dbo].[GiftRegistry] ([GiftRegistryID])
GO
ALTER TABLE [dbo].[GiftRegistryProduct] CHECK CONSTRAINT [FK_GiftRegistryProduct_GiftRegistry]
GO
/****** Object:  ForeignKey [FK_GiftRegistryProduct_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[GiftRegistryProduct]  WITH CHECK ADD  CONSTRAINT [FK_GiftRegistryProduct_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[GiftRegistryProduct] CHECK CONSTRAINT [FK_GiftRegistryProduct_Product]
GO
/****** Object:  ForeignKey [FK_Image_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Image]  WITH NOCHECK ADD  CONSTRAINT [FK_Image_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[Image] CHECK CONSTRAINT [FK_Image_Product]
GO
/****** Object:  ForeignKey [FK_Inventory_InventoryAction]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD  CONSTRAINT [FK_Inventory_InventoryAction] FOREIGN KEY([InventoryActionID])
REFERENCES [dbo].[InventoryAction] ([InventoryActionID])
GO
ALTER TABLE [dbo].[Inventory] CHECK CONSTRAINT [FK_Inventory_InventoryAction]
GO
/****** Object:  ForeignKey [FK_Inventory_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD  CONSTRAINT [FK_Inventory_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[Inventory] CHECK CONSTRAINT [FK_Inventory_Product]
GO
/****** Object:  ForeignKey [FK_InventoryOption_Inventory]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[InventoryProductOption]  WITH CHECK ADD  CONSTRAINT [FK_InventoryOption_Inventory] FOREIGN KEY([InventoryID])
REFERENCES [dbo].[Inventory] ([InventoryID])
GO
ALTER TABLE [dbo].[InventoryProductOption] CHECK CONSTRAINT [FK_InventoryOption_Inventory]
GO
/****** Object:  ForeignKey [FK_InventoryOption_ProductOption]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[InventoryProductOption]  WITH CHECK ADD  CONSTRAINT [FK_InventoryOption_ProductOption] FOREIGN KEY([ProductOptionID])
REFERENCES [dbo].[ProductOption] ([ProductOptionID])
GO
ALTER TABLE [dbo].[InventoryProductOption] CHECK CONSTRAINT [FK_InventoryOption_ProductOption]
GO
/****** Object:  ForeignKey [FK_Order_Country]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Order]  WITH NOCHECK ADD  CONSTRAINT [FK_Order_Country] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([CountryID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Country]
GO
/****** Object:  ForeignKey [FK_Order_OrderStatus]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Order]  WITH NOCHECK ADD  CONSTRAINT [FK_Order_OrderStatus] FOREIGN KEY([OrderStatusID])
REFERENCES [dbo].[OrderStatus] ([OrderStatusID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_OrderStatus]
GO
/****** Object:  ForeignKey [FK_Order_Province]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Order]  WITH NOCHECK ADD  CONSTRAINT [FK_Order_Province] FOREIGN KEY([ProvinceID])
REFERENCES [dbo].[Province] ([ProvinceID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Province]
GO
/****** Object:  ForeignKey [FK_Order_ShippingProvider]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Order]  WITH NOCHECK ADD  CONSTRAINT [FK_Order_ShippingProvider] FOREIGN KEY([ShippingProviderID])
REFERENCES [dbo].[ShippingProvider] ([ShippingProviderID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_ShippingProvider]
GO
/****** Object:  ForeignKey [FK_Order_State]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Order]  WITH NOCHECK ADD  CONSTRAINT [FK_Order_State] FOREIGN KEY([StateID])
REFERENCES [dbo].[State] ([StateID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_State]
GO
/****** Object:  ForeignKey [FK_OrderProduct_Order]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[OrderProduct]  WITH NOCHECK ADD  CONSTRAINT [FK_OrderProduct_Order] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO
ALTER TABLE [dbo].[OrderProduct] CHECK CONSTRAINT [FK_OrderProduct_Order]
GO
/****** Object:  ForeignKey [FK_OrderProduct_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[OrderProduct]  WITH NOCHECK ADD  CONSTRAINT [FK_OrderProduct_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[OrderProduct] CHECK CONSTRAINT [FK_OrderProduct_Product]
GO
/****** Object:  ForeignKey [FK_OrderProductCustomField_CustomField]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[OrderProductCustomField]  WITH CHECK ADD  CONSTRAINT [FK_OrderProductCustomField_CustomField] FOREIGN KEY([CustomFieldID])
REFERENCES [dbo].[CustomField] ([CustomFieldID])
GO
ALTER TABLE [dbo].[OrderProductCustomField] CHECK CONSTRAINT [FK_OrderProductCustomField_CustomField]
GO
/****** Object:  ForeignKey [FK_OrderProductCustomField_OrderProduct]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[OrderProductCustomField]  WITH CHECK ADD  CONSTRAINT [FK_OrderProductCustomField_OrderProduct] FOREIGN KEY([OrderProductID])
REFERENCES [dbo].[OrderProduct] ([OrderProductID])
GO
ALTER TABLE [dbo].[OrderProductCustomField] CHECK CONSTRAINT [FK_OrderProductCustomField_OrderProduct]
GO
/****** Object:  ForeignKey [FK_OrderProductOption_OrderProduct]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[OrderProductOption]  WITH CHECK ADD  CONSTRAINT [FK_OrderProductOption_OrderProduct] FOREIGN KEY([OrderProductID])
REFERENCES [dbo].[OrderProduct] ([OrderProductID])
GO
ALTER TABLE [dbo].[OrderProductOption] CHECK CONSTRAINT [FK_OrderProductOption_OrderProduct]
GO
/****** Object:  ForeignKey [FK_OrderProductOption_ProductOption]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[OrderProductOption]  WITH CHECK ADD  CONSTRAINT [FK_OrderProductOption_ProductOption] FOREIGN KEY([ProductOptionID])
REFERENCES [dbo].[ProductOption] ([ProductOptionID])
GO
ALTER TABLE [dbo].[OrderProductOption] CHECK CONSTRAINT [FK_OrderProductOption_ProductOption]
GO
/****** Object:  ForeignKey [FK_ProductCategory_Category]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[ProductCategory]  WITH NOCHECK ADD  CONSTRAINT [FK_ProductCategory_Category] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[ProductCategory] CHECK CONSTRAINT [FK_ProductCategory_Category]
GO
/****** Object:  ForeignKey [FK_ProductCategory_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[ProductCategory]  WITH NOCHECK ADD  CONSTRAINT [FK_ProductCategory_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[ProductCategory] CHECK CONSTRAINT [FK_ProductCategory_Product]
GO
/****** Object:  ForeignKey [FK_DownloadKey_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[ProductDownloadKey]  WITH CHECK ADD  CONSTRAINT [FK_DownloadKey_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[ProductDownloadKey] CHECK CONSTRAINT [FK_DownloadKey_Product]
GO
/****** Object:  ForeignKey [FK_ProductOption_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[ProductOption]  WITH NOCHECK ADD  CONSTRAINT [FK_ProductOption_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[ProductOption] CHECK CONSTRAINT [FK_ProductOption_Product]
GO
/****** Object:  ForeignKey [FK_ProductReview_Customer]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[ProductReview]  WITH CHECK ADD  CONSTRAINT [FK_ProductReview_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[ProductReview] CHECK CONSTRAINT [FK_ProductReview_Customer]
GO
/****** Object:  ForeignKey [FK_ProductReview_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[ProductReview]  WITH CHECK ADD  CONSTRAINT [FK_ProductReview_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[ProductReview] CHECK CONSTRAINT [FK_ProductReview_Product]
GO
/****** Object:  ForeignKey [FK_ProductReviewCaregoryProductReview_ProductReview]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[ProductReviewCaregoryProductReview]  WITH CHECK ADD  CONSTRAINT [FK_ProductReviewCaregoryProductReview_ProductReview] FOREIGN KEY([ProductReviewID])
REFERENCES [dbo].[ProductReview] ([ProductReviewID])
GO
ALTER TABLE [dbo].[ProductReviewCaregoryProductReview] CHECK CONSTRAINT [FK_ProductReviewCaregoryProductReview_ProductReview]
GO
/****** Object:  ForeignKey [FK_ProductReviewCaregoryProductReview_ProductReviewCategory]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[ProductReviewCaregoryProductReview]  WITH CHECK ADD  CONSTRAINT [FK_ProductReviewCaregoryProductReview_ProductReviewCategory] FOREIGN KEY([ProductReviewCategoryID])
REFERENCES [dbo].[ProductReviewCategory] ([ProductReviewCategoryID])
GO
ALTER TABLE [dbo].[ProductReviewCaregoryProductReview] CHECK CONSTRAINT [FK_ProductReviewCaregoryProductReview_ProductReviewCategory]
GO
/****** Object:  ForeignKey [FK_ProductTag_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[ProductTag]  WITH CHECK ADD  CONSTRAINT [FK_ProductTag_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[ProductTag] CHECK CONSTRAINT [FK_ProductTag_Product]
GO
/****** Object:  ForeignKey [FK_ProductTag_Tag]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[ProductTag]  WITH CHECK ADD  CONSTRAINT [FK_ProductTag_Tag] FOREIGN KEY([TagID])
REFERENCES [dbo].[Tag] ([TagID])
GO
ALTER TABLE [dbo].[ProductTag] CHECK CONSTRAINT [FK_ProductTag_Tag]
GO
/****** Object:  ForeignKey [FK_RelatedProduct_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[RelatedProduct]  WITH NOCHECK ADD  CONSTRAINT [FK_RelatedProduct_Product] FOREIGN KEY([ProductOneID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[RelatedProduct] CHECK CONSTRAINT [FK_RelatedProduct_Product]
GO
/****** Object:  ForeignKey [FK_RelatedProduct_Product1]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[RelatedProduct]  WITH NOCHECK ADD  CONSTRAINT [FK_RelatedProduct_Product1] FOREIGN KEY([ProductTwoID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[RelatedProduct] CHECK CONSTRAINT [FK_RelatedProduct_Product1]
GO
/****** Object:  ForeignKey [FK_Shipping_Country]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Shipping]  WITH NOCHECK ADD  CONSTRAINT [FK_Shipping_Country] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([CountryID])
GO
ALTER TABLE [dbo].[Shipping] CHECK CONSTRAINT [FK_Shipping_Country]
GO
/****** Object:  ForeignKey [FK_Shipping_Product]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Shipping]  WITH NOCHECK ADD  CONSTRAINT [FK_Shipping_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[Shipping] CHECK CONSTRAINT [FK_Shipping_Product]
GO
/****** Object:  ForeignKey [FK_Shipping_Province]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Shipping]  WITH NOCHECK ADD  CONSTRAINT [FK_Shipping_Province] FOREIGN KEY([ProvinceID])
REFERENCES [dbo].[Province] ([ProvinceID])
GO
ALTER TABLE [dbo].[Shipping] CHECK CONSTRAINT [FK_Shipping_Province]
GO
/****** Object:  ForeignKey [FK_Shipping_ShippingProvider]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Shipping]  WITH NOCHECK ADD  CONSTRAINT [FK_Shipping_ShippingProvider] FOREIGN KEY([ShippingProviderID])
REFERENCES [dbo].[ShippingProvider] ([ShippingProviderID])
GO
ALTER TABLE [dbo].[Shipping] CHECK CONSTRAINT [FK_Shipping_ShippingProvider]
GO
/****** Object:  ForeignKey [FK_Shipping_State]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Shipping]  WITH NOCHECK ADD  CONSTRAINT [FK_Shipping_State] FOREIGN KEY([StateID])
REFERENCES [dbo].[State] ([StateID])
GO
ALTER TABLE [dbo].[Shipping] CHECK CONSTRAINT [FK_Shipping_State]
GO
/****** Object:  ForeignKey [FK_Tax_Country]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Tax]  WITH NOCHECK ADD  CONSTRAINT [FK_Tax_Country] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([CountryID])
GO
ALTER TABLE [dbo].[Tax] CHECK CONSTRAINT [FK_Tax_Country]
GO
/****** Object:  ForeignKey [FK_Tax_Province]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Tax]  WITH NOCHECK ADD  CONSTRAINT [FK_Tax_Province] FOREIGN KEY([ProvinceID])
REFERENCES [dbo].[Province] ([ProvinceID])
GO
ALTER TABLE [dbo].[Tax] CHECK CONSTRAINT [FK_Tax_Province]
GO
/****** Object:  ForeignKey [FK_Tax_State]    Script Date: 10/27/2011 09:13:17 ******/
ALTER TABLE [dbo].[Tax]  WITH NOCHECK ADD  CONSTRAINT [FK_Tax_State] FOREIGN KEY([StateID])
REFERENCES [dbo].[State] ([StateID])
GO
ALTER TABLE [dbo].[Tax] CHECK CONSTRAINT [FK_Tax_State]
GO

/****** Object:  Table [dbo].[Country]    Script Date: 06/23/2011 19:22:16 ******/
SET IDENTITY_INSERT [Country] ON
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (1, N'AFGHANISTAN', N'AF', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (2, N'LAND ISLANDS', N'AX', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (3, N'ALBANIA', N'AL', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (4, N'ALGERIA', N'DZ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (5, N'AMERICAN SAMOA', N'AS', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (6, N'ANDORRA', N'AD', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (7, N'ANGOLA', N'AO', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (8, N'ANGUILLA', N'AI', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (9, N'ANTARCTICA', N'AQ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (10, N'ANTIGUA AND BARBUDA', N'AG', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (11, N'ARGENTINA', N'AR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (12, N'ARMENIA', N'AM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (13, N'ARUBA', N'AW', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (14, N'AUSTRALIA', N'AU', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (15, N'AUSTRIA', N'AT', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (16, N'AZERBAIJAN', N'AZ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (17, N'BAHAMAS', N'BS', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (18, N'BAHRAIN', N'BH', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (19, N'BANGLADESH', N'BD', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (20, N'BARBADOS', N'BB', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (21, N'BELARUS', N'BY', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (22, N'BELGIUM', N'BE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (23, N'BELIZE', N'BZ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (24, N'BENIN', N'BJ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (25, N'BERMUDA', N'BM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (26, N'BHUTAN', N'BT', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (27, N'BOLIVIA', N'BO', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (28, N'BOSNIA AND HERZEGOVINA', N'BA', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (29, N'BOTSWANA', N'BW', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (30, N'BOUVET ISLAND', N'BV', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (31, N'BRAZIL', N'BR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (32, N'BRITISH INDIAN OCEAN TERRITORY', N'IO', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (33, N'BRUNEI DARUSSALAM', N'BN', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (34, N'BULGARIA', N'BG', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (35, N'BURKINA FASO', N'BF', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (36, N'BURUNDI', N'BI', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (37, N'CAMBODIA', N'KH', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (38, N'CAMEROON', N'CM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (39, N'CANADA', N'CA', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (40, N'CAPE VERDE', N'CV', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (41, N'CAYMAN ISLANDS', N'KY', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (42, N'CENTRAL AFRICAN REPUBLIC', N'CF', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (43, N'CHAD', N'TD', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (44, N'CHILE', N'CL', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (45, N'CHINA', N'CN', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (46, N'CHRISTMAS ISLAND', N'CX', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (47, N'COCOS (KEELING) ISLANDS', N'CC', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (48, N'COLOMBIA', N'CO', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (49, N'COMOROS', N'KM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (50, N'CONGO', N'CG', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (51, N'CONGO, THE DEMOCRATIC REPUBLIC OF THE', N'CD', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (52, N'COOK ISLANDS', N'CK', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (53, N'COSTA RICA', N'CR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (54, N'COTE D''IVOIRE', N'CI', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (55, N'CROATIA', N'HR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (56, N'CUBA', N'CU', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (57, N'CYPRUS', N'CY', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (58, N'CZECH REPUBLIC', N'CZ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (59, N'DENMARK', N'DK', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (60, N'DJIBOUTI', N'DJ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (61, N'DOMINICA', N'DM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (62, N'DOMINICAN REPUBLIC', N'DO', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (63, N'ECUADOR', N'EC', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (64, N'EGYPT', N'EG', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (65, N'EL SALVADOR', N'SV', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (66, N'EQUATORIAL GUINEA', N'GQ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (67, N'ERITREA', N'ER', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (68, N'ESTONIA', N'EE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (69, N'ETHIOPIA', N'ET', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (70, N'FALKLAND ISLANDS (MALVINAS)', N'FK', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (71, N'FAROE ISLANDS', N'FO', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (72, N'FIJI', N'FJ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (73, N'FINLAND', N'FI', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (74, N'FRANCE', N'FR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (75, N'FRENCH GUIANA', N'GF', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (76, N'FRENCH POLYNESIA', N'PF', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (77, N'FRENCH SOUTHERN TERRITORIES', N'TF', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (78, N'GABON', N'GA', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (79, N'GAMBIA', N'GM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (80, N'GEORGIA', N'GE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (81, N'GERMANY', N'DE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (82, N'GHANA', N'GH', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (83, N'GIBRALTAR', N'GI', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (84, N'GREECE', N'GR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (85, N'GREENLAND', N'GL', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (86, N'GRENADA', N'GD', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (87, N'GUADELOUPE', N'GP', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (88, N'GUAM', N'GU', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (89, N'GUATEMALA', N'GT', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (90, N'GUERNSEY', N'GG', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (91, N'GUINEA', N'GN', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (92, N'GUINEA-BISSAU', N'GW', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (93, N'GUYANA', N'GY', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (94, N'HAITI', N'HT', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (95, N'HEARD ISLAND AND MCDONALD ISLANDS', N'HM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (96, N'HOLY SEE (VATICAN CITY STATE)', N'VA', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (97, N'HONDURAS', N'HN', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (98, N'HONG KONG', N'HK', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (99, N'HUNGARY', N'HU', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (100, N'ICELAND', N'IS', 1)
GO
print 'Processed 100 total records'
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (101, N'INDIA', N'IN', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (102, N'INDONESIA', N'ID', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (103, N'IRAN, ISLAMIC REPUBLIC OF', N'IR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (104, N'IRAQ', N'IQ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (105, N'IRELAND', N'IE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (106, N'ISLE OF MAN', N'IM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (107, N'ISRAEL', N'IL', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (108, N'ITALY', N'IT', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (109, N'JAMAICA', N'JM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (110, N'JAPAN', N'JP', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (111, N'JERSEY', N'JE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (112, N'JORDAN', N'JO', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (113, N'KAZAKHSTAN', N'KZ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (114, N'KENYA', N'KE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (115, N'KIRIBATI', N'KI', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (116, N'KOREA, DEMOCRATIC PEOPLE''S REPUBLIC OF', N'KP', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (117, N'KOREA, REPUBLIC OF', N'KR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (118, N'KUWAIT', N'KW', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (119, N'KYRGYZSTAN', N'KG', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (120, N'LAO PEOPLE''S DEMOCRATIC REPUBLIC', N'LA', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (121, N'LATVIA', N'LV', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (122, N'LEBANON', N'LB', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (123, N'LESOTHO', N'LS', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (124, N'LIBERIA', N'LR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (125, N'LIBYAN ARAB JAMAHIRIYA', N'LY', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (126, N'LIECHTENSTEIN', N'LI', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (127, N'LITHUANIA', N'LT', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (128, N'LUXEMBOURG', N'LU', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (129, N'MACAO', N'MO', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (130, N'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF', N'MK', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (131, N'MADAGASCAR', N'MG', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (132, N'MALAWI', N'MW', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (133, N'MALAYSIA', N'MY', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (134, N'MALDIVES', N'MV', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (135, N'MALI', N'ML', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (136, N'MALTA', N'MT', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (137, N'MARSHALL ISLANDS', N'MH', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (138, N'MARTINIQUE', N'MQ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (139, N'MAURITANIA', N'MR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (140, N'MAURITIUS', N'MU', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (141, N'MAYOTTE', N'YT', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (142, N'MEXICO', N'MX', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (143, N'MICRONESIA, FEDERATED STATES OF', N'FM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (144, N'MOLDOVA, REPUBLIC OF', N'MD', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (145, N'MONACO', N'MC', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (146, N'MONGOLIA', N'MN', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (147, N'MONTSERRAT', N'MS', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (148, N'MOROCCO', N'MA', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (149, N'MOZAMBIQUE', N'MZ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (150, N'MYANMAR', N'MM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (151, N'NAMIBIA', N'NA', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (152, N'NAURU', N'NR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (153, N'NEPAL', N'NP', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (154, N'NETHERLANDS', N'NL', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (155, N'NETHERLANDS ANTILLES', N'AN', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (156, N'NEW CALEDONIA', N'NC', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (157, N'NEW ZEALAND', N'NZ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (158, N'NICARAGUA', N'NI', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (159, N'NIGER', N'NE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (160, N'NIGERIA', N'NG', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (161, N'NIUE', N'NU', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (162, N'NORFOLK ISLAND', N'NF', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (163, N'NORTHERN MARIANA ISLANDS', N'MP', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (164, N'NORWAY', N'NO', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (165, N'OMAN', N'OM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (166, N'PAKISTAN', N'PK', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (167, N'PALAU', N'PW', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (168, N'PALESTINIAN TERRITORY, OCCUPIED', N'PS', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (169, N'PANAMA', N'PA', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (170, N'PAPUA NEW GUINEA', N'PG', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (171, N'PARAGUAY', N'PY', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (172, N'PERU', N'PE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (173, N'PHILIPPINES', N'PH', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (174, N'PITCAIRN', N'PN', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (175, N'POLAND', N'PL', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (176, N'PORTUGAL', N'PT', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (177, N'PUERTO RICO', N'PR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (178, N'QATAR', N'QA', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (179, N'REUNION', N'RE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (180, N'ROMANIA', N'RO', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (181, N'RUSSIAN FEDERATION', N'RU', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (182, N'RWANDA', N'RW', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (183, N'SAINT HELENA', N'SH', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (184, N'SAINT KITTS AND NEVIS', N'KN', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (185, N'SAINT LUCIA', N'LC', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (186, N'SAINT PIERRE AND MIQUELON', N'PM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (187, N'SAINT VINCENT AND THE GRENADINES', N'VC', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (188, N'SAMOA', N'WS', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (189, N'SAN MARINO', N'SM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (190, N'SAO TOME AND PRINCIPE', N'ST', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (191, N'SAUDI ARABIA', N'SA', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (192, N'SENEGAL', N'SN', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (193, N'SERBIA AND MONTENEGRO', N'CS', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (194, N'SEYCHELLES', N'SC', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (195, N'SIERRA LEONE', N'SL', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (196, N'SINGAPORE', N'SG', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (197, N'SLOVAKIA', N'SK', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (198, N'SLOVENIA', N'SI', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (199, N'SOLOMON ISLANDS', N'SB', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (200, N'SOMALIA', N'SO', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (201, N'SOUTH AFRICA', N'ZA', 1)
GO
print 'Processed 200 total records'
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (202, N'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS', N'GS', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (203, N'SPAIN', N'ES', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (204, N'SRI LANKA', N'LK', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (205, N'SUDAN', N'SD', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (206, N'SURINAME', N'SR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (207, N'SVALBARD AND JAN MAYEN', N'SJ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (208, N'SWAZILAND', N'SZ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (209, N'SWEDEN', N'SE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (210, N'SWITZERLAND', N'CH', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (211, N'SYRIAN ARAB REPUBLIC', N'SY', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (212, N'TAIWAN, PROVINCE OF CHINA', N'TW', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (213, N'TAJIKISTAN', N'TJ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (214, N'TANZANIA, UNITED REPUBLIC OF', N'TZ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (215, N'THAILAND', N'TH', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (216, N'TIMOR-LESTE', N'TL', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (217, N'TOGO', N'TG', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (218, N'TOKELAU', N'TK', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (219, N'TONGA', N'TO', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (220, N'TRINIDAD AND TOBAGO', N'TT', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (221, N'TUNISIA', N'TN', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (222, N'TURKEY', N'TR', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (223, N'TURKMENISTAN', N'TM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (224, N'TURKS AND CAICOS ISLANDS', N'TC', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (225, N'TUVALU', N'TV', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (226, N'UGANDA', N'UG', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (227, N'UKRAINE', N'UA', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (228, N'UNITED ARAB EMIRATES', N'AE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (229, N'UNITED KINGDOM', N'GB', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (230, N'UNITED STATES', N'US', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (231, N'UNITED STATES MINOR OUTLYING ISLANDS', N'UM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (232, N'URUGUAY', N'UY', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (233, N'UZBEKISTAN', N'UZ', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (234, N'VANUATU', N'VU', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (235, N'VENEZUELA', N'VE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (236, N'VIET NAM', N'VN', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (237, N'VIRGIN ISLANDS, BRITISH', N'VG', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (238, N'VIRGIN ISLANDS, U.S.', N'VI', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (239, N'WALLIS AND FUTUNA', N'WF', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (240, N'WESTERN SAHARA', N'EH', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (241, N'YEMEN', N'YE', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (242, N'ZAMBIA', N'ZM', 1)
INSERT [Country] ([CountryID], [CountryName], [CountryCode], [Active]) VALUES (243, N'ZIMBABWE', N'ZW', 1)
SET IDENTITY_INSERT [Country] OFF
/****** Object:  Table [dbo].[CustomFieldType]    Script Date: 06/23/2011 19:22:16 ******/
SET IDENTITY_INSERT [CustomFieldType] ON
INSERT [CustomFieldType] ([CustomFieldTypeID], [CustomFieldTypeName], [Active]) VALUES (1, N'TextBox', 1)
INSERT [CustomFieldType] ([CustomFieldTypeID], [CustomFieldTypeName], [Active]) VALUES (2, N'CheckBox', 1)
SET IDENTITY_INSERT [CustomFieldType] OFF
/****** Object:  Table [dbo].[InventoryAction]    Script Date: 06/23/2011 19:22:16 ******/
SET IDENTITY_INSERT [InventoryAction] ON
INSERT [InventoryAction] ([InventoryActionID], [InventoryActionName]) VALUES (1, N'StopSellingOption')
INSERT [InventoryAction] ([InventoryActionID], [InventoryActionName]) VALUES (2, N'StopSellingProduct')
INSERT [InventoryAction] ([InventoryActionID], [InventoryActionName]) VALUES (3, N'ShowPreOrderOption')
INSERT [InventoryAction] ([InventoryActionID], [InventoryActionName]) VALUES (4, N'ShowPreOrderProduct')
INSERT [InventoryAction] ([InventoryActionID], [InventoryActionName]) VALUES (5, N'DoNothing')
SET IDENTITY_INSERT [InventoryAction] OFF
/****** Object:  Table [dbo].[aspnet_SchemaVersions]    Script Date: 06/23/2011 19:22:16 ******/
INSERT [aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'common', N'1', 1)
INSERT [aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'health monitoring', N'1', 1)
INSERT [aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'membership', N'1', 1)
INSERT [aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'personalization', N'1', 1)
INSERT [aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'profile', N'1', 1)
INSERT [aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'role manager', N'1', 1)
/****** Object:  Table [dbo].[aspnet_Applications]    Script Date: 06/23/2011 19:22:16 ******/
INSERT [aspnet_Applications] ([ApplicationName], [LoweredApplicationName], [ApplicationId], [Description]) VALUES (N'InvertedSoftwareCart', N'invertedsoftwarecart', N'de7c5af1-8dcc-4633-921f-8001edca639e', NULL)
/****** Object:  Table [dbo].[OrderStatus]    Script Date: 06/23/2011 19:22:16 ******/
SET IDENTITY_INSERT [OrderStatus] ON
INSERT [OrderStatus] ([OrderStatusID], [OrderStatusName], [Active]) VALUES (1, N'Accepted', 1)
INSERT [OrderStatus] ([OrderStatusID], [OrderStatusName], [Active]) VALUES (2, N'Verifyed', 1)
INSERT [OrderStatus] ([OrderStatusID], [OrderStatusName], [Active]) VALUES (3, N'Shipped', 1)
INSERT [OrderStatus] ([OrderStatusID], [OrderStatusName], [Active]) VALUES (4, N'PaymentError', 1)
SET IDENTITY_INSERT [OrderStatus] OFF
/****** Object:  Table [dbo].[CouponType]    Script Date: 06/23/2011 19:22:16 ******/
SET IDENTITY_INSERT [CouponType] ON
INSERT [CouponType] ([CouponTypeID], [CouponTypeName], [Active]) VALUES (1, N'PercentFromProduct', 1)
INSERT [CouponType] ([CouponTypeID], [CouponTypeName], [Active]) VALUES (2, N'AmountFromProduct', 1)
INSERT [CouponType] ([CouponTypeID], [CouponTypeName], [Active]) VALUES (3, N'PercentFromOrder', 1)
INSERT [CouponType] ([CouponTypeID], [CouponTypeName], [Active]) VALUES (4, N'AmountFromOrder', 1)
INSERT [CouponType] ([CouponTypeID], [CouponTypeName], [Active]) VALUES (5, N'FreeShippingProduct', 1)
INSERT [CouponType] ([CouponTypeID], [CouponTypeName], [Active]) VALUES (6, N'FreeShippingOrder', 1)
INSERT [CouponType] ([CouponTypeID], [CouponTypeName], [Active]) VALUES (7, N'BuyOneGetOneFree', 1)
SET IDENTITY_INSERT [CouponType] OFF
/****** Object:  Table [dbo].[Province]    Script Date: 06/23/2011 19:22:16 ******/
SET IDENTITY_INSERT [Province] ON
INSERT [Province] ([ProvinceID], [ProvinceName], [ProvinceCode], [Active]) VALUES (1, N'Alberta', N'AB', N'1         ')
INSERT [Province] ([ProvinceID], [ProvinceName], [ProvinceCode], [Active]) VALUES (2, N'British Columbia', N'BC', N'1         ')
INSERT [Province] ([ProvinceID], [ProvinceName], [ProvinceCode], [Active]) VALUES (3, N'Manitoba', N'MB', N'1         ')
INSERT [Province] ([ProvinceID], [ProvinceName], [ProvinceCode], [Active]) VALUES (4, N'New Brunswick', N'NB', N'1         ')
INSERT [Province] ([ProvinceID], [ProvinceName], [ProvinceCode], [Active]) VALUES (5, N'Newfoundland and Labrador', N'NL', N'1         ')
INSERT [Province] ([ProvinceID], [ProvinceName], [ProvinceCode], [Active]) VALUES (6, N'Northwest Territories', N'NT', N'1         ')
INSERT [Province] ([ProvinceID], [ProvinceName], [ProvinceCode], [Active]) VALUES (7, N'Nova Scotia', N'NS', N'1         ')
INSERT [Province] ([ProvinceID], [ProvinceName], [ProvinceCode], [Active]) VALUES (8, N'Nunavut', N'NU', N'1         ')
INSERT [Province] ([ProvinceID], [ProvinceName], [ProvinceCode], [Active]) VALUES (9, N'Ontario', N'ON', N'1         ')
INSERT [Province] ([ProvinceID], [ProvinceName], [ProvinceCode], [Active]) VALUES (10, N'Prince Edward Island', N'PE', N'1         ')
INSERT [Province] ([ProvinceID], [ProvinceName], [ProvinceCode], [Active]) VALUES (11, N'Quebec', N'QC', N'1         ')
INSERT [Province] ([ProvinceID], [ProvinceName], [ProvinceCode], [Active]) VALUES (12, N'Saskatchewan', N'SK', N'1         ')
INSERT [Province] ([ProvinceID], [ProvinceName], [ProvinceCode], [Active]) VALUES (13, N'Yukon', N'YT', N'1         ')
SET IDENTITY_INSERT [Province] OFF
/****** Object:  Table [dbo].[State]    Script Date: 06/23/2011 19:22:16 ******/
SET IDENTITY_INSERT [State] ON
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (1, N'Alabama', N'AL', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (2, N'Alaska', N'AK', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (3, N'American Samoa', N'AS', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (4, N'Arizona', N'AZ', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (5, N'Arkansas', N'AR', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (6, N'California', N'CA', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (7, N'Colorado', N'CO', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (8, N'Connecticut', N'CT', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (9, N'Delaware', N'DE', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (10, N'District of Columbia', N'DC', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (11, N'Federated States of Micronesia', N'FM', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (12, N'Florida', N'FL', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (13, N'Georgia', N'GA', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (14, N'Guam', N'GU', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (15, N'Hawaii', N'HI', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (16, N'Idaho', N'ID', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (17, N'Illinois', N'IL', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (18, N'Indiana', N'IN', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (19, N'Iowa', N'IA', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (20, N'Kansas', N'KS', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (21, N'Kentucky', N'KY', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (22, N'Louisiana', N'LA', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (23, N'Maine', N'ME', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (24, N'Marshall Islands', N'MH', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (25, N'Maryland', N'MD', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (26, N'Massachusetts', N'MA', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (27, N'Michigan', N'MI', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (28, N'Minnesota', N'MN', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (29, N'Mississippi', N'MS', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (30, N'Missouri', N'MO', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (31, N'Montana', N'MT', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (32, N'Nebraska', N'NE', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (33, N'Nevada', N'NV', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (34, N'New Hampshire', N'NH', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (35, N'New Jersey', N'NJ', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (36, N'New Mexico', N'NM', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (37, N'New York', N'NY', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (38, N'North Carolina', N'NC', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (39, N'North Dakota', N'ND', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (40, N'Northern Mariana Islands', N'MP', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (41, N'Ohio', N'OH', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (42, N'Oklahoma', N'OK', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (43, N'Oregon', N'OR', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (44, N'Palau', N'PW', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (45, N'Pennsylvania', N'PA', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (46, N'Puerto Rico', N'PR', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (47, N'Rhode Island', N'RI', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (48, N'South Carolina', N'SC', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (49, N'South Dakota', N'SD', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (50, N'Tennessee', N'TN', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (51, N'Texas', N'TX', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (52, N'Utah', N'UT', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (53, N'Vermont', N'VT', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (54, N'Virgin Islands', N'VI', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (55, N'Virginia', N'VA', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (56, N'Washington', N'WA', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (57, N'West Virginia', N'WV', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (58, N'Wisconsin', N'WI', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (59, N'Wyoming', N'WY', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (60, N'Armed Forces Americas', N'AA', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (61, N'Armed Forces', N'AE', 1)
INSERT [State] ([StateID], [StateName], [StateCode], [Active]) VALUES (62, N'Armed Forces Pacific', N'AP', 1)
SET IDENTITY_INSERT [State] OFF
/****** Object:  Table [dbo].[Tax]    Script Date: 10/27/2011 09:24:20 ******/
SET IDENTITY_INSERT [dbo].[Tax] ON
INSERT [dbo].[Tax] ([TaxID], [TaxName], [Fixed], [Amount], [IsAfterShipping], [CountryID], [StateID], [ProvinceID], [Active]) VALUES (1, N'CA Sales Tax', 0, CAST(9.000 AS Decimal(18, 3)), 0, 230, 6, NULL, 1)
SET IDENTITY_INSERT [dbo].[Tax] OFF
/****** Object:  Table [dbo].[Product]    Script Date: 10/27/2011 09:33:34 ******/
SET IDENTITY_INSERT [dbo].[Product] ON
INSERT [dbo].[Product] ([ProductID], [ProductName], [CatalogNumber], [Description], [Price], [SalePrice], [Weight], [ShippingWeight], [Height], [ShippingHeight], [Length], [ShippingLength], [Width], [ShippingWidth], [ProductLink], [IsDownloadable], [IsDownloadKeyRequired], [IsDownloadKeyUnique], [DownloadURL], [IsReviewEnabled], [TotalReviewCount], [RatingScore], [Active]) VALUES (1, N'My First Product', N'KGH8765', N'This is my first product', 19.9500, 0.0000, CAST(1 AS Decimal(18, 0)), NULL, CAST(20 AS Decimal(18, 0)), NULL, CAST(40 AS Decimal(18, 0)), NULL, CAST(1 AS Decimal(18, 0)), NULL, NULL, 0, 0, 0, NULL, 1, 0, NULL, 1)
SET IDENTITY_INSERT [dbo].[Product] OFF
/****** Object:  Table [dbo].[Category]    Script Date: 10/27/2011 09:33:34 ******/
SET IDENTITY_INSERT [dbo].[Category] ON
INSERT [dbo].[Category] ([CategoryID], [ParentCategoryID], [CategoryName], [Active]) VALUES (1, NULL, N'My First Category', 1)
SET IDENTITY_INSERT [dbo].[Category] OFF
/****** Object:  Table [dbo].[ProductCategory]    Script Date: 10/27/2011 09:33:34 ******/
SET IDENTITY_INSERT [dbo].[ProductCategory] ON
INSERT [dbo].[ProductCategory] ([ProductCategoryID], [ProductID], [CategoryID], [Active]) VALUES (1, 1, 1, 1)
SET IDENTITY_INSERT [dbo].[ProductCategory] OFF
/****** Object:  Table [dbo].[ShippingProvider]    Script Date: 10/27/2011 09:33:34 ******/
SET IDENTITY_INSERT [dbo].[ShippingProvider] ON
INSERT [dbo].[ShippingProvider] ([ShippingProviderID], [ShippingProviderName], [ShippingCost], [Active]) VALUES (1, N'UPS', 19.9500, 1)
INSERT [dbo].[ShippingProvider] ([ShippingProviderID], [ShippingProviderName], [ShippingCost], [Active]) VALUES (2, N'USPS Ground', 12.9500, 1)
SET IDENTITY_INSERT [dbo].[ShippingProvider] OFF