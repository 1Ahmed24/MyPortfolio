select*
from CleaningDataPortfolioProject.dbo.HousingInNashville01


-- fixing saledate column

select saledate , CONVERT(date,saledate)
from CleaningDataPortfolioProject.dbo.HousingInNashville01

update CleaningDataPortfolioProject.dbo.HousingInNashville01
SET saledate = CONVERT(date,saledate)

-- if it doesnt work 
 alter table HousingInNashville01
 add saledateconverted date; 

 update CleaningDataPortfolioProject.dbo.HousingInNashville01
SET saledateconverted = CONVERT(date,saledate)


select saledateconverted, CONVERT(date,saledate)
from CleaningDataPortfolioProject.dbo.HousingInNashville01

-- fixing PropertyAddress data (populating)

select PropertyAddress
from HousingInNashville01
where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from HousingInNashville01 a
join HousingInNashville01 b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from HousingInNashville01 a
join HousingInNashville01 b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- breaking out the address column into (address, city, state)

select PropertyAddress
from HousingInNashville01

select
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as address
from HousingInNashville01

alter table HousingInNashville01
add NewPropertyAddress nvarchar(250);

update HousingInNashville01
set NewPropertyAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) 

alter table HousingInNashville01
add NewPropertyCity nvarchar(250);

update
HousingInNashville01
set NewPropertyCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) 

select*
from HousingInNashville01


-- spliting the owner address

select OwnerAddress
from HousingInNashville01

 select
 PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
 PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
 PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
 from HousingInNashville01

 alter table HousingInNashville01
 add OwnerSplitAddress nvarchar (225);
  
 update HousingInNashville01
 set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

 alter table HousingInNashville01
 add OwnerSplitCity nvarchar (225);
  
 update HousingInNashville01
 set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

alter table HousingInNashville01
 add OwnerSplitState nvarchar (225);
  
 update HousingInNashville01
 set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)



 select*
 from HousingInNashville01


 -- Replace Y and N to Yes and No in "Sold as Vacant" field

 select distinct(SoldAsVacant) , count(SoldAsVacant)
 from HousingInNashville01
 group by SoldAsVacant
 order by 2

 select SoldAsVacant,
 case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
 from HousingInNashville01

 update HousingInNashville01
 set SoldAsVacant = case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end


-- Removing Duplicates

with RowNumCTE as(
select*,ROW_NUMBER() OVER(
		PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
						UniqueID
						) row_num

from HousingInNashville01
)
delete
from RowNumCTE
where row_num>1


-- delete unused colums


select* 
from HousingInNashville01

alter table HousingInNashville01
drop column OwnerAddress, TaxDistrict, SaleDate, PropertyAddress