{{ config(alias='distribution_centers') }}

select
  {{ dbt_utils.star(source('ecomm', 'distribution_centers')) }}
from {{ source('ecomm', 'distribution_centers') }}