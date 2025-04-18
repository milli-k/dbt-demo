with 

source as (

    select * from {{ source('finance', 'quarterly_results') }}

),

renamed as (

    select
        company,
        statement_name,
        fiscal_quarter,
        fiscal_year,
        filing_date,
        period_end_date,
        line_item_name,
        line_item_value,
        unit_name

    from source

)

select * from renamed
