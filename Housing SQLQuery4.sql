SELECT *
From project1.dbo.[Nashville Housing]

--Standardize Date Format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM project1.dbo.[Nashville Housing]

Update [Nashville Housing]
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE [Nashville Housing]
DROP COLUMN SaleDateConverted;

ALTER Table [Nashville Housing]
Add SaleDateConverted Date;

UPDATE [Nashville Housing]
SET SaleDateConverted = CONVERT(Date, SaleDate)


-- Populate Property Address data

SELECT *
From project1.dbo.[Nashville Housing]
--Where Property Address is Null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From project1.dbo.[Nashville Housing] a
JOIN project1.dbo.[Nashville Housing] b
	on a.ParcelID = b. ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- While using JOIN, UPDATE ypu cannot use [Nashville Housing], you have to use alias names

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From project1.dbo.[Nashville Housing] a
JOIN project1.dbo.[Nashville Housing] b
	on a.ParcelID = b. ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking down Address into individual Columns (Address, City, State)

SELECT PropertyAddress
From project1.dbo.[Nashville Housing]
--Where Property Address is Null
--order by ParcelID


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From project1.dbo.[Nashville Housing]

ALTER TABLE [Nashville Housing]
DROP COLUMN PropertySplitAddress;

ALTER Table [Nashville Housing]
Add PropertySplitAddress Nvarchar(255);

UPDATE [Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [Nashville Housing]
DROP COLUMN PropertySplitCity;

ALTER Table [Nashville Housing]
Add PropertySplitCity Nvarchar(255);

UPDATE [Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
From project1.dbo.[Nashville Housing]


SELECT OwnerAddress
From project1.dbo.[Nashville Housing]

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From project1.dbo.[Nashville Housing]


ALTER Table [Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);

UPDATE [Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER Table [Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

UPDATE [Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER Table [Nashville Housing]
Add OwnerSplitState Nvarchar(255);

UPDATE [Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


SELECT *
From project1.dbo.[Nashville Housing]


--change Y and N to Yes and No in "Sold As Vacant"

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From project1.dbo.[Nashville Housing]
Group by SoldAsVacant
Order by 2




Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
From project1.dbo.[Nashville Housing]

Update [Nashville Housing]
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End



-- Remove Duplicates


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				    UniqueID
					) row_num

From project1.dbo.[Nashville Housing]
)


Select *
From RowNumCTE
Where row_num > 1
Order By PropertyAddress


--- to delete duplicates 


----Delete 
---From RowNumCTE
---Where row_num > 1
--Order By PropertyAddress



-----Delete Unused Columns




SELECT *
From project1.dbo.[Nashville Housing]


Alter Table project1.dbo.[Nashville Housing]
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table project1.dbo.[Nashville Housing]
Drop Column SaleDate

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




