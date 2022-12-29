# frozen_string_literal: true

require_relative 'rotabajaj/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_helpers'

module Rotabajaj
  class Error < StandardError; end

  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website'
        }
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      {
        source: source,
        customer: customer,
        product: product,
        description: lead_description
      }
    end

    def parsed_email
      @email.body.colons_to_hash(/(#{regular_expression}).*?:/, false)
    end

    def regular_expression
      'Nome|Fone|Telefone|E-mail|Pagina|Interesse|Unidade|Resposta|Mensagem|CPF|CNH|RG|Data Nascimento|
      Horario|Modelo|Consultor|Concorod com termos|Data'
    end

    def source
      {
        name: source_website
      }
    end

    def source_website
      F1SalesCustom::Email::Source.all[0][:name]
    end

    def customer
      {
        name: customer_name,
        phone: customer_phone,
        email: customer_email,
        cpf: customer_cpf
      }
    end

    def customer_name
      parsed_email['nome']
    end

    def customer_phone
      parsed_email['fone'] || parsed_email['telefone']
    end

    def customer_email
      parsed_email['email']&.split&.first || ''
    end

    def customer_cpf
      parsed_email['cpf'] || ''
    end

    def product
      {
        name: parsed_email['modelo']
      }
    end

    def lead_description
      "Data de Nascimento: #{birth_date} - CNH: #{customer_cnh} - RG: #{customer_rg} - Consultor: #{consultant}"
    end

    def birth_date
      parsed_email['data_nascimento']
    end

    def customer_cnh
      parsed_email['cnh']
    end

    def customer_rg
      parsed_email['rg']
    end

    def consultant
      parsed_email['consultor']
    end
  end
end
