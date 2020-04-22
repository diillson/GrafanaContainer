# Alpine-grafana com ZABBIX

## Container for Alpine Linux + Grafana + Zabbix

O container está pronto para iniciar o Grafana usando o Alpine com as seguintes funcionalidades:

- Configurar o plugin do Zabbix;
- Configurar o datasource do Zabbix (necessário alterar para um ambiente de produção);
- Configurar uns dashboards usando o Provisioning 

> Nas versões anteriores do Grafana, você só podia usar a API para provisionar fontes de dados e painéis. Mas isso exigia a execução do serviço antes de você começar a criar painéis e também precisava configurar credenciais para a API HTTP. Na v5.0, decidimos melhorar essa experiência adicionando um novo sistema de provisionamento ativo que usa arquivos de configuração. Isso tornará o GitOps mais natural, pois as fontes de dados e os painéis podem ser definidos por meio de arquivos que podem ser controlados por versão. Esperamos estender esse sistema para adicionar posteriormente suporte a usuários, organizações e alertas.

> fonte: https://grafana.com/docs/grafana/latest/administration/provisioning/

Existe ainda uma pre configuração de LDAP no arquivo ldap.toml