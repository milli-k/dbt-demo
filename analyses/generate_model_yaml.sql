
{% set models_to_generate = codegen.get_models(directory='intermediate/ecomm') %}
{{ codegen.generate_model_yaml(
    model_names = models_to_generate
) }}