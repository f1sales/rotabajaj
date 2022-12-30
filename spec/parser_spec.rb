require 'ostruct'
require 'byebug'
require 'faker'

RSpec.describe F1SalesCustom::Email::Parser do
  let(:customer_name) { Faker::Name.name }
  let(:customer_phone) { Faker::Number.number(digits: 11).to_s }
  let(:customer_email) { Faker::Internet.email }
  let(:customer_cpf) { Faker::Number.number(digits: 11).to_s }
  let(:customer_rg) { Faker::Number.number(digits: 9).to_s }
  let(:customer_cnh) { Faker::Number.number(digits: 10).to_s }

  context 'when came from the website formulário de Test Ride' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@rotabajaj.f1sales.net']
      email.subject = "Test Ride #{customer_name} - Formulário Rota B"
      email.body = "\nNome: #{customer_name}\nTelefone: #{customer_phone}\nE-mail: #{customer_email}\nData Nascimento: 1971-06-27\nRG: #{customer_rg}\nCPF: #{customer_cpf}\nCNH: #{customer_cnh}\nData: 2022-12-29\nHorário: 10:00\nEstado: SP\nCidade: JUNDIAI\nModelo: Dominar 400\nConsultor: Caio\nConcorod com termos: [checkbox-concordotermos]\nCiente: [checkbox-cienteparticipante]\nQuero receber comunicações? [checkbox-recebercomunicacoes]"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq('Website')
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq(customer_name)
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq(customer_phone)
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq(customer_email)
    end

    it 'contains cpf' do
      expect(parsed_email[:customer][:cpf]).to eq(customer_cpf)
    end

    it 'contains product name' do
      expect(parsed_email[:product][:name]).to eq('Dominar 400')
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq("Data de Nascimento: 1971-06-27 - CNH: #{customer_cnh} - RG: #{customer_rg} - Consultor: Caio")
    end
  end
end
