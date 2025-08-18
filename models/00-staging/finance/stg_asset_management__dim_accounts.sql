select
  {{ dbt_utils.star(source('asset_management', 'dim_accounts')) }}
from {{ source('asset_management', 'dim_accounts') }}