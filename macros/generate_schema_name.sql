{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
<<<<<<< HEAD

    {%- if target.name == 'dev' and custom_schema_name is not none -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- elif target.name == 'prod' and custom_schema_name is not none -%}
=======
    {%- set environment_type = env_var('DBT_ENVIRONMENT', 'dev') -%}

    {%- if environment_type == 'dev' and custom_schema_name is not none -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- elif environment_type == 'prod' and custom_schema_name is not none -%}
>>>>>>> eb8a6646b17976bc5cdc9464675d409421c72b56
        {{ custom_schema_name | trim }}
    {%- else -%}
        {{ default_schema }}
    {%- endif -%}

{%- endmacro %}