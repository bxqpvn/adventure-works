	Use AdventureWorks2022

	-- General purchase order info
	select top 20 *
	from Purchasing.PurchaseOrderHeader;

	-- Purchase order details
	select top 20 *
	from Purchasing.PurchaseOrderDetail;

	-- Shipping companies
	select 
		ShipMethodID,
		Name, 
		ShipBase,
		ShipRate
	from Purchasing.ShipMethod;

	-- Vendors info, ratings and products
	select top 20
		BusinessEntityID,
		AccountNumber,
		Name,
		CreditRating,
		PreferredVendorStatus,
		ActiveFlag
	from Purchasing.Vendor
	order by CreditRating desc;

	select top 20 *
	from Purchasing.ProductVendor;
