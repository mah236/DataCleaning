select *
from PortfolioProject.dbo.[National Housing]

--Standardize Date Format 

select SaleDateConverted, CONVERT (Date, SaleDate)
from PortfolioProject.dbo.[National Housing]

update [National Housing] 
set SaleDate = CONVERT (Date, SaleDate)

ALTER TABLE [National Housing]
Add SaleDateConverted Date; 

update [National Housing] 
set SaleDateConverted = CONVERT (Date, SaleDate)


--Populate Property Address data 

select *
from PortfolioProject.dbo.[National Housing]
--where PropertyAddress IS NULL 
ORDER BY ParcelID

select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL (A.PropertyAddress, B.PropertyAddress)
from PortfolioProject.dbo.[National Housing] A
JOIN PortfolioProject.dbo.[National Housing] B
ON A.ParcelID = B.ParcelID 
AND A.[UniqueID ]<>B.[UniqueID ]
WHERE A.PropertyAddress is null 

Update a  
SET PropertyAddress = ISNULL (A.PropertyAddress, B.PropertyAddress)  
from PortfolioProject.dbo.[National Housing] A
JOIN PortfolioProject.dbo.[National Housing] B
ON A.ParcelID = B.ParcelID 
AND A.[UniqueID ]<>B.[UniqueID ]
WHERE A.PropertyAddress is null 

-- Breaking Out Address into individual column 

select PropertyAddress
from PortfolioProject.dbo.[National Housing]
--where PropertyAddress IS NULL 
--ORDER BY ParcelID

select 
SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1) as address 
, SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN (PropertyAddress)) as address 

from PortfolioProject.dbo.[National Housing]


ALTER TABLE PortfolioProject.dbo.[National Housing]
Add PropertySplitAddress nvarchar(255); 

update PortfolioProject.dbo.[National Housing] 
set PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1)

ALTER TABLE PortfolioProject.dbo.[National Housing]
Add PropertySplitcity nvarchar(255); 

update PortfolioProject.dbo.[National Housing] 
set PropertySplitcity = SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN (PropertyAddress))

Select *
from PortfolioProject.dbo.[National Housing]





Select OwnerAddress
from PortfolioProject.dbo.[National Housing]

select 
PARSENAME(replace (OwnerAddress, ',','.') , 3) 
, PARSENAME(replace (OwnerAddress, ',','.') , 2)
, PARSENAME(replace (OwnerAddress, ',','.') , 1)
from PortfolioProject.dbo.[National Housing]



ALTER TABLE PortfolioProject.dbo.[National Housing]
Add OwnerSplitAddress nvarchar(255); 

update PortfolioProject.dbo.[National Housing] 
set OwnerSplitAddress = PARSENAME(replace (OwnerAddress, ',','.') , 3)

ALTER TABLE PortfolioProject.dbo.[National Housing]
Add OwnerSplitcity nvarchar(255); 

update PortfolioProject.dbo.[National Housing] 
set OwnerSplitcity = PARSENAME(replace (OwnerAddress, ',','.') , 2)

ALTER TABLE PortfolioProject.dbo.[National Housing]
Add OwnerSplitState nvarchar(255); 

update PortfolioProject.dbo.[National Housing] 
set OwnerSplitState = PARSENAME(replace (OwnerAddress, ',','.') , 1)


Select *
from PortfolioProject.dbo.[National Housing]

--Change Y and N TO Yes and No in "Sold as Vacant" field 

Select distinct (SoldAsVacant), COUNT (SoldAsVacant)
from PortfolioProject.dbo.[National Housing]
group by SoldAsVacant
order by 2




select SOldAsVacant 
, CASE WHEN SOldAsVacant = 'Y' THEN 'Yes'
       when SOldAsVacant = 'N' Then 'No'
	   Else SOldAsVacant
	   END 
from PortfolioProject.dbo.[National Housing]

Update PortfolioProject.dbo.[National Housing]
set SOldAsVacant = CASE WHEN SOldAsVacant = 'Y' THEN 'Yes'
       when SOldAsVacant = 'N' Then 'No'
	   Else SOldAsVacant
	   END 


--remove duplicates 
WITH RowNumCTE AS (
select *, ROW_NUMBER() OVER (
PARTITION BY parcelID,
             PropertyAddress,
			 SalePrice,
			 Saledate,
			 LegalReference 
			 ORDER BY
			 UniqueID
			 ) row_num 

FROM PortfolioProject.dbo.[National Housing]
--order by ParcelID 
)
SELECT * FROM RowNumCTE
WHERE row_num > 1
Order By PropertyAddress

--order by PropertyAddress

select * 
FROM PortfolioProject.dbo.[National Housing]


--Delete unused column 

select * 
FROM PortfolioProject.dbo.[National Housing]

ALTER TABLE PortfolioProject.dbo.[National Housing]
DROP COLUMN owneraddress, TaxDistrict, PropertyAddress 

ALTER TABLE PortfolioProject.dbo.[National Housing]
DROP COLUMN SaleDate
