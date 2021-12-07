# Meilisearch on Azure

Infrastructure as code for hosting [Meilisearch](https://www.meilisearch.com) on Azure

## Quick usage

You can use these buttons to deploy a Meilisearch app on Azure already configured. **Please** change the _Application Name_ parameter by something unique and the _API Key_ to secure your instance.

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcmaneu%2Fmeilisearch-on-azure%2Fmain%2Fmain.json)  
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcmaneu%2Fmeilisearch-on-azure%2Fmain%2Fmain.json)
[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fcmaneu%2Fmeilisearch-on-azure%2Fmain%2Fmain.json)


## Usage with CLI

1. Ensure you have the Azure CLI installed, update to date and you're logged in.
2. Execute the following command line, while replacing the approriate values `az deployment sub create --name meilisearch --template-file .\main.bicep -l eastus --parameters applicationName=MYAPPLICATIONNAME`

## Licence

This template are provided under MIT licence.