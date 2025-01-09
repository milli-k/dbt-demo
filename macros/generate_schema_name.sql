{% macro generate_schema_name(custom_schema_name, node) -%}
    {{ log("Target name: " ~ target.name, info=True) }}
    {{ log("Custom schema name: " ~ custom_schema_name, info=True) }}
    {{ log("Default schema: " ~ target.schema, info=True) }}

    {%- set default_schema = target.schema -%}
    {%- set environment_type = env_var('DBT_ENVIRONMENT', 'dev') -%}

    {%- if environment_type == 'dev' and custom_schema_name is not none -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- elif environment_type == 'prod' and custom_schema_name is not none -%}
        {{ custom_schema_name | trim }}
    {%- else -%}
        {{ default_schema }}
    {%- endif -%}

{%- endmacro %}