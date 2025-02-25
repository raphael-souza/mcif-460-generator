
class MCIF460Generator
  require Client
  def initialize(output_file)
    @output_file = output_file
    @clientes = []
  end

  def adicionar_cliente(cliente)
    @clientes << Client.new(client)
  end

  def gerar_arquivo
    File.open(@output_file, 'w') do |file|
      gerar_header(file)
      
      # gerar detalhes
      
      
      
      
      @clientes.each_with_index do |cliente, index|
        # file.puts gerar_detalhe(cliente, index + 1)
        generate_detail(file, client)
      end




      file.puts gerar_trailer
    end
  end

  private

  def gerar_header(file, data)
    # 000000024022025MCIF460
    file.puts "0000000#{Time.now.strftime('%d%m%Y')}MCIF460"
    file.puts mci_client_code(data[:mci_client_code])
    file.puts process_number(data[:process_number])
    file.puts sequence_number(data[:sequence_number])
    file.puts layout_version
    file.puts relationship_agency(data[:relationship_agency])
    file.puts dv_relationship_agency(data[:dv_relationship_agency])
    file.puts acount(data[:acount])
    file.puts dv_acount(data[:acount])
    file.puts kit_indicator
    file.puts white_spaces(88)

    file
  end

  def generate_detail(file, client)
    file.puts white_spaces(5)
    file.puts type_detail(client.type_detail)
    file.puts person_type(client.person_type)
    file.puts type_cpf_cnpj(client.type_cpf_cnpj)
    file.puts cpf_cnpj(client.cpf_cnpj)
    file.puts data_nascimento(client.data_nascimento)
    file.puts client_name(client.name)
    file.puts personal_name_client(client.personal_name_client)
    file.puts white_spaces(1)
    file.puts free_use(client.free_use)
    file.puts numero_gestao_agil(client.numero_gestao_agil)
    file.puts client_agency(client.agency)
    file.puts dv_client_agency(client.dv_client_agency)
    file.puts setex_group(client.setex_group)
    file.puts dv_setex_group(client.dv_setex_group)
    file.puts natureza_juridica(client.natureza_juridica)
    file.puts codigo_repasse(client.codigo_repasse)
    file.puts codigo_programa(client.codigo_programa)


    # apos nome personalizado 
  end
  def mci_client_code(code) # 9
    mandatory_field(code)
    validate_numeric(code)

    code.rjust(9, '0')
  end

  # Número_Processo
  def process_number(code='00000') # 5
    mandatory_field(code)
    validate_numeric(code)

    code.rjust(5, '0')
  end

  # Sequencial_Remessa
  def sequence_number(code='00000') # 5
    mandatory_field(code)
    validate_numeric(code)

    code.rjust(5, '0')
  end

  # Versão_Leiaute - valor fixo
  def layout_version
    '04'
  end

  # Agência_Relacionamento
  def relationship_agency(code='0000') # 4
    mandatory_field(code)
    validate_numeric(code)

    code.rjust(4, '0')
  end

  # DV_Agência_Relacionamento
  def dv_relationship_agency(code='0') # 1
    mandatory_field(code)
    validate_numeric(code)

    code.rjust(1, '0')
  end

  # Conta
  def acount(code='00000000000') # 11
    mandatory_field(code)
    validate_numeric(code)

    code.rjust(11, '0')
  end

  # DV Conta
  def dv_acount(code='0') # 1
    mandatory_field(code)
    validate_numeric(code)

    code.rjust(11, '0')
  end

  # Indicador_Envio_KIT - fixo 1
  def kit_indicator
    '1'
  end

  def white_spaces(spaces)
    ''.rjust(spaces, ' ')
  end



  # Detail

  def type_detail
    '01'
  end

  # Tipo_Pessoa - VIDE TABELA
  # 1	Física	E	Soc Economia Mista GDF        
  # 2	PJ Privada	F	Fundação Estadual
  # 3	Governo Municipal - Adm Direta (FUNDOS ESTADUAIS)	G	Fundação Municipal
  # 4	Governo Estadual - Adm Direta	H	Fundação Estadual GDF
  # 5	Governo Federal - Adm Direta	I	Governo Estadual GDF - Adm Direta
  # 6	Empresa Pública Federal	J	Autarquia Federal
  # 7	Soc de Economia Mista Federal	K	Autarquia Estadual
  # 8	Fundação Federal	L	Autarquia Estadual GDF
  # 9	Empresa Pública Estadual	M	Autarquia Municipal 
  # A	Empresa Pública Municipal	N	Inst/Entidade Publica Municipal
  # B	Empresa Pública GDF	O	Inst/Entidade Publica Estadual
  # C	Soc Economia Mista Estadual   	P	Inst/Entidade Publica Federal
  # D	Soc Economia Mista Municipal		
  # E	Soc Economia Mista GDF        
  # F	Fundação Estadual
  # G	Fundação Municipal
  # H	Fundação Estadual GDF
  # I	Governo Estadual GDF - Adm Direta
  # J	Autarquia Federal
  # K	Autarquia Estadual
  # L	Autarquia Estadual GDF
  # M	Autarquia Municipal 
  # N	Inst/Entidade Publica Municipal
  # O	Inst/Entidade Publica Estadual
  # P	Inst/Entidade Publica Federal
  def person_type(type) # 1
    type_formated =  type.to_s.upcase
    raise 'invalide code to person type' if type_formated.match(/\A[A-P1-9]\z/).nil?

    type_formated
  end

  # Tipo de CPF/CNPJ -Fixo "1" para CPF Próprio, ou  "2" para CPF não Próprio, ou "3" para CNPJ
  def type_cpf_cnpj(type) # 1
    raise 'invalide code to person type CPF/CNPJ' unless ['1', '2', '3'].include?(type.to_s)

    type
  end

  def cpf_cnpj(value) #14
    raise 'invalide cpf or cnpj' if !is_integer?(value) && (value != 14 && value !=11)
  
    value.rjust(14, '0')
  end
  
  # Data_Nascimento
  def data_nascimento(date) #8
    raise 'invalid date' if !is_integer?(date) || date.length != 8

    date
  end

  # Nome_Cliente
  def client_name(name) #60
    name.ljust(60, ' ')
  end

  # Nome_Personalizado_Cliente
  def personal_name_client(name) #25
    name.ljust(25, ' ')
  end

  # Uso_Cliente
  def free_use(text) # 8 
    text(8, ' ')
  end

  # Numero_Programa_Gestão_Agil
  def numero_gestao_agil(num) # 9
    validate_alphanumeric(num)

    num.rjust(9, '0')
  end

  # Agência_Cliente
  def client_agency(ag) #4
    validate_numeric(ag)
    raise 'Invalida client Agency', if ag.to_s.length > 4
    
    ag.rjust(4, '0')
  end

  # DV_Agência_Cliente
  def dv_client_agency(code)
    validate_numeric(code)
    
    raise 'invalid DV Agency' if code.to_s != 1
    
    code
  end


  # Grupo_Setex
  def setex_group(code) # 2
    validate_numeric(code)
    raise 'valor obrigatório. 2 dígitos' if code.length != 2

    code
  end

  # DV_Grupo Setex
  def dv_setex_group(code)
    validate_numeric(code)
    raise 'valor obrigatório. 1 dígito' if code.length != 1

    code
  end

  # Natureza_Jurídica
  def natureza_juridica # 3
    '000'
  end
  
  # Código_Repasse -  Fixo "01" para Voluntário/Convênio OU "02" para Automático/Fundo a Fundo
  def codigo_repasse(code) # 2
    raise 'Invalide code' unless ['01', '02'].include?(code.to_s) if code.present?

    code
  end

  # Código_Programa
  def codigo_programa(code) #3
    validate_numeric(code)
    code.rjust(9, '0')
  end

  def gerar_trailer(file, total_clients, quantity_registries)  # 5
    constante = "9999999".ljust(150, ' ')
    total = "#{total_clients}".rjust(5, '0')
    # Quantidade_Registros - Total de Registros (inclusive HEADER e TRAILER)
    quantity_registries.ljust(9, ' ')
    # 129 espaços em branco
    "#{constante}#{total}#{quantity_registries}".rjust(129, ' ')
  end


  def validate_alphanumeric(string)
    raise 'invalide data' if string.match(/\A[a-zA-Z0-9]*\z/).nil?
  end

  def validate_numeric(string)
    raise 'invalide data' if string.match(/\A[0-9]*\z/).nil?
  end

  def is_mandatory(code)
    raise 'mandatory field' if code.nil?
  end

  def is_integer?(number)
    Integer(number) rescue false
  end
end

# Exemplo de uso
clientes = [
  { cpf: '12345678901', data_nascimento: Date.new(1990, 1, 1), nome: 'João Silva', agencia: 1234, conta: 567890 },
  { cpf: '98765432100', data_nascimento: Date.new(1985, 5, 15), nome: 'Maria Souza', agencia: 5678, conta: 123456 }
]

gerador = MCIF460Generator.new('remessa.txt')
clientes.each { |cliente| gerador.adicionar_cliente(cliente) }
gerador.gerar_arquivo

puts 'Arquivo de remessa gerado com sucesso!'