select *
from {{ source('asset_management', 'dim_accounts') }}